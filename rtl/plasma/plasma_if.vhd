---------------------------------------------------------------------
-- TITLE: Plamsa Interface (clock divider and interface to FPGA board)
-- AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
-- DATE CREATED: 6/6/02
-- FILENAME: plasma_if.vhd
-- PROJECT: Plasma CPU core
-- COPYRIGHT: Software placed into the public domain by the author.
--    Software 'as is' without warranty.  Author liable for nothing.
-- DESCRIPTION:
--    This entity divides the clock by two and interfaces to the 
--    Altera EP20K200EFC484-2X FPGA board.
--    Xilinx Spartan-3 XC3S200FT256-4 FPGA.
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity plasma_if is
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


architecture logic of plasma_if is

   component plasma
      generic(memory_type : string := "XILINX_16X"; --"DUAL_PORT_" "ALTERA_LPM";
              log_file    : string := "UNUSED");
      port(clk               : in std_logic;
           reset             : in std_logic;
           uart_write        : out std_logic;
           uart_read         : in std_logic;
   
           address           : out std_logic_vector(31 downto 2);
           data_write        : out std_logic_vector(31 downto 0);
           data_read         : in std_logic_vector(31 downto 0);
           write_byte_enable : out std_logic_vector(3 downto 0); 
           mem_pause_in      : in std_logic;
        
           gpio0_out         : out std_logic_vector(31 downto 0);
           gpioA_in          : in std_logic_vector(31 downto 0));
   end component; --plasma

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
begin  --architecture
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

   u1_plama: plasma 
      generic map (memory_type => "XILINX_16X",
                   log_file    => "UNUSED")
      PORT MAP (
         clk               => clk_reg,
         reset             => reset,
         uart_write        => uart_write,
         uart_read         => uart_read,
 
         address           => mem_address,
         data_write        => data_write,
         data_read         => data_reg,
         write_byte_enable => write_byte_enable,
         mem_pause_in      => mem_pause_in,
         
         gpio0_out         => gpio0_out,
         gpioA_in          => gpioA_in);
         
end; --architecture logic

