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
        SW          : in    std_logic_vector(9 downto 0);
        LD          : out   std_logic_vector(9 downto 0);
    
        UART_TX     : out   std_logic;
        UART_RX     : in   std_logic;
    
        -- SPI pinout
        SPI_CS   : out   std_logic;
        SPI_MOSI : out   std_logic;
        SPI_MISO : in   std_logic;
        SPI_SCLK : out   std_logic;

        -- avalon slave interface
        avs_address           : in std_logic_vector(31 downto 0);
        avs_byteenable        : in std_logic_vector(3 downto 0);
        avs_write             : in std_logic;
        avs_read              : in std_logic;
        avs_readdata          : out std_logic_vector(31 downto 0);
        avs_writedata         : in std_logic_vector(31 downto 0);
        avs_waitrequest_n     : out std_logic; 
        avs_response          : out std_logic_vector(1 downto 0);

        -- avalon master interface
        avm_address           : out std_logic_vector(31 downto 0);
        avm_byteenable        : out std_logic_vector(3 downto 0);
        avm_write             : out std_logic;
        avm_read              : out std_logic;
        avm_readdata          : in std_logic_vector(31 downto 0);
        avm_writedata         : out std_logic_vector(31 downto 0);
        avm_waitrequest_n     : in std_logic; 
        avm_response          : in std_logic_vector(1 downto 0)
    );
end;

architecture logic of plasma_soc_top is

    constant spi_slaves : positive := 1;
    constant sys_clk    : positive := 50000000;
    constant spi_clk    : positive := 1562500;

    signal uart_read          : std_logic;
    signal uart_write         : std_logic;

    signal gpio0_out          : std_logic_vector(127 downto 0);
    signal gpioA_in           : std_logic_vector(127 downto 0);

    signal debug_data         : std_logic_vector(15 downto 0);

    signal sclk         : std_logic;
    signal cs_n         : std_logic_vector(spi_slaves - 1 downto 0);
    signal miso         : std_logic;
    signal mosi         : std_logic;
begin

    LD(9 downto 0) <= gpio0_out(9 downto 0) when RST = '0' else "1111100000";

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
        clk               => GCLK,
        reset             => RST,
        uart_write        => uart_write,
        uart_read         => uart_read,

        gpio_o            => gpio0_out,
        gpio_i            => gpioA_in,

        MOSI    => mosi,
        MISO    => miso,
        SCLK    => sclk,
        CS      => cs_n,

        -- avalon slave interface
        avs_address           => avs_address,
        avs_byteenable        => avs_byteenable,
        avs_write             => avs_write,
        avs_read              => avs_read,
        avs_readdata          => avs_readdata,
        avs_writedata         => avs_writedata,
        avs_waitrequest_n     => avs_waitrequest_n,
        avs_response          => avs_response,

        -- avalon master interface
        avm_address           => avm_address,
        avm_byteenable        => avm_byteenable,
        avm_write             => avm_write,
        avm_read              => avm_read,
        avm_readdata          => avm_readdata,
        avm_writedata         => avm_writedata,
        avm_waitrequest_n     => avm_waitrequest_n,
        avm_response          => avm_response
    );
end;