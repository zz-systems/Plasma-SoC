library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;
    
entity avalon_slave2wb_master is
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    -- avalon slave interface --
    address : in std_logic_vector(31 downto 0);
    byteenable : in std_logic_vector(3 downto 0);
    write_n : in std_logic;
    read_n : in std_logic;
    readdata : out std_logic_vector(31 downto 0);
    writedata : in std_logic_vector(31 downto 0);
    waitrequest : out std_logic; 
    response : out std_logic_vector(1 downto 0);

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
end avalon_slave2wb_master;

architecture behavior of avalon_slave2wb_master is
    signal cyc_os : std_logic := '0';
    signal stb_os : std_logic := '0';

    signal adr_os : std_logic_vector(adr_o'range) := (others => '0');
    signal sel_os : std_logic_vector(sel_o'range) := (others => '0');

    signal dat_is : std_logic_vector(dat_i'range) := (others => '0');

    signal clk : std_logic := '0';
    signal stall_s : std_logic := '0';
begin
    -- generate CYC signal from avalon rad_n / write_n
    -- recreate STB signal as chipselect / chipselect_n is obsolete
    -- refer to Avalon interface specifications, Appendix A. Deprecated Signals
    process(clk_i, rst_i)
    begin         
        if rst_i = '1' then 
            cyc_os <= '0';
            stb_os <= '0';
        elsif rising_edge(clk_i) then
            if (err_i  = '1' and cyc_os  = '1') then
                cyc_os      <= '0';
                stb_os      <= '0';
            elsif stb_os  = '1' then
                if stall_i = '0' then
                    stb_os <= '0';
                end if;

                if stall_i = '0' and ack_i = '1' then
                    cyc_os <= '0';
                end if; 
            elsif cyc_os  = '1' then
                if ack_i  = '1' then
                    cyc_os <= '0';
                end if;
            elsif (write_n = '0') or (read_n = '0') then
                cyc_os <= '1';
                stb_os <= '1';
            else
                cyc_os <= '0';
                stb_os <= '0';
            end if;
        end if;
    end process;

    -- avalon -> wishbone
    cyc_o <= cyc_os;
    stb_o <= stb_os;

    adr_o <= address;
    dat_o <= writedata;

    sel_o <= byteenable;
    we_o <= (not write_n) and read_n;

    -- avalon <- wishbone
    readdata <= dat_i;
    waitrequest <= not ack_i;

    response <= response_slaveerror when (err_i  = '1' and cyc_os  = '1') else 
                response_okay;
end;