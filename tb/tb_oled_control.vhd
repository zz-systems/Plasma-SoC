library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
  
library zz_systems;
    use zz_systems.util_pkg.all;

entity tb_oled_control is
end; --entity tbench

architecture sim of tb_oled_control is
    signal clk          : std_logic := '1';
    signal reset        : std_logic := '1';

    signal temp_spi_fin : std_logic := '0';

    signal dat_is  : std_logic_vector(7 downto 0)  := (others => '0');
    signal adr_s   : std_logic_vector(9 downto 0)  := (others => '0');
    signal we_s     : std_logic := '0';

    signal sdin  : std_logic := '1';
    signal sclk  : std_logic := '1';
    signal dc    : std_logic := '0';
    signal res   : std_logic := '1';
    signal vbat  : std_logic := '1';
    signal vdd   : std_logic := '1';

    signal ready     : std_logic := '0';

    signal flush_s  : std_logic;

    signal iadr_s   : integer := 0;
begin
    uut: entity zz_systems.oled_control
    generic map
    (
        sys_clk         => 50000000, -- 50ns = 20MHz
        spi_clk         => 1562500,
        example_active  => false
    )
    port map 
    (  
        clk_i       => clk,
        rst_i       => reset,

        sdin_o      => sdin,
        sclk_o      => sclk,
        dc_o        => dc,
        res_o       => res,
        vbat_o      => vbat,
        vdd_o       => vdd,

        adr_i       => adr_s,
        dat_i       => dat_is,
        we_i        => we_s,

        cmd_i       => '0',
        text_mode_i => '1',
        flush_i     => flush_s,
        clear_i     => '0',
        ready_o     => ready
    );
       
    clk   <= not clk after 20 ns;
    reset <= '0' after 250 ns;   

    adr_s <= std_logic_vector(to_unsigned(iadr_s, 10));

    process
    begin
        wait until reset = '0';
        wait until rising_edge(clk);

        flush_s <= '0';

        wait until ready = '1';
        wait until rising_edge(clk);
        we_s    <= '1';

        iadr_s <= 0;
        dat_is <= x"54"; -- T

        wait until rising_edge(clk);

        iadr_s <= 1;
        dat_is <= x"65"; -- e

        wait until rising_edge(clk);

        iadr_s <= 2;
        dat_is <= x"73"; -- s

        wait until rising_edge(clk);

        iadr_s <= 3;
        dat_is <= x"74"; -- t

        wait until rising_edge(clk);
        we_s    <= '0';
        flush_s <= '1';
        wait until rising_edge(clk);
        flush_s <= '0';

       -- wait until ready = '1';
        wait for 250 ns;
        wait until rising_edge(clk);

    end process;
end;
