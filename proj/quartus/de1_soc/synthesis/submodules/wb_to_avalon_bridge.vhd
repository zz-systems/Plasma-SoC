library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;

entity wb_to_avalon_bridge is
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

     -- avalon master interface --
     address        : out std_logic_vector(31 downto 0);
     byteenable     : out std_logic_vector(3 downto 0);
     write          : out std_logic;
     read           : out std_logic;
     readdata       : in std_logic_vector(31 downto 0);
     writedata      : out std_logic_vector(31 downto 0);
     waitrequest_n  : in std_logic; 
     response       : in std_logic_vector(1 downto 0);
 
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
end wb_to_avalon_bridge;

architecture behavior of wb_to_avalon_bridge is   
    signal read_os  : std_logic := '0';
    signal write_os : std_logic := '0';
    signal ack_os   : std_logic := '0';
    signal sel_os   : std_logic_vector(sel_i'range) := (others => '0');
    signal dat_os   : std_logic_vector(dat_o'range) := (others => '0');
begin
    -- convert control signals from wishbone to avalon protocol.
    -- convert avalon waitrequest to wishbone ACK and persist data.
    process(clk_i, rst_i) is 
    begin
        if rst_i = '1' then
            write_os    <= '0';
            read_os     <= '0';
            ack_os      <= '0';
            dat_os      <= (others => '0');
        elsif rising_edge(clk_i) then
            if stb_i = '1' then
                write_os <= we_i;
                read_os  <= not we_i;
                ack_os   <= '0';
            elsif cyc_i = '1' then
                -- Await ACK
                if waitrequest_n = '1' then
                    write_os    <= '0';
                    read_os     <= '0';
                    ack_os      <= '1';
                    dat_os      <= readdata;
                else 
                    ack_os      <= '0';
                end if;
            else 
                write_os    <= '0';
                read_os     <= '0';
                ack_os      <= '0';
            end if;
        end if;
    end process;

    -- avalon -> wishbone
    dat_o   <= dat_os;
    ack_o   <= ack_os;

    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= '1' when cyc_i = '1' and response = response_slaveerror else '0';

    -- avalon <- wishbone
    address     <= adr_i;
    byteenable  <= sel_i;

    write       <= write_os;
    read        <= read_os;
    writedata   <= dat_i;
end;