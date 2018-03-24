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
    use ieee.numeric_std.all;
library plasma_lib;
    use plasma_lib.mlite_pack.all;

library plasmax_lib;
    use plasmax_lib.wb_pkg.all;

entity tb_mem_init_sections is
end; --entity tbench

architecture testbench of tb_mem_init_sections is
    constant memory_type : string := 
    --   "TRI_PORT_X";   
    --   "DUAL_PORT_";
    --   "ALTERA_LPM";
    "XILINX_16X";

    signal clk          : std_logic := '1';
    signal reset       : std_logic := '1';
    
    signal mem_port    : wb_port;
    
    constant src_base : integer := 1572;
    constant dst_base : integer := 1632;
    
    signal dst_addr : std_logic_vector(31 downto 0);
    
begin  --architecture
    clk   <= not clk after 20 ns;
    reset <= '0' after 250 ns;
    
    process
    begin
        wait until reset = '0';
        wait until rising_edge(clk);
        
        for i in 0 to 11 loop
            wait until rising_edge(clk);
            mem_port.cyc <= '1';
            mem_port.stb <= '1';
            mem_port.adr <= std_logic_vector(to_unsigned(src_base + i * 4, 32));
                    
            wait until mem_port.ack = '1';            
            wait until rising_edge(clk);
            mem_port.cyc <= '0';
            mem_port.stb <= '0';
            
            dst_addr     <= std_logic_vector(to_unsigned(dst_base + i * 4, 32)); 
        end loop;
    end process;
    
    uut: entity plasmax_lib.slave_memory
    generic map
    (
        memory_type => memory_type
    )
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        cyc_i   => mem_port.cyc,
        stb_i   => mem_port.stb,
        we_i    => mem_port.we,

        adr_i   => mem_port.adr,
        dat_i   => mem_port.dat_i,

        sel_i   => mem_port.sel,

        dat_o   => mem_port.dat_o,
        ack_o   => mem_port.ack,
        rty_o   => mem_port.rty,
        stall_o => mem_port.stall,
        err_o   => mem_port.err
    );

end;
