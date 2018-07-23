library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity slave_ext_memory is 
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    address           : out std_logic_vector(31 downto 2);
    data_write        : out std_logic_vector(31 downto 0);
    data_read         : in std_logic_vector(31 downto 0);
    write_byte_enable : out std_logic_vector(3 downto 0);

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
end slave_ext_memory;

architecture behavior of slave_ext_memory is 
    signal dat_s : std_logic_vector(31 downto 0) := (others => '0');
begin

    address             <= adr_i(31 downto 2);
    data_write          <= dat_i;
    dat_o               <= data_read;
    write_byte_enable   <= sel_i;

    ack_o               <= stb_i;
    rty_o               <= '0';
    stall_o             <= '0';
    err_o               <= '0';
end behavior;