library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;

library zz_systems;
    use zz_systems.util_pkg.all;

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

    ack_o   : out std_logic;
    irq_o   : out std_logic
);
end;

architecture behavior of spi_control is
    constant divisor    : positive := (sys_clk / spi_clk) / 2;
    constant data_bw    : positive := bit_width(data_w) + 1;

    type states is (idle, send, hold1, hold2, hold3, hold4, done);
    signal state_s          : states := idle;

    signal adr_s            : std_logic_vector(adr_i'range);

    signal spi_clk_s        : std_logic := '1';
    signal spi_stb_s        : std_logic := '0';
    signal spi_ack_s        : std_logic := '0';
    signal spi_clk_en_s     : std_logic := '0';
    signal spi_bit_cnt_en_s : std_logic := '0';
    signal rst_counters_s   : std_logic := '0';
    
    signal spi_clk_falling  : std_logic := '0';
    signal miso_s           : std_logic := '0';
    
    signal fifo_s           : std_logic_vector(dat_o'range);
begin
    process(clk_i, rst_i)
        variable ack_delay_v : std_logic := '0';
    begin
        if rst_i = '1' then
            adr_s   <= (others => '0');
            state_s <= idle; 
        else
            if rising_edge(clk_i) then
                adr_s <= adr_i;
                case state_s is 
                    when idle => --Wait for en_i to go high
						if(en_i = '1') then
							state_s <= send;
						end if;
					when send => --Start sending bits, transition out when all bits are sent and SCLK is high
                        if spi_ack_s = '1' and spi_clk_falling = '0' then
                            state_s <= hold1;
                        end if; 
					when hold1 => --Hold CS low for a bit
                        state_s <= hold2;
					when hold2 => --Hold CS low for a bit
                        state_s <= hold3;
					when hold3 => --Hold CS low for a bit
                        state_s <= hold4;
					when hold4 => --Hold CS low for a bit
                        state_s <= done;
					when done => --Finish SPI transimission wait for en_i to go low
						if(en_i = '0') then
							state_s <= idle;
						end if;
					when others =>
                        state_s <= idle;
                end case;
            end if;
        end if;
    end process;

    irq_o           <= '1' when state_s = done and spi_stb_s = '1' else 
                       '0';

    dat_o           <= fifo_s;

    ack_o           <= '1' when state_s = done else 
                       '0';

    rst_counters_s  <= rst_i or not spi_clk_en_s;

    -- spi clock generation ----------------------------------------------------
    spi_clk_en_s    <= '1' when state_s = send else 
                       '0';

    spi_clk_cnt : entity zz_systems.counter 
    port map
    (
        clk_i => clk_i,
        rst_i => rst_counters_s,

        en_i  => spi_clk_en_s,
        rld_i => std_logic_vector(to_unsigned(divisor, 32)),
        dir_i => '0',
        cnt_o => open,

        irq_o => spi_stb_s
    );

    spi_clk_gen: process(clk_i, rst_i)
    begin 
        if rst_i = '1' or spi_clk_en_s = '0' then 
            spi_clk_s <= '1';
        elsif rising_edge(clk_i) then
            if spi_stb_s = '1' then
                spi_clk_s <= not spi_clk_s;
            end if;
        end if;
    end process;

    SCLK <= spi_clk_s;

    -- spi bit counter ---------------------------------------------------------
    spi_bit_cnt_en_s  <= '1' when state_s = send and spi_clk_s = '0' and spi_clk_falling = '0' else
                         '0';

    spi_bit_cnt : entity zz_systems.counter 
    generic map
    (
        data_w => data_bw
    )
    port map
    (
        clk_i => clk_i,
        rst_i => rst_counters_s,

        en_i  => spi_bit_cnt_en_s,
        rld_i => std_logic_vector(to_unsigned(data_w + 1, data_bw)),
        dir_i => '0',
        cnt_o => open,

        irq_o => spi_ack_s
    );

    -- address translation -----------------------------------------------------

    addr_dec : for i in 0 to slaves - 1 generate
        CS(i) <= '1' when to_integer(unsigned(adr_s)) /= i or ((state_s = idle) and en_i = '0') else
                 '0';
    end generate;

    -- master to slave ---------------------------------------------------------
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if state_s = send and spi_clk_s = '0' and spi_clk_falling = '0' then 
                MOSI <= fifo_s(data_w - 1);
            elsif state_s = idle then
                MOSI <= '1';
            end if;
        end if;
    end process;    

    -- slave to master ---------------------------------------------------------
    
    process(clk_i, spi_clk_s, spi_stb_s)
    begin
        if rising_edge(clk_i) then
            case state_s is 
            when idle => 
                fifo_s <= dat_i;
            when send => 
                if spi_clk_s = '0' and spi_clk_falling = '0' then 
                    spi_clk_falling <= '1';
                    fifo_s <= fifo_s(data_w - 2 downto 0) & MISO;
                elsif spi_clk_s = '1' then
                    spi_clk_falling <= '0';
                end if;
            when others => 
                -- nop;
            end case;
        end if;
    end process;
end behavior;