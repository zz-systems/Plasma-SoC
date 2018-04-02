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
    
        -- PMOD SD pinout
        SD_SPI_CS   : out   std_logic;
        SD_SPI_MOSI : out   std_logic;
        SD_SPI_MISO : in   std_logic;
        SD_SPI_SCLK : out   std_logic;
    
        SD_CD       : in   std_logic;
        SD_WP       : in   std_logic;

        -- OLED pinout
        OLED_DC     : out std_logic;
        OLED_RES    : out std_logic;
        OLED_SCLK   : out std_logic;
        OLED_SDIN   : out std_logic;
        OLED_VBAT   : out std_logic;
        OLED_VDD    : out std_logic
    );
end;

architecture logic of plasmax_if is

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

    u1_plasmax: entity plasmax_lib.plasmax
    generic map 
    (
        memory_type => "XILINX_16X",
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

        oled_sdin_o      => OLED_SDIN,
        oled_sclk_o      => OLED_SCLK,
        oled_dc_o        => OLED_DC,
        oled_res_o       => OLED_RES,
        oled_vbat_o      => OLED_VBAT,
        oled_vdd_o       => OLED_VDD
    );
end;