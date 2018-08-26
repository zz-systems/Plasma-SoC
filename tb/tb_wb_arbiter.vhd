library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
  
library zz_systems;
    use zz_systems.util_pkg.all;
    use zz_systems.avalon_pkg.all;

entity tb_wb_arbiter is
end; --entity tbench

architecture sim of tb_wb_arbiter is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    constant channels : positive := 4;

    -- channel grant request
    signal cgrq_i          : std_logic_vector(channels - 1 downto 0);

    -- channel select
    signal cs_o            : std_logic_vector(bit_width(channels) downto 0);
begin
    uut: entity zz_systems.arbiter
    generic map
    (
        channels => channels
    )
    port map 
    (  
        clk_i       => clk,
        rst_i       => rst,

        -- channel grant request
        cgrq_i      => cgrq_i,

        -- channel select
        cs_o        => cs_o
    );
       
    clk <= not clk after 20 ns;
    rst <= '0' after 250 ns;

    process
    begin
        wait until rst = '0';
        wait until rising_edge(clk);

        cgrq_i <= "0000";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0001";
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0010";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0011";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0100";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0101";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0110";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "0111";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1000";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1001";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1010";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1011";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1100";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1101";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1110";

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        cgrq_i <= "1111";

        wait for 250 ns;
        wait until rising_edge(clk);

    end process;
end;
