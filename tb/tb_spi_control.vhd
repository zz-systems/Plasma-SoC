library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
  
library plasmax_lib;
    use plasmax_lib.util_pkg.all;

entity tb_spi_control is
end; --entity tbench

architecture sim of tb_spi_control is
    constant slaves     : positive := 1;

    signal clk          : std_logic := '1';
    signal reset        : std_logic := '1';

    signal en           : std_logic := '0';
    signal adr          : std_logic_vector(bit_width(slaves) downto 0);
    signal dat_i        : std_logic_vector(7 downto 0);
    signal dat_o        : std_logic_vector(7 downto 0);

    signal sclk         : std_logic := '0';
    signal cs_n         : std_logic_vector(slaves - 1 downto 0);
    signal miso         : std_logic := '0';
    signal mosi         : std_logic := '0';

    signal ack          : std_logic := '0';
    signal irq          : std_logic := '0';

    signal osclk         : std_logic := '0';
    signal ocs_n         : std_logic_vector(slaves - 1 downto 0);
    signal omiso         : std_logic := '0';
    signal omosi         : std_logic := '0';

    signal temp_spi_fin : std_logic := '0';
begin
    uut: entity plasmax_lib.spi_control 
    generic map
    (
        slaves      => slaves,
        data_w      => 8,
        sys_clk     => 50000000, -- 50ns = 20MHz
        spi_clk     => 1562500
    )
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        en_i    => en,
        adr_i   => adr,
        dat_i   => dat_i,
        dat_o   => dat_o,

        MOSI    => mosi,
        MISO    => miso,
        SCLK    => sclk,
        CS      => cs_n,

        ack_o   => ack,
        irq_o   => irq
    );
       
    clk   <= not clk after 20 ns;
    reset <= '0' after 250 ns;   
    
    process
    begin 
    
        adr <= (others => '0');
    
        wait until reset = '0';
        wait until rising_edge(clk);
    
        dat_i <= x"AA";
        en    <= '1';
    
        wait until ack = '0';
    
        dat_i <= x"00";
        en    <= '0';
    
        wait until ack = '1';
        wait for 250 ns;
        wait until rising_edge(clk);
    end process;
end;
