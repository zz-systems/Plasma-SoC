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
                        when x"0" => dat_o      <= cnt_os;
                        when x"1" => dat_o      <= rld_is;
                        when x"2" => dat_o      <= dir_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"1" => rld_s      <= dat_i;
                        when x"2" => dir_s      <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
                
                err_s <= err_v;
            end if;
        end if;
    end process;

    irc: entity plasmax_lib.counter
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        rld_i   => rld_s,
        dir_i   => dir_s,
        cnt_o   => cnt_os,

        irq_o  => irq_o
    );

end behavior;