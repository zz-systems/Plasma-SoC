--------------------------------------------------------------------------------
-- TITLE:  Interrupt controller Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- INTERRUPT CONTROLLER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0         | r/w   | control register
-- status       | 1         | r     | status register
-- raw flags    | 2         | r     | raw interrupt flag state
-- flags        | 3         | r     | interrupt flag state
-- clear        | 4         | r/w   | clear interrupt flag
-- invert       | 5         | r/w   | invert flag
-- mask         | 6         | r/w   | interrupt flag enable/disable mask     
-- edge         | 7         | r/w   | interrupt edge detection
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | reset device
-- enable       | 1         | r/w   | enable device
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | device ready
----------------|-----------|-------|-------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

entity slave_irc is 
generic
(
    constant channels : positive := 32
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    ir_i    : in std_logic_vector(channels - 1 downto 0);
    irq_o   : out std_logic;

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
end slave_irc;

architecture behavior of slave_irc is 
    signal ctrl_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s  : std_logic_vector(31 downto 0) := (others => '0');

    signal ir_s    : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal clear_s : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal state_s : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal inv_s   : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal mask_s  : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal edge_s  : std_logic_vector(channels - 1 downto 0) := (others => '0');

    signal err_s   : std_logic := '0';
begin
    stall_o <= '0';
    err_o   <= err_s;
    rty_o   <= '0';
    ack_o   <= stb_i and not err_s;

    process(clk_i, rst_i)
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            ctrl_s  <= (others => '0');
            clear_s <= (others => '0');
            inv_s   <= (others => '0');
            mask_s  <= (others => '0');
            edge_s  <= (others => '0');

            dat_o   <= (others => '0');
            err_s   <= '0';  
        elsif rising_edge(clk_i) then
            if stb_i = '1' then
                err_v := '0';

                ir_s <= ir_i;

                if we_i = '0' then
                    case adr_i(7 downto 4) is
                        when x"0" => dat_o      <= ctrl_s;
                        when x"1" => dat_o      <= stat_s;

                        when x"2" => dat_o      <= ir_i;
                        when x"3" => dat_o      <= state_s;
                        when x"4" => dat_o      <= clear_s;
                        when x"5" => dat_o      <= inv_s;
                        when x"6" => dat_o      <= mask_s;
                        when x"7" => dat_o      <= edge_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"0" => ctrl_s     <= dat_i;

                        when x"4" => clear_s    <= dat_i;
                        when x"5" => inv_s      <= dat_i;
                        when x"6" => mask_s     <= dat_i;
                        when x"7" => edge_s     <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
                
                err_s <= err_v;
            end if;
        end if;
    end process;

    irc: entity plasmax_lib.ir_control
    generic map 
    (
        channels => channels
    )
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        ir_i    => ir_i,

        clear_i => clear_s,
        state_o => state_s,
        inv_i   => inv_s,
        mask_i  => mask_s,
        edge_i  => edge_s,

        irq_o   => irq_o
    );

end behavior;