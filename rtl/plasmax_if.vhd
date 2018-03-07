library ieee;
use ieee.std_logic_1164.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;
    use plasmax_lib.wb_pkg.all;
    use plasmax_lib.util_pkg.all;


entity plasmax_if is
    port
    (
        GCLK        : in    std_logic;
        RST         : in    std_logic;
        SW          : in    std_logic_vector(7 downto 0);
        LD          : out   std_logic_vector(7 downto 0);
    
        UART_TX     : out   std_logic;
        UART_RX     : in   std_logic;
    
        SD_SPI_CS   : out   std_logic;
        SD_SPI_MOSI : out   std_logic;
        SD_SPI_MISO : in   std_logic;
        SD_SPI_SCLK : out   std_logic;
    
        SD_CD       : in   std_logic;
        SD_WP       : in   std_logic
    );
end;

architecture logic of plasmax_if is

    signal uart_read          : std_logic;
    signal uart_write         : std_logic;
  
    signal clk_reg            : std_logic;
    signal mem_address        : std_logic_vector(31 downto 2);
    signal data_write         : std_logic_vector(31 downto 0);
    signal data_reg           : std_logic_vector(31 downto 0);
    signal write_byte_enable  : std_logic_vector(3 downto 0);
    signal mem_pause_in       : std_logic;
    signal clk_in             : std_logic;
    signal reset              : std_logic;
    signal gpio0_out          : std_logic_vector(31 downto 0);
    signal gpioA_in           : std_logic_vector(31 downto 0);

    signal debug_data         : std_logic_vector(15 downto 0);
begin
    clk_in <= GCLK;
    reset <= RST;

    --LD(2) <= clk_reg;



    uart_read <= UART_RX;
    UART_TX <= uart_write;

    gpioA_in <= (OTHERS => '0');
    data_reg <= (others => '0');
    mem_pause_in <= '0';

    --Divide 50 MHz clock by two
    clk_div: process(reset, clk_in, clk_reg)
    begin
    if reset = '1' then
        clk_reg <= '0';
    elsif rising_edge(clk_in) then
        clk_reg <= not clk_reg;
    end if;
    end process; --clk_div

    mem_pause_in <= '0';


    LD(7 downto 0) <= --error_code(15 downto 8) when SW(0) else -- sd fat error
                    --error_code(7 downto 0) when SW(1) else -- bootrom state
                    --data_write(7 downto 0) when SW(2) else -- data
                    (reset, not SD_CD, gpio0_out(0), '0') & "0000";


    u1_plasmax: entity plasmax_lib.plasmax
    generic map 
    (
        memory_type => "XILINX_16X",
        log_file    => "UNUSED"
    )
    port map
    (
        clk               => clk_reg,
        reset             => reset,
        uart_write        => uart_write,
        uart_read         => uart_read,

        address           => mem_address,
        write_byte_enable => write_byte_enable,
        data_write        => data_write,
        data_read         => data_reg,
        mem_pause_in      => mem_pause_in,

        gpio0_out         => gpio0_out,
        gpioA_in          => gpioA_in
    );
end;