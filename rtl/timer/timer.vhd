library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
library plasmax_lib;

package timer_pkg is
    subtype unit_t is std_logic_vector(2 downto 0);

    constant unit_ticks : unit_t := "000";
    constant unit_nsec  : unit_t := "001";
    constant unit_usec  : unit_t := "010";
    constant unit_msec  : unit_t := "011";
    constant unit_sec   : unit_t := "100";
end package timer_pkg;


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
   
library plasmax_lib;
    use plasmax_lib.timer_pkg.all;
    use plasmax_lib.util_pkg.all;
    
-- timer
----------------|-----------|------------------------------------
-- unit         | value     | description
----------------|-----------|------------------------------------
-- ticks        | 0         | 
-- nanoseconds  | 1         |
-- microseconds | 2         | 
-- milliseconds | 3         | 
-- seconds      | 4         | 
----------------|-----------|------------------------------------
entity timer is
generic 
(
    constant sys_clk    : positive := 50000000;
    constant data_w     : positive := 32
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    en_i    : in std_logic;
    unit_i  : in std_logic_vector(2 downto 0);
    rld_i   : in std_logic_vector(data_w - 1 downto 0);
    cnt_o   : out std_logic_vector(data_w - 1 downto 0);

    irq_o   : out std_logic
);
end;

architecture behavior of timer is
    constant ticks_per_s    : natural := sys_clk;
    constant ticks_per_ms   : natural := ticks_per_s / 1000;
    constant ticks_per_us   : natural := ticks_per_ms / 1000;
    constant ticks_per_ns   : natural := max(ticks_per_us / 1000, 1); -- highest resolution: 1 tick
    constant ticks_per_tick : natural := 1;

    signal unit_s           : unit_t;
    signal rld_s            : unsigned(data_w + 31 downto 0);

    signal cnt_s            : std_logic_vector(data_w + 31 downto 0) := (others => '0');
begin
    cnt_o <= cnt_s(cnt_o'range);

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
        else
            if rising_edge(clk_i) then
                unit_s <= unit_t(unit_i);

                case unit_s is 
                    when unit_ticks => 
                        rld_s <= unsigned(rld_i) * to_unsigned(ticks_per_tick, 32);
                    when unit_nsec => 
                        rld_s <= unsigned(rld_i) * to_unsigned(ticks_per_ns, 32);
                    when unit_usec => 
                        rld_s <= unsigned(rld_i) * to_unsigned(ticks_per_us, 32);
                    when unit_msec => 
                        rld_s <= unsigned(rld_i) * to_unsigned(ticks_per_ms, 32);
                    when unit_sec => 
                        rld_s <= unsigned(rld_i) * to_unsigned(ticks_per_s, 32);
                    when others =>
                        rld_s <= to_unsigned(ticks_per_tick, data_w + 32);
                end case;
            end if;
        end if;
    end process;

    counter: entity plasmax_lib.counter
    generic map
    (
        data_w => data_w + 32
    )
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        en_i    => en_i,
        rld_i   => std_logic_vector(rld_s),
        dir_i   => '0',
        cnt_o   => cnt_s,

        irq_o  => irq_o
    );
end behavior;