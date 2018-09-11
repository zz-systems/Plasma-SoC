library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;
    
entity avalon_to_wb_bridge is
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    -- avalon slave interface --
    address         : in std_logic_vector(31 downto 0);
    byteenable      : in std_logic_vector(3 downto 0);
    write           : in std_logic;
    read            : in std_logic;
    readdata        : out std_logic_vector(31 downto 0);
    writedata       : in std_logic_vector(31 downto 0);
    waitrequest_n   : out std_logic; 
    response        : out std_logic_vector(1 downto 0);

    -- wishbone master interface 
    cyc_o : out std_logic;
    stb_o : out std_logic;
    we_o   : out std_logic;

    adr_o : out std_logic_vector(31 downto 0);
    dat_o : out std_logic_vector(31 downto 0);

    sel_o : out std_logic_vector(3 downto 0);


    dat_i : in  std_logic_vector(31 downto 0);
    ack_i : in std_logic;
    rty_i : in std_logic;
    stall_i : in std_logic;
    err_i : in std_logic
);
end avalon_to_wb_bridge;

architecture behavior of avalon_to_wb_bridge is
    signal cycstb_s     : std_logic := '0';
    signal readdata_s   : std_logic_vector(readdata'range) := (others => '0');
begin  
    -- avalon -> wishbone
    process(clk_i, rst_i)
    begin         
       if rising_edge(clk_i) then
            if rst_i = '1' then
                cycstb_s <= '0';
            elsif ack_i = '1' or err_i = '1' then
                cycstb_s <= '0';
            elsif (write = '1') or (read = '1') then
                cycstb_s <= '1';
            end if;            
        end if;
    end process;

    cyc_o <= cycstb_s;
    stb_o <= cycstb_s;

    adr_o <= address;
    dat_o <= writedata;

    sel_o <= byteenable;
    we_o <= write;

    -- avalon <- wishbone
    -- process(clk_i)
    -- begin         
    --    if rising_edge(clk_i) then
    --         readdata_s <= dat_i;            
    --     end if;
    -- end process;

    readdata <= dat_i;
    --readdata <= readdata_s;
    waitrequest_n <= cycstb_s and (ack_i or err_i);

    response <= response_slaveerror when (err_i  = '1' and cycstb_s  = '1') else 
                response_okay;
end;