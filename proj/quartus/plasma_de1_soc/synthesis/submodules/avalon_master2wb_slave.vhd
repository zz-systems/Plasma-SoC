library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;
    use zz_systems.util_pkg.all;

entity avalon_master2wb_slave is
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

     -- avalon master interface --
     address : out std_logic_vector(31 downto 0);
     byteenable : out std_logic_vector(3 downto 0);
     write_n : out std_logic;
     read_n : out std_logic;
     readdata : in std_logic_vector(31 downto 0);
     writedata : out std_logic_vector(31 downto 0);
     waitrequest : in std_logic; 
     response : in std_logic_vector(1 downto 0);
 
     -- wishbone slave interface 
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
end avalon_master2wb_slave;

architecture behavior of avalon_master2wb_slave is   
begin

    -- avalon -> wishbone
    dat_o   <= readdata;
    ack_o   <= stb_i and not waitrequest;
    
    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= '1' when stb_i = '1' and response = response_slaveerror else '0';

    -- avalon <- wishbone
    address     <= adr_i;
    byteenable  <= sel_i;
    write_n     <= not (stb_i and we_i);
    read_n      <= not (stb_i and not we_i);
    writedata   <= dat_i;
end;