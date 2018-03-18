library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;

library plasmax_lib;
    use plasmax_lib.util_pkg.all;

entity spi_control is 
generic
(
    constant slaves     : positive := 1;

    constant data_w     : positive := 8;
    constant sys_clk    : positive := 50000000;
    constant spi_clk    : positive := 1000000
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    en_i    : in std_logic;
    adr_i   : in std_logic_vector(bit_width(slaves) downto 0);
    dat_i   : in std_logic_vector(data_w - 1 downto 0);
    dat_o   : out std_logic_vector(data_w - 1 downto 0);

    MOSI    : out std_logic;
    MISO    : in std_logic;
    SCLK    : out std_logic;
    CS      : out std_logic_vector(slaves - 1 downto 0);

    busy_o  : out std_logic;
    irq_o   : out std_logic
);
end;

architecture behavior of spi_control is
    constant divisor    : positive := (sys_clk / spi_clk) / 2;
    constant data_bw    : positive := bit_width(data_w);

    type states         is (idle, transition1, transition2, done1, done2);
    signal state_s      : states := idle;

    signal adr_s        : std_logic_vector(adr_i'range);
    signal spi_clk_s    : std_logic := '0';
    signal spi_stb_s    : std_logic := '0';
    signal spi_ack_s    : std_logic := '0';
    signal spi_clk_en_s : std_logic := '0';
    signal rst_spi_bit_cnt_s : std_logic := '0';
    

    signal miso_s       : std_logic := '0';
    
    signal fifo_s       : std_logic_vector(dat_o'range);
begin
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            adr_s   <= (others => '0');
            state_s <= idle; 
        else
            if rising_edge(clk_i) then
                adr_s <= adr_i;

                case state_s is 
                    when idle => 
                        if en_i = '1' then 
                            state_s <= transition1;
                        end if;
                    when transition1 => 
                        if spi_stb_s = '1' then 
                            state_s <= transition2;
                        end if;
                    when transition2 => 
                        if spi_stb_s = '1' then 
                            if spi_ack_s = '1' then 
                                state_s <= done1;
                            else 
                                state_s <= transition1;
                            end if;
                        end if;
                    when done1 => 
                        if spi_stb_s = '1' then 
                            state_s <= done2;
                        end if;
                    when done2 => 
                        if spi_stb_s = '1' then 
                            state_s <= idle;
                        end if;
                    when others => 
                        state_s <= idle;
                end case;
            end if;
        end if;
    end process;

    spi_clk_en_s    <= '1' when state_s = transition1 or state_s = transition2 else 
                       '0';

    irq_o           <= '1' when state_s = done1 and spi_stb_s = '1' else 
                       '0';

    dat_o           <= fifo_s;

    busy_o          <= '1' when state_s /= idle else 
                       '0';
    -- spi clock generation ----------------------------------------------------

    spi_clk_cnt : entity plasmax_lib.counter 
    port map
    (
        clk_i => clk_i,
        rst_i => rst_i,

        en_i  => '1',
        rld_i => std_logic_vector(to_unsigned(divisor, 32)),
        dir_i => '0',
        cnt_o => open,

        irq_o => spi_stb_s
    );

    spi_clk_gen: process(clk_i, rst_i)
    begin 
        if rst_i = '1' or spi_clk_en_s = '0' then 
            spi_clk_s <= '0';
        elsif rising_edge(clk_i) then
            if spi_stb_s = '1' then
                spi_clk_s <= not spi_clk_s;
            end if;
        end if;
    end process;

    SCLK <= spi_clk_s;

    -- address translation -----------------------------------------------------

    addr_dec : for i in 0 to slaves - 1 generate
        CS(i) <= '0' when to_integer(unsigned(adr_s)) = i 
                     and (state_s = idle or state_s = done2) else 
                 '1';
    end generate;

    -- master to slave ---------------------------------------------------------
    
    MOSI <= fifo_s(data_w - 1);

    -- slave to master ---------------------------------------------------------
    
    rst_spi_bit_cnt_s <= rst_i or not spi_clk_en_s;
    
    spi_bit_cnt : entity plasmax_lib.counter 
    generic map
    (
        data_w => data_bw
    )
    port map
    (
        clk_i => clk_i,
        rst_i => rst_spi_bit_cnt_s,

        en_i  => spi_clk_en_s,
        rld_i => std_logic_vector(to_unsigned(data_w - 1, data_bw)),
        dir_i => '0',
        cnt_o => open,

        irq_o => spi_ack_s
    );

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_s is 
            when idle => 
                fifo_s <= dat_i;
            when transition1 => 
                miso_s <= MISO;
            when transition2 => 
                fifo_s <= fifo_s(data_w - 2 downto 0) & miso_s;
            when others => 
                -- nop;
            end case;
        end if;
    end process;
end behavior;