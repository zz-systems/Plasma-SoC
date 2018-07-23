library ieee;
    use ieee.std_logic_1164.all;

library zz_systems;

entity ir_channel is 
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    ir_i    : in std_logic;
    clear_i : in std_logic;
    state_o : out std_logic;
    inv_i   : in std_logic;
    en_i    : in std_logic;
    edge_i  : in std_logic
);
end;

architecture behavior of ir_channel is
    signal raw_s    : std_logic := '0';
    signal edge_s   : std_logic := '0';
    signal state_s  : std_logic := '0';
    signal inv_s    : std_logic := '0';
begin
    state_o <= state_s;
    inv_s   <= raw_s xor inv_i;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            raw_s <= '0';
            edge_s <= '0';
        elsif rising_edge(clk_i) then
            raw_s <= ir_i;
            edge_s <= inv_s;             
        end if;            
    end process;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state_s <= '0';
        elsif falling_edge(clk_i) then
            state_s <= ((inv_s and (edge_s nand edge_i)) and en_i) or (state_s and not clear_i);
        end if;            
    end process;
end behavior;