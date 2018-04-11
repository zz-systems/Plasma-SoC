---------------------------------------------------------------------
-- TITLE: Test Bench
-- AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
-- DATE CREATED: 4/21/01
-- FILENAME: tbench.vhd
-- PROJECT: Plasma CPU core
-- COPYRIGHT: Software placed into the public domain by the author.
--    Software 'as is' without warranty.  Author liable for nothing.
-- DESCRIPTION:
--    This entity provides a test bench for testing the Plasma CPU core.
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;

library zz_systems;

entity tb_plasma_vs_plasma_soc is
end; --entity tbench

architecture logic of tb_plasma_vs_plasma_soc is
    constant memory_type : string := 
    --   "TRI_PORT_X";   
    --   "DUAL_PORT_";
    --   "ALTERA_LPM";
    "XILINX_16X";

    constant log_file  : string := 
    --   "UNUSED";
    "output.txt";

    constant log_file_px : string := 
    --      "UNUSED";
    "output_plasmax.txt";

    constant spi_slaves : positive := 1;
    constant sys_clk    : positive := 20000000;
    constant spi_clk    : positive := 1000000;

    signal clk, clkx   : std_logic := '1';
    signal reset       : std_logic := '1';
    signal interrupt   : std_logic := '0';

    signal px_mem_write   : std_logic;
    signal px_mem_address : std_logic_vector(31 downto 2);
    signal px_mem_data    : std_logic_vector(31 downto 0);
    signal px_mem_pause   : std_logic := '0';
    signal px_mem_byte_sel: std_logic_vector(3 downto 0);
    --signal uart_read   : std_logic;
    signal px_uart_write  : std_logic;
    signal px_data_read   : std_logic_vector(31 downto 0);

    signal p_mem_write   : std_logic;
    signal p_mem_address : std_logic_vector(31 downto 2);
    signal p_mem_data    : std_logic_vector(31 downto 0);
    signal p_mem_pause   : std_logic := '0';
    signal p_mem_byte_sel: std_logic_vector(3 downto 0);
    --signal uart_read   : std_logic;
    signal p_uart_write  : std_logic;
    signal p_data_read   : std_logic_vector(31 downto 0);

    signal sclk         : std_logic;
    signal cs_n         : std_logic_vector(spi_slaves - 1 downto 0);
    signal miso         : std_logic;
    signal mosi         : std_logic;
begin  --architecture
    --Uncomment the line below to test interrupts
    --interrupt <= '1' after 20 us when interrupt = '0' else '0' after 445 ns;

    clk   <= not clk after 20 ns;
    clkx   <= not clkx after 20 ns;

    --reset <= '0' after 250 ns;
    
    -- resetx <= '0' after 500 ns;
    --mem_pause <= not mem_pause after 100 ns;
    --uart_read <= '0';
    px_data_read <= interrupt & ZERO(30 downto 0);
    p_data_read <= interrupt & ZERO(30 downto 0);

    process
    begin
        wait for 250 ns;
        reset <= '0';
        
        --wait for 1 ms;
        --reset <= '1';
        
        --wait for 250 ns;
        --reset <= '0';
    end process;
    
    u1_soc: entity zz_systems.plasma_soc
    generic map 
    (
        memory_type => memory_type,
        log_file    => log_file_px,

        spi_slaves  => spi_slaves,
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
    )
    port map
    (
        clk               => clkx,
        reset             => reset,
        uart_read         => px_uart_write,
        uart_write        => px_uart_write,

        address           => px_mem_address,
        data_write        => px_mem_data,
        data_read         => px_data_read,
        write_byte_enable => px_mem_byte_sel,
        mem_pause_in      => px_mem_pause,

        gpio_o            => open,
        gpio_i            => (127 downto 32 => '0') & px_data_read,

        MOSI    => mosi,
        MISO    => miso,
        SCLK    => sclk,
        CS      => cs_n
    );

    u2_plasma: entity plasma_lib.plasma
      generic map (memory_type => memory_type,
                   log_file    => log_file)
      PORT MAP (
         clk               => clk,
         reset             => reset,
         uart_read         => p_uart_write,
         uart_write        => p_uart_write,
 
         address           => p_mem_address,
         data_write        => p_mem_data,
         data_read         => p_data_read,
         write_byte_enable => p_mem_byte_sel,
         mem_pause_in      => p_mem_pause,
         
         gpio0_out         => open,
         gpioA_in          => p_data_read);


    
end; --architecture logic
