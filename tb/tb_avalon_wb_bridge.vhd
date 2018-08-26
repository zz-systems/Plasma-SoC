library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
  
library zz_systems;
    use zz_systems.util_pkg.all;
    use zz_systems.avalon_pkg.all;

entity tb_wb_to_avalon_test_proxy is
end; --entity tbench

architecture sim of tb_wb_to_avalon_test_proxy is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    
    -- wishbone slave interface 
    signal wbs_cyc_i   : std_logic := '0';
    signal wbs_stb_i   : std_logic := '0';
    signal wbs_we_i    : std_logic := '0';

    signal wbs_adr_i   : std_logic_vector(31 downto 0) := (others => '0');
    signal wbs_dat_i   : std_logic_vector(31 downto 0) := (others => '0');

    signal wbs_sel_i   : std_logic_vector(3 downto 0) := (others => '0');

    signal wbs_dat_o   :  std_logic_vector(31 downto 0) := (others => '0');
    signal wbs_ack_o   : std_logic := '0';
    signal wbs_rty_o   : std_logic := '0';
    signal wbs_stall_o : std_logic := '0';
    signal wbs_err_o   : std_logic := '0';

    -- wishbone master interface 
    signal wbm_cyc_o : std_logic := '0';
    signal wbm_stb_o : std_logic := '0';
    signal wbm_we_o  : std_logic := '0';

    signal wbm_adr_o : std_logic_vector(31 downto 0) := (others => '0');
    signal wbm_dat_o : std_logic_vector(31 downto 0) := (others => '0');

    signal wbm_sel_o : std_logic_vector(3 downto 0) := (others => '0');


    signal wbm_dat_i :  std_logic_vector(31 downto 0) := (others => '0');
    signal wbm_ack_i : std_logic := '0';
    signal wbm_rty_i : std_logic := '0';
    signal wbm_stall_i : std_logic := '0';
    signal wbm_err_i : std_logic := '0';
begin
    uut: entity zz_systems.wb_to_avalon_test_proxy
    port map 
    (  
        clk_i       => clk,
        rst_i       => rst,

        wbs_cyc_i   => wbs_cyc_i,
        wbs_stb_i   => wbs_stb_i,
        wbs_we_i    => wbs_we_i,

        wbs_adr_i   => wbs_adr_i,
        wbs_dat_i   => wbs_dat_i,

        wbs_sel_i   => wbs_sel_i,

        wbs_dat_o   => wbs_dat_o,
        wbs_ack_o   => wbs_ack_o,
        wbs_rty_o   => wbs_rty_o,
        wbs_stall_o => wbs_stall_o,
        wbs_err_o   => wbs_err_o,

        wbm_cyc_o   => wbm_cyc_o,
        wbm_stb_o   => wbm_stb_o,
        wbm_we_o    => wbm_we_o,

        wbm_adr_o   => wbm_adr_o,
        wbm_dat_o   => wbm_dat_o,

        wbm_sel_o   => wbm_sel_o,

        wbm_dat_i   => wbm_dat_i,
        wbm_ack_i   => wbm_ack_i,
        wbm_rty_i   => wbm_rty_i,
        wbm_stall_i => wbm_stall_i,
        wbm_err_i   => wbm_err_i
    );
       
    clk <= not clk after 20 ns;
    rst <= '0' after 250 ns;

    process
    begin
        wait until rst = '0';
        wait until rising_edge(clk);

        wbs_cyc_i <= '0';

        wait until rising_edge(clk);
       
        wbs_cyc_i <= '1';
        wbs_stb_i <= '1';

        wbs_adr_i <= x"DEADBEEF";
        wbs_sel_i <= "1111";
        wbs_we_i  <= '0';
        
        wait until rising_edge(clk);

        wbs_stb_i <= '0';

        wait until wbm_cyc_o = '1' and wbm_stb_o = '1';
        wait until rising_edge(clk);

        wbm_dat_i <= x"C0FFEEEE";
        wbm_ack_i <= '1';

        wait until rising_edge(clk);
        wbm_ack_i <= '0';

        wait until wbs_ack_o = '1';
        wait until rising_edge(clk);

        wbs_cyc_i <= '0';

        wait until rising_edge(clk);

        wbs_cyc_i <= '1';
        wbs_stb_i <= '1';

        wbs_adr_i <= x"BEEFDEAD";
        wbs_dat_i <= x"BEEFBEEF";

        wbs_sel_i <= "1111";
        wbs_we_i  <= '1';

        wait until rising_edge(clk);

        wbs_stb_i <= '0';

        wait until wbm_cyc_o = '1' and wbm_stb_o = '1';
        wait until rising_edge(clk);

        wbm_ack_i <= '1';

        wait until rising_edge(clk);
        wbm_ack_i <= '0';

        wait until wbs_ack_o = '1';
        wait until rising_edge(clk);

        wbs_cyc_i <= '0';

        wait for 250 ns;
        wait until rising_edge(clk);

    end process;
end;
