-- This component implements a wishbone proxy
-- using wb_to_avalon and avalon_to_wb bridges
-- providing both wishbone interfaces for test purposes

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;

entity wb_to_avalon_test_proxy is
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;
    
    -- wishbone slave interface 
    wbs_cyc_i   : in std_logic;
    wbs_stb_i   : in std_logic;
    wbs_we_i    : in std_logic;

    wbs_adr_i   : in std_logic_vector(31 downto 0);
    wbs_dat_i   : in std_logic_vector(31 downto 0);

    wbs_sel_i   : in std_logic_vector(3 downto 0);

    wbs_dat_o   : out  std_logic_vector(31 downto 0);
    wbs_ack_o   : out std_logic;
    wbs_rty_o   : out std_logic;
    wbs_stall_o : out std_logic;
    wbs_err_o   : out std_logic;

    -- wishbone master interface 
    wbm_cyc_o : out std_logic;
    wbm_stb_o : out std_logic;
    wbm_we_o   : out std_logic;

    wbm_adr_o : out std_logic_vector(31 downto 0);
    wbm_dat_o : out std_logic_vector(31 downto 0);

    wbm_sel_o : out std_logic_vector(3 downto 0);

    wbm_dat_i : in  std_logic_vector(31 downto 0);
    wbm_ack_i : in std_logic;
    wbm_rty_i : in std_logic;
    wbm_stall_i : in std_logic;
    wbm_err_i : in std_logic
);
end wb_to_avalon_test_proxy;

architecture behavior of wb_to_avalon_test_proxy is   
    signal address           : std_logic_vector(31 downto 0);
    signal byteenable        : std_logic_vector(3 downto 0);
    signal write             : std_logic;
    signal read              : std_logic;
    signal readdata          : std_logic_vector(31 downto 0);
    signal writedata         : std_logic_vector(31 downto 0);
    signal waitrequest_n     : std_logic; 
    signal response          : std_logic_vector(1 downto 0);
begin   

    u_wb_to_avalon_bridge: entity zz_systems.wb_to_avalon_bridge
    port map
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        address           => address,
        byteenable        => byteenable,
        write             => write,
        read              => read,
        readdata          => readdata,
        writedata         => writedata,
        waitrequest_n     => waitrequest_n,
        response          => response,

        cyc_i   => wbs_cyc_i,
        stb_i   => wbs_stb_i,
        we_i    => wbs_we_i,

        adr_i   => wbs_adr_i,
        dat_i   => wbs_dat_i,

        sel_i   => wbs_sel_i,

        dat_o   => wbs_dat_o,
        ack_o   => wbs_ack_o,
        rty_o   => wbs_rty_o,
        stall_o => wbs_stall_o,
        err_o   => wbs_err_o
    );

    u_avalon_to_wb_bridge: entity zz_systems.avalon_to_wb_bridge
    port map
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        address           => address,
        byteenable        => byteenable,
        write             => write,
        read              => read,
        readdata          => readdata,
        writedata         => writedata,
        waitrequest_n     => waitrequest_n,
        response          => response,

        cyc_o   => wbm_cyc_o,
        stb_o   => wbm_stb_o,
        we_o    => wbm_we_o,

        adr_o   => wbm_adr_o,
        dat_o   => wbm_dat_o,

        sel_o   => wbm_sel_o,

        dat_i   => wbm_dat_i,
        ack_i   => wbm_ack_i,
        rty_i   => wbm_rty_i,
        stall_i => wbm_stall_i,
        err_i   => wbm_err_i
    );
end;