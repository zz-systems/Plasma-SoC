library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

-- wb enabled counter with reload and direction selection
----------------|-----------|------------------------------------
-- registers    | address   | description
----------------|-----------|------------------------------------
-- counter      | 0         | current counter value (r)
-- reload       | 1         | reload value (r/w)
-- control      | 2         | counter control register (r/w)
----------------|-----------|------------------------------------
-- control register:
-- bit 0: (r/w) enable
-- bit 1: (r/w) direction (0 = count up, 1 = count down)
-- bit 2: (r/w) user reset
entity slave_counter is 
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

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
end slave_counter;

architecture behavior of slave_counter is 
    signal err_s        : std_logic := '0';
    signal rld_s        : std_logic_vector(31 downto 0) := (others => '0');
    signal cnt_os       : std_logic_vector(31 downto 0) := (others => '0');
    signal control_s    : std_logic_vector(31 downto 0) := (others => '0');
begin
    stall_o <= '0';
    --err_o   <= err_s;
    rty_o   <= '0';
    

    process(clk_i, rst_i)
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            dat_o   <= (others => '0');
            err_o   <= '0';  
            ack_o   <= '0'; 
        elsif rising_edge(clk_i) then
            if stb_i = '1' then
                err_v := '0';

                if we_i = '0' then
                    case adr_i(7 downto 4) is
                        when x"0" => dat_o      <= cnt_os;
                        when x"1" => dat_o      <= rld_s;
                        when x"2" => dat_o      <= control_s;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"1" => rld_s      <= dat_i;
                        when x"2" => control_s  <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
            end if;
                
            ack_o <= stb_i and not err_v;
            err_o <= err_v;
        end if;
    end process;

    counter: entity plasmax_lib.counter
    port map 
    (
        clk_i   => clk_i,
        rst_i   => rst_i or control_s(2),

        en_i    => control_s(0),
        rld_i   => rld_s,
        dir_i   => control_s(1),
        cnt_o   => cnt_os,

        irq_o  => irq_o
    );

end behavior;