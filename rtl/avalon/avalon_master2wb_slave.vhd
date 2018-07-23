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
            elsif (not write_n) or (not read_n) then
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