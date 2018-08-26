-- plasma system bus
-- @author Sergej Zuyev

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


library zz_systems;
    use zz_systems.wb_pkg.all;
    use zz_systems.util_pkg.all;

entity arbiter is
    generic
    (
        constant channels : natural := 1
    );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;

        -- channel grant request
        cgrq_i          : in std_logic_vector(channels - 1 downto 0);

        -- channel select
        cs_o            : out std_logic_vector(bit_width(channels) downto 0)
    );
end arbiter;

architecture behavior of arbiter is
    signal channel, channel_s : natural;
begin

    process(clk_i, rst_i, cgrq_i)
    begin
        if rst_i = '1' then
            channel         <= 0;
            channel_s       <= 0;
            cs_o            <= (others => '0');
        else
            if rising_edge(clk_i) then
                channel         <= channel_s;

                -- if previous bus owner frees the bus, select the next bus owner
                if cgrq_i(channel) = '0' then
                    for i in cgrq_i'range loop
                        if cgrq_i(i) = '1' then
                            channel_s <= i;
                        end if;
                    end loop;
                end if;

                cs_o <= std_logic_vector(to_unsigned(channel, cs_o'length));
            end if;
        end if;
    end process;
end;
