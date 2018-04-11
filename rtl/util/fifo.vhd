library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

library zz_systems;
    use zz_systems.util_pkg.all;

entity fifo is
generic
(
    buckets         : positive := 4;
    bucket_width    : positive := 8;
    direction       : FIFO_DIRECTION := LEFT;
    autoreset       : std_logic := '1'
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;
    en_i    : in std_logic;
    
    rld_i   : in std_logic_vector(buckets * bucket_width - 1 downto 0);
    dat_o   : out std_logic_vector(buckets * bucket_width - 1 downto 0);
    dat_i   : in std_logic_vector(bucket_width - 1 downto 0);

    irq_o   : out std_logic
);
end fifo;

architecture behavior of fifo is
    signal counter, counter_s : integer;
    signal overflow_s : std_logic;
    signal data, data_s : std_logic_vector(dat_o'range);
begin

    process(clk_i, rst_i)
        variable data_v     : std_logic_vector(dat_o'range)     := (others => '0');
        variable counter_v  : unsigned(buckets - 1 downto 0)    := (others => '0');
    begin
        if reset = '1' then
            data_v      := rld_i;
            dat_o       <= rld_i;
            counter_v   := 0;
        elsif rising_edge(clk) then

            if autoreset = '1' then
                counter_v :=  counter_v + 1;

                if overflow_s = '1' then
                    data_v      := rld_i;
                    counter_v   := 0;

                    overflow_s  <= '0';
                end if;
            end if;

            if en_i = '1' then
                if counter = buckets then
                    overflow_s <= '1';
                elsif direction = LEFT then
                    data_v := data_v((buckets - 1) * bucket_width - 1 downto 0) & din;
                else
                    data_v := din & data_v(buckets * bucket_width - 1 downto bucket_width);
                end if;
            end if;

            dat_o <= data_v;
        end if;
    end process;

    irq_o <= overflow_s;
end;
