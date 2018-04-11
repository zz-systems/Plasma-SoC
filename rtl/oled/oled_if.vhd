library ieee;
use ieee.std_logic_1164.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library zz_systems;
    use zz_systems.wb_pkg.all;
    use zz_systems.util_pkg.all;


entity oled_if is
    port
    (
        GCLK        : in    std_logic;
        RST         : in    std_logic;
        
        
        SW          : in    std_logic_vector(7 downto 0);
        LD          : out   std_logic_vector(7 downto 0);    

        -- OLED pinout
        OLED_DC     : out std_logic;
        OLED_RES    : out std_logic;
        OLED_SCLK   : out std_logic;
        OLED_SDIN   : out std_logic;
        OLED_VBAT   : out std_logic;
        OLED_VDD    : out std_logic
    );
end;

architecture logic of oled_if is

    constant spi_slaves : positive := 1;
    constant sys_clk    : positive := 100000000 / 2;
    constant spi_clk    : positive := 3125000;

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

    signal sclk         : std_logic;
    signal cs_n         : std_logic_vector(spi_slaves - 1 downto 0);
    signal miso         : std_logic;
    signal mosi         : std_logic;
begin
    clk_in <= GCLK;
    reset <= RST;

    --Divide 50 MHz clock by two
    clk_div: process(reset, clk_in, clk_reg)
    begin
    if reset = '1' then
        clk_reg <= '0';
    elsif rising_edge(clk_in) then
        clk_reg <= not clk_reg;
    end if;
    end process; 


    LD(7) <= reset;
    
    u_oled: entity zz_systems.oled_control
    generic map
    (
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
    )
    port map 
    (  
        clk_i       => clk_reg,
        rst_i       => reset,
        sdin_o      => OLED_SDIN,
        sclk_o      => OLED_SCLK,
        dc_o        => OLED_DC,
        res_o       => OLED_RES,
        vbat_o      => OLED_VBAT,
        vdd_o       => OLED_VDD,

        adr_i       => "0000000000",
        dat_i       => x"00",
        we_i        => '0',
        cmd_i       => '0',
        text_mode_i => '1',
        flush_i     => SW(0),
        clear_i     => '0',
        ready_o     => open
    );
end;