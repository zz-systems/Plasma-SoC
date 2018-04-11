library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

library zz_systems;

entity ir_control is 
generic
(
    constant channels : positive := 32
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    ir_i    : in std_logic_vector(channels - 1 downto 0);
    clear_i : in std_logic_vector(channels - 1 downto 0);
    state_o : out std_logic_vector(channels - 1 downto 0);
    inv_i   : in std_logic_vector(channels - 1 downto 0);
    mask_i  : in std_logic_vector(channels - 1 downto 0);
    edge_i  : in std_logic_vector(channels - 1 downto 0);

    irq_o   : out std_logic
);
end;

architecture behavior of ir_control is
    signal state_s  : std_logic_vector(channels - 1 downto 0) := (others => '0');
begin
    ir_channels: for i in 0 to channels - 1 generate
        channel: entity zz_systems.ir_channel
        port map
        (
            clk_i   => clk_i,
            rst_i   => rst_i,

            ir_i    => ir_i(i),
            clear_i => clear_i(i),

            state_o => state_s(i),

            inv_i   => inv_i(i),
            en_i    => mask_i(i),
            edge_i  => edge_i(i)
        );
    end generate;

    irq_o   <= or_reduce(state_s);
    state_o <= state_s;
end behavior;