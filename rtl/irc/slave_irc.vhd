--------------------------------------------------------------------------------
-- TITLE:  Interrupt controller Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- INTERRUPT CONTROLLER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0x00      | r/w   | control register
-- status       | 0x04      | r     | status register
-- data         | 0x08      | r     | interrupt flag state
-- imm flags    | 0x0C      | r     | immediate interrupt flag state (input passthrough)
-- clear        | 0x10      | r/w   | clear interrupt flag
-- invert       | 0x14      | r/w   | invert flag
-- mask         | 0x18      | r/w   | interrupt flag enable/disable mask     
-- edge         | 0x1C      | r/w   | interrupt edge detection
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
    signal ctrl_s       : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s       : std_logic_vector(31 downto 0) := (others => '0');

    signal ir_s         : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal clear_s      : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal ir_state_s   : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal inv_s        : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal mask_s       : std_logic_vector(channels - 1 downto 0) := (others => '0');
    signal edge_s       : std_logic_vector(channels - 1 downto 0) := (others => '0');

    signal ack_s        : std_logic := '0';
    signal err_s        : std_logic := '0';
begin

    ack_o   <= ack_s;
    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= err_s;

    process(clk_i, rst_i)
        variable ack_v  : std_logic := '0';
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            ctrl_s  <= (others => '0');
            clear_s <= (others => '0');
            inv_s   <= (others => '0');
            mask_s  <= (others => '0');
            edge_s  <= (others => '0');

            dat_o   <= (others => '0');

            ack_s   <= '0';
            err_s   <= '0';  
        elsif rising_edge(clk_i) then
            ack_v := '0';
            err_v := '0';

            if stb_i = '1' then
                ack_v := '1';

                ir_s <= ir_i;

                if we_i = '0' then
                    case adr_i(7 downto 0) is
                        when x"00" => dat_o     <= ctrl_s;
                        when x"04" => dat_o     <= stat_s;

                        when x"08" => dat_o     <= ir_state_s;
                        when x"0C" => dat_o     <= ir_i;
                        when x"10" => dat_o     <= clear_s;
                        when x"14" => dat_o     <= inv_s;
                        when x"18" => dat_o     <= mask_s;
                        when x"1C" => dat_o     <= edge_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 0) is
                        when x"00" => ctrl_s    <= dat_i;

                        when x"10" => clear_s   <= dat_i;
                        when x"14" => inv_s     <= dat_i;
                        when x"18" => mask_s    <= dat_i;
                        when x"1C" => edge_s    <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
            end if;
            
            ack_s <= ack_v and not err_v;
            err_s <= err_v;
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
        state_o => ir_state_s,
        inv_i   => inv_s,
        mask_i  => mask_s,
        edge_i  => edge_s,

        irq_o   => irq_o
    );

end behavior;