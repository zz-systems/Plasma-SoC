library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

library plasmax_lib;
    use plasmax_lib.util_pkg.all;

entity fifo is
    generic(
        buckets : natural := 4;
        bucket_width : natural := 8;
        direction : FIFO_DIRECTION := LEFT;
        autoreset : std_logic := '0'
    );
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        en          : in std_logic;
        
        dout        : out std_logic_vector(buckets * bucket_width - 1 downto 0);
        din         : in std_logic_vector(bucket_width - 1 downto 0);
        overflow    : out std_logic
    );
end fifo;

architecture behavior of fifo is
    signal counter, counter_s : integer;
    signal overflow_s : std_logic;
    signal data, data_s : std_logic_vector(dout'range);
begin

    proc : process(clk, reset)
    begin
        if reset = '1' then
            data <= (others => '0');
            data_s <= (others => '0');
        elsif rising_edge(clk) then

            if autoreset = '1' then
                counter_s <=  counter + 1;

                if overflow_s = '1' then
                    data <= (others => '0');
                    data_s <= (others => '0');

                    counter <= 0;
                    overflow_s <= '0';
                end if;
            end if;

            data <= data_s;
            counter <= counter_s;

            if en = '1' then
                if counter = buckets then
                    overflow_s <= '1';
                elsif direction = LEFT then
                    data_s <= data((buckets - 1) * bucket_width - 1 downto 0) & din;
                else
                    data_s <= din & data(buckets * bucket_width - 1 downto bucket_width);
                end if;
            end if;
        end if;
    end process;

    dout <= data_s;
    overflow <= overflow_s;
end;
