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
    irq     : out std_logic;

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
    signal stall_s      : std_logic := '0';
begin
    dat_o(31 downto 8)  <= (others => '0');
    stall_o             <= stall_s;
    err_o               <= '0';
    rty_o               <= '0';

    control: process(clk_i, rst_i, stall_s)
    begin
        if rst_i = '1' then
            enable_read     <= '0';
            enable_write    <= '0';
            ack_o           <= '0';
        else 
            if rising_edge(clk_i) then
                if stb_i = '1' then
                    enable_read <= not we_i;
                    enable_write <= we_i;

                    if stall_s = '0' then
                        ack_o <= '1';
                    end if;
                else
                    enable_read <= '0';
                    enable_write <= '0';
                    ack_o <= '0';
                end if;
            end if;
        end if;
    end process;

    uart: entity plasma_lib.uart
    generic map (log_file => log_file)
    port map
    (
        clk          => clk_i,
        reset        => rst_i,

        enable_read  => enable_read, 
        enable_write => enable_write, 
        data_in      => dat_i(7 downto 0),
        data_out     => dat_o(7 downto 0),
        uart_read    => rx,
        uart_write   => tx,
        busy_write   => stall_s,
        data_avail   => irq
    );
end behavior;