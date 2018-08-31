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

entity tb_plasma_de1_soc is
end; --entity tbench

architecture logic of tb_plasma_de1_soc is
    constant memory_type : string := 
    --   "TRI_PORT_X";   
    --   "DUAL_PORT_";
    "ALTERA_LPM";
    -- "XILINX_16X";    

    constant log_file_px : string := 
    --      "UNUSED";
    "output_plasma_soc.txt";

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

    signal sclk         : std_logic;
    signal cs_n         : std_logic_vector(spi_slaves - 1 downto 0);
    signal miso         : std_logic;
    signal mosi         : std_logic;

    -- avalon slave interface
    signal avs_address           : std_logic_vector(31 downto 0);
    signal avs_byteenable        : std_logic_vector(3 downto 0);
    signal avs_write             : std_logic;
    signal avs_read              : std_logic;
    signal avs_readdata          : std_logic_vector(31 downto 0);
    signal avs_writedata         : std_logic_vector(31 downto 0);
    signal avs_waitrequest_n     : std_logic; 
    signal avs_response          : std_logic_vector(1 downto 0);

    -- avalon master interface
    signal avm_address           : std_logic_vector(31 downto 0);
    signal avm_byteenable        : std_logic_vector(3 downto 0);
    signal avm_write             : std_logic;
    signal avm_read              : std_logic;
    signal avm_readdata          : std_logic_vector(31 downto 0);
    signal avm_writedata         : std_logic_vector(31 downto 0);
    signal avm_waitrequest_n     : std_logic; 
    signal avm_response          : std_logic_vector(1 downto 0);
begin  --architecture
    --Uncomment the line below to test interrupts
    --interrupt <= '1' after 20 us when interrupt = '0' else '0' after 445 ns;

    clkx   <= not clkx after 20 ns;

    --reset <= '0' after 250 ns;
    
    -- resetx <= '0' after 500 ns;
    --mem_pause <= not mem_pause after 100 ns;
    --uart_read <= '0';
    px_data_read <= interrupt & ZERO(30 downto 0);

    process
    begin
        wait for 250 ns;
        reset <= '0';
        
        --wait for 1 ms;
        --reset <= '1';
        
        --wait for 250 ns;
        --reset <= '0';

        for i in 0 to 10 loop
            wait for 40 us;
            avs_address <= x"00005108";
            avs_writedata <= x"DEADBEEF";
            avs_byteenable <= x"F";
            avs_write <= '1';

            wait until avs_waitrequest_n = '1';
            avs_address <= x"00000000";
            avs_byteenable <= x"0";
            avs_write <= '0';
        end loop;
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

        gpio_o            => open,
        gpio_i            => (127 downto 32 => '0') & px_data_read,

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
    
end; --architecture logic
