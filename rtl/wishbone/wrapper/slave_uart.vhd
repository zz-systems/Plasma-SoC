--------------------------------------------------------------------------------
-- TITLE:  Plasma UART controller Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- INTERRUPT CONTROLLER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0x00      | r/w   | control register
-- status       | 0x04      | r     | status register
-- data         | 0x0C      | r/w   | UART RX/TX
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | reset device
-- enable       | 1         | r/w   | enable device
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | device ready
-- davail       | 1         | r     | data available
----------------|-----------|-------|-------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity slave_uart is 
generic
(
    log_file : string := "UNUSED"
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    tx      : out std_logic;
    rx      : in std_logic;
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
end slave_uart;

architecture behavior of slave_uart is 
    signal enable_read  : std_logic := '0';
    signal enable_write : std_logic := '0';
    
    signal ctrl_s       : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s       : std_logic_vector(31 downto 0) := (others => '0');
    
    signal dat_tx       : std_logic_vector(7 downto 0) := (others => '0');
    signal dat_rx       : std_logic_vector(7 downto 0) := (others => '0');
    signal dat_os       : std_logic_vector(31 downto 0) := (others => '0');

    signal ack_s   : std_logic := '0';
    signal err_s   : std_logic := '0';

    alias stat_ready_a      : std_logic is stat_s(0);
    alias stat_davail_a     : std_logic is stat_s(1);

    alias ctrl_reset_a      : std_logic is ctrl_s(0);
    alias ctrl_enable_a     : std_logic is ctrl_s(1);

    signal stat_busy_s      : std_logic := '0';
begin
    stat_ready_a <= not stat_busy_s;

    irq_o   <= stat_davail_a;

    dat_o   <= dat_os;

    ack_o   <= ack_s;
    rty_o   <= '0';
    stall_o <= stat_busy_s;
    err_o   <= err_s;

    control: process(clk_i, rst_i)
        variable ack_v  : std_logic := '0';
        variable err_v  : std_logic := '0';
    begin
        if rst_i = '1' then
            enable_read     <= '0';
            enable_write    <= '0';
            
            ctrl_s  <= (others => '0');
            dat_os  <= (others => '0');
            dat_tx  <= (others => '0');

            ack_s   <= '0';
            err_s   <= '0';  
        elsif rising_edge(clk_i) then     
            ack_v := '0';
            err_v := '0';

            if stb_i = '1' then
                ack_v := '1';

                enable_read <= not we_i;
                enable_write <= we_i;

                if we_i = '0' then
                    case adr_i(3 downto 0) is
                        when x"0" => dat_os      <= ctrl_s;
                        when x"4" => dat_os      <= stat_s;
                        when x"8" => dat_os      <= ZERO(31 downto 8) & dat_rx;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(3 downto 0) is
                        when x"0" => ctrl_s      <= dat_i;
                        when x"8" => dat_tx      <= dat_i(7 downto 0);
                        when others => err_v    := '1';
                    end case;
                end if;
            else                    
                enable_read <= '0';
                enable_write <= '0';
            end if;
                
            ack_s <= ack_v and not err_v;
            err_s <= err_v;
        end if;
    end process;

    uart: entity plasma_lib.uart
    generic map (log_file => log_file)
    port map
    (
        clk          => clk_i,
        reset        => rst_i or ctrl_reset_a,

        enable_read  => enable_read and ctrl_enable_a, 
        enable_write => enable_write and ctrl_enable_a, 
        data_in      => dat_tx,
        data_out     => dat_rx,
        uart_read    => rx,
        uart_write   => tx,
        busy_write   => stat_busy_s,
        data_avail   => stat_davail_a
    );
end behavior;