--------------------------------------------------------------------------------
-- TITLE:  GPIO Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- GPIO
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0         | r/w   | control register
-- status       | 1         | r     | status register
-- data         | 2         | r/w   | GPIO data
-- mask         | 3         | r/w   | GPIO irq mask
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | user reset
-- irq mask en  | 1         | r/w   | use irq mask
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | gpio ready
-- davail       | 1         | r     | data available
----------------|-----------|-------|-------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

entity slave_gpio is 
generic
(
    constant channels : positive := 32
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    gpio_i  : in std_logic_vector(31 downto 0);
    gpio_o  : out std_logic_vector(31 downto 0);
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
end slave_gpio;

architecture behavior of slave_gpio is 
    signal ctrl_s       : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s       : std_logic_vector(31 downto 0) := (others => '0');
    
    signal dat_is       : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_os       : std_logic_vector(31 downto 0) := (others => '0');
    signal gpio_in_s    : std_logic_vector(31 downto 0) := (others => '0');
    signal mask_s       : std_logic_vector(31 downto 0) := (others => '0');

    signal err_s   : std_logic := '0';

    alias stat_ready_a      : std_logic is stat_s(0);
    alias stat_davail_a     : std_logic is stat_s(1);

    alias ctrl_reset_a      : std_logic is ctrl_s(0);
    alias ctrl_mask_en_a    : std_logic is ctrl_s(1);
begin
    stat_ready_a <= '1';

    irq_o   <= stat_davail_a;

    dat_o   <= dat_os;

    ack_o   <= stb_i and not err_s;
    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= err_s;

    process(clk_i, rst_i)
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            ctrl_s   <= (others => '0');
            dat_os   <= (others => '0');
            dat_is   <= (others => '0');
            mask_s   <= (others => '0');

            err_s    <= '0';  
        elsif rising_edge(clk_i) then
            if stb_i = '1' then
                err_v := '0';

                if we_i = '0' then
                    case adr_i(7 downto 4) is
                        when x"0" => dat_os      <= ctrl_s;
                        when x"1" => dat_os      <= stat_s;
                        when x"2" => dat_os      <= gpio_in_s;
                        when x"3" => dat_os      <= mask_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"0" => ctrl_s      <= dat_i;
                        when x"2" => dat_is      <= dat_i;
                        when x"3" => mask_s      <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
                
                err_s <= err_v;
            end if;
        end if;
    end process;

    gpio: entity plasmax_lib.gpio
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i or ctrl_reset_a,

        we_i    => we_i,

        mask_i  => mask_s and (mask_s'range => ctrl_mask_en_a),
        dat_i   => dat_is,
        dat_o   => gpio_in_s,
        gpio_i  => gpio_i,
        gpio_o  => gpio_o,

        irq_o  => stat_davail_a
    );

end behavior;