library ieee;
use ieee.std_logic_1164.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library zz_systems;
    use zz_systems.wb_pkg.all;
    use zz_systems.util_pkg.all;


entity plasma_soc_top is
    port
    (
        GCLK        : in    std_logic;
        RST         : in    std_logic;
        SW          : in    std_logic_vector(7 downto 0);
        LD          : out   std_logic_vector(7 downto 0);
    
        UART_TX     : out   std_logic;
        UART_RX     : in   std_logic;
    
        -- PMOD SD pinout
        SD_SPI_CS   : out   std_logic;
        SD_SPI_MOSI : out   std_logic;
        SD_SPI_MISO : in   std_logic;
        SD_SPI_SCLK : out   std_logic;
    
        SD_CD       : in   std_logic;
        SD_WP       : in   std_logic;

        -- avalon slave interface
        avs_address           : in std_logic_vector(31 downto 0);
        avs_byteenable        : in std_logic_vector(3 downto 0);
        avs_write_n           : in std_logic;
        avs_read_n            : in std_logic;
        avs_readdata          : out std_logic_vector(31 downto 0);
        avs_writedata         : in std_logic_vector(31 downto 0);
        avs_waitrequest       : out std_logic; 
        avs_response          : out std_logic_vector(1 downto 0)
    );
end;

architecture logic of plasma_soc_top is

    constant spi_slaves : positive := 1;
    constant sys_clk    : positive := 50000000;
    constant spi_clk    : positive := 1562500;

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
    signal gpio0_out          : std_logic_vector(127 downto 0);
    signal gpioA_in           : std_logic_vector(127 downto 0);

    signal debug_data         : std_logic_vector(15 downto 0);

    signal sclk         : std_logic;
    signal cs_n         : std_logic_vector(spi_slaves - 1 downto 0);
    signal miso         : std_logic;
    signal mosi         : std_logic;
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


    LD(7 downto 0) <= gpio0_out(7 downto 0) when reset = '0' else x"80";

    u_soc: entity zz_systems.plasma_soc
    generic map 
    (
        memory_type => "ALTERA_LPM",
        log_file    => "UNUSED",

        spi_slaves  => spi_slaves,
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
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

        gpio_o            => gpio0_out,
        gpio_i            => gpioA_in,

        MOSI    => mosi,
        MISO    => miso,
        SCLK    => sclk,
        CS      => cs_n,

        avs_address           => avs_address,
        avs_byteenable        => avs_byteenable,
        avs_write_n           => avs_write_n,
        avs_read_n            => avs_read_n,
        avs_readdata          => avs_readdata,
        avs_writedata         => avs_writedata,
        avs_waitrequest       => avs_waitrequest,
        avs_response          => avs_response
    );
end;