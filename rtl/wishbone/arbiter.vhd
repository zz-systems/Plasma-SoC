-- plasma system bus
-- @author Sergej Zuyev

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


library plasmax_lib;
    use plasmax_lib.wb_pkg.all;
    use plasmax_lib.util_pkg.all;

entity arbiter is
    generic(
        channel_descriptors : cdesc_t;
        constant channels : natural := 1
    );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;

        -- is channel interruptible?
        interruptible_i : in std_logic_vector(channels - 1 downto 0);

        -- bus busy?
        busy_i          : in std_logic;

        -- channel select
        cs_o            : out std_logic_vector(bit_width(channels) downto 0)
    );
end arbiter;

architecture behavior of arbiter is

    type states is (evaluate, await_interruptible, await_uninterruptible, reschedule);
    signal state : states;

    signal channel, channel_s       : natural;
    signal counter, counter_s       : natural;
    
    signal cs_s : std_logic_vector(cs_o'range);
begin

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state <= evaluate;

            channel         <= 0;
            counter         <= 0;
        else
            if rising_edge(clk_i) then
                channel         <= channel_s;
                counter         <= counter_s;

                case state is
                    when evaluate => 
                        counter_s <= channel_descriptors(channel);--.priority;

                        if interruptible_i(channel) = '1' then
                            state <= await_interruptible;
                        else 
                            state <= await_uninterruptible;
                        end if;

                    when await_interruptible =>
                        if counter = 0 then
                            state <= reschedule;
                        else
                            counter_s <= counter - 1;
                        end if;

                    when await_uninterruptible =>
                        state <= evaluate;

                    when reschedule =>
                        if busy_i = '0' then
                            if (channel < channels - 1) then
                                channel_s <= (channel + 1);
                            else 
                                channel_s <= 0;
                            end if;
                        end if;

                        state <= evaluate;
                end case;

                cs_s <= std_logic_vector(to_unsigned(channel, cs_s'length));
            end if;
        end if;
    end process;
    
    cs_o <= cs_s;
end;
