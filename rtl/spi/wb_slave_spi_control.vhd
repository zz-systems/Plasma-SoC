library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;
    use plasmax_lib.util_pkg.all;

-- wb enabled SPI controller
----------------|-----------|------------------------------------
-- registers    | address   | description
----------------|-----------|------------------------------------
-- data         | 0         | data register
-- control      | 1         | control/status register
----------------|-----------|------------------------------------
-- control register:
-- bit 0: (r/w) enable
-- bit 1: (r) busy
-- bit 2: (r) dat_o ready
entity slave_spic is 
generic
(
    constant slaves     : positive := 1;

    constant data_w     : positive := 8;
    constant sys_clk    : positive := 50000000;
    constant spi_clk    : positive := 1000000
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    MOSI    : out std_logic;
    MISO    : in std_logic;
    SCLK    : out std_logic;
    CS      : out std_logic_vector(slaves - 1 downto 0);

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
end slave_spic;

architecture behavior of slave_spic is 
    signal adr_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal ctrl_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_os  : std_logic_vector(31 downto 0) := (others => '0');

    signal ack_s   : std_logic := '0';
    signal err_s   : std_logic := '0';

    alias irq_a    : std_logic is ctrl_s(2);
    alias busy_a   : std_logic is ctrl_s(1);
    alias en_a     : std_logic is ctrl_s(0);
begin
    ack_o   <= ack_s;
    err_o   <= err_s;  
    stall_o <= busy_a;
    irq_o   <= irq_a;
 
    process(clk_i, rst_i)
        variable err_v  : std_logic := '0';
    begin         
        if rst_i = '1' then  
            dat_o   <= (others => '0');
            ack_s   <= '0';
            err_s   <= '0';  
        elsif rising_edge(clk_i) then
            err_v := '0';

            if stb_i = '1' then
                if we_i = '0' then
                    case adr_i(7 downto 4) is
                        when x"0" => dat_o      <= dat_os;
                        when x"1" => dat_o      <= ctrl_s;
                        when x"2" => dat_o      <= adr_is;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"0" => dat_is     <= dat_i;
                        when x"1" => ctrl_s     <= dat_i;
                        when x"2" => adr_is     <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
            end if;
                
            err_s <= err_v;
            ack_s <= stb_i and not err_s and not busy_a;
        end if;
    end process;

    spi: entity plasmax_lib.spi_control 
    generic map
    (
        slaves      => slaves,
        data_w      => data_w,
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
    )
    port map
    (
        clk_i   => clk_i,
        rst_i   => rst_i,

        en_i    => en_a,
        adr_i   => adr_is(bit_width(slaves) downto 0),
        dat_i   => dat_is(data_w - 1 downto 0),
        dat_o   => dat_os(data_w - 1 downto 0),

        MOSI    => MOSI,
        MISO    => MISO,
        SCLK    => SCLK,
        CS      => CS,

        busy_o  => busy_a,
        irq_o   => irq_a
    );

end behavior;