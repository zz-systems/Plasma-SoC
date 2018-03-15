library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

-- wb enabled gpio port
----------------|-----------|------------------------------------
-- registers    | address   | description
----------------|-----------|------------------------------------
-- gpio port    | 0         | gpio r/w
-- mask         | 1         | gpio interrupt mask
----------------|-----------|------------------------------------
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
    signal err_s   : std_logic := '0';
    signal mask_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_os  : std_logic_vector(31 downto 0) := (others => '0');
begin
    stall_o <= '0';
    err_o   <= err_s;
    rty_o   <= '0';
    ack_o   <= stb_i and not err_s;

    process(clk_i, rst_i)
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            dat_o   <= (others => '0');
            err_s   <= '0';  
        elsif rising_edge(clk_i) then
            if stb_i = '1' then
                err_v := '0';

                if we_i = '0' then
                    case adr_i(7 downto 4) is
                        when x"0" => dat_o      <= mask_s;
                        when x"1" => dat_o      <= dat_os;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"0" => mask_s     <= dat_i;
                        when x"1" => dat_is     <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
                
                err_s <= err_v;
            end if;
        end if;
    end process;

    irc: entity plasmax_lib.gpio
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        we_i    => we_i,

        mask_i  => mask_s,
        dat_i   => dat_is,
        dat_o   => dat_os,
        gpio_i  => gpio_i,
        gpio_o  => gpio_o,

        irq_o  => irq_o
    );

end behavior;