library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity slave_memory is 
generic
(
    constant memory_type : string := "XILINX_16X"
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    cyc_i : in std_logic;
    stb_i : in std_logic;
    we_i   : in std_logic;

    adr_i : in std_logic_vector(31 downto 0);
    dat_i : in std_logic_vector(31 downto 0);

    sel_i : in std_logic_vector(3 downto 0);

    dat_o : out  std_logic_vector(31 downto 0);
    ack_o : out std_logic;
    rty_o : out std_logic;
    stall_o : out std_logic;
    err_o : out std_logic
);
end slave_memory;

architecture behavior of slave_memory is 
    signal dat_s : std_logic_vector(31 downto 0) := (others => '0');
begin
    stall_o <= '0';
    err_o   <= '0';
    rty_o   <= '0';
    ack_o   <= stb_i;

    process(clk_i, rst_i)
    begin         
        if rst_i = '1' then         
        elsif rising_edge(clk_i) then
        end if;
    end process;

    ram: entity plasma_lib.ram
    generic map (memory_type => memory_type)
    port map 
    (
        clk               => clk_i,
        enable            => stb_i,
        write_byte_enable => sel_i,
        address           => adr_i(31 downto 2),
        data_write        => dat_i,
        data_read         => dat_o
    );

end behavior;