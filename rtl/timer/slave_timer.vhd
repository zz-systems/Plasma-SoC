--------------------------------------------------------------------------------
-- TITLE:  Timer Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- TIMER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0x0       | r/w   | control register
-- status       | 0x4       | r     | status register
-- data         | 0x8       | r     | current timer value
-- reload       | 0xC       | r/w   | reload value on overflow
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | user reset
-- enable       | 1         | r/w   | enable timer
-- autoreload   | 2         | r/w   | reload on overflow
-- unit         | 3:5       | r/w   | timer measurement unit
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | timer ready
-- overflow     | 1         | r     | timer overflow, reloaded
----------------|-----------|-------|-------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

entity slave_timer is 
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    irq_o   : out std_logic;

    cyc_i   : in std_logic;
    stb_i   : in std_logic;
    we_i    : in std_logic;

    adr_i   : in std_logic_vector(31 downto 0);
    dat_i   : in std_logic_vector(31 downto 0);

    sel_i   : in std_logic_vector(3 downto 0);

    dat_o   : out  std_logic_vector(31 downto 0);
    ack_o   : out std_logic;
    rty_o   : out std_logic;
    stall_o : out std_logic;
    err_o   : out std_logic
);
end slave_timer;

architecture behavior of slave_timer is 
    signal ctrl_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s  : std_logic_vector(31 downto 0) := (others => '0');

    signal dat_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_os  : std_logic_vector(31 downto 0) := (others => '0');
    
    signal rld_s   : std_logic_vector(31 downto 0) := (others => '0');
    signal cnt_s   : std_logic_vector(31 downto 0) := (others => '0');
    
    signal ack_s        : std_logic := '0';
    signal err_s        : std_logic := '0';
    
    alias stat_ready_a      : std_logic is stat_s(0);
    alias stat_overflow_a   : std_logic is stat_s(1);

    alias ctrl_rst_a        : std_logic is ctrl_s(0);
    alias ctrl_en_a         : std_logic is ctrl_s(1);
    alias ctrl_autoreload_a : std_logic is ctrl_s(2);
    alias ctrl_unit_a       : std_logic_vector(2 downto 0) is ctrl_s(5 downto 3);
begin
    irq_o   <= stat_overflow_a;    

    dat_o   <= dat_os;

    ack_o   <= ack_s;
    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= err_s;

    stat_ready_a <= '1';

    process(clk_i, rst_i)
        variable ack_v  : std_logic := '0';
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            ctrl_s  <= (others => '0');

            dat_is  <= (others => '0');
            dat_os  <= (others => '0');

            rld_s   <= (others => '0');

            ack_s   <= '0';
            err_s   <= '0';  
        elsif rising_edge(clk_i) then
            ack_v := '0';
            err_v := '0';

            if stb_i = '1' then
                ack_v := '1';

                if we_i = '0' then
                    case adr_i(3 downto 0) is
                        when x"0" => dat_os     <= ctrl_s;
                        when x"4" => dat_os     <= stat_s;
                        when x"8" => dat_os     <= cnt_s;
                        when x"C" => dat_os     <= rld_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(3 downto 0) is
                        when x"0" => ctrl_s     <= dat_i;
                        when x"C" => rld_s      <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
            end if;

            ack_s <= ack_v and not err_v;
            err_s <= err_v;
        end if;
    end process;

    timer: entity plasmax_lib.timer
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i or ctrl_rst_a,

        en_i    => ctrl_en_a and ((not stat_overflow_a) or ctrl_autoreload_a),
        rld_i   => rld_s,
        unit_i  => ctrl_unit_a,
        cnt_o   => cnt_s,

        irq_o   => stat_overflow_a
    );

end behavior;