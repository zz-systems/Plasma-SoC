--------------------------------------------------------------------------------
-- TITLE:  SPI Controller Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- SPI CONTROLLER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0x0       | r/w   | control register
-- status       | 0x4       | r     | status register
-- data         | 0x8       | r/w   | data
-- address      | 0xC       | r/w   | SPI slave address
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | user reset
-- enable       | 1         | r/w   | enable device
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | device ready
-- davail       | 1         | r     | data available
----------------|-----------|-------|-------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library zz_systems;
    use zz_systems.util_pkg.all;

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
    signal dat_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal dat_os  : std_logic_vector(31 downto 0) := (others => '0');
    signal adr_is  : std_logic_vector(31 downto 0) := (others => '0');
    signal ctrl_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s  : std_logic_vector(31 downto 0) := (others => '0');

    signal ack_s   : std_logic := '0';
    signal err_s   : std_logic := '0';

    alias stat_ready_a      : std_logic is stat_s(0);
    alias stat_davail_a     : std_logic is stat_s(1);

    alias ctrl_reset_a      : std_logic is ctrl_s(0);
    alias ctrl_enable_a     : std_logic is ctrl_s(1);
begin
    ack_o   <= ack_s;
    err_o   <= err_s;  
    stall_o <= stb_i and not stat_ready_a;
    irq_o   <= stat_davail_a;
    rty_o   <= '0';
 
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
                        when x"0" => dat_o      <= ctrl_s;
                        when x"4" => dat_o      <= stat_s;
                        when x"8" => dat_o      <= dat_os;
                        when x"C" => dat_o      <= adr_is;
                        when others => err_v    := '1';
                    end case;
                else
                    case adr_i(7 downto 4) is
                        when x"0" => ctrl_s     <= dat_i;
                        when x"8" => dat_is     <= dat_i;
                        when x"C" => adr_is     <= dat_i;
                        when others => err_v    := '1';
                    end case;
                end if;
            end if;
                
            err_s <= err_v;
            ack_s <= stb_i and not err_s and stat_ready_a;
        end if;
    end process;

    spi: entity zz_systems.spi_control 
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
        rst_i   => rst_i or ctrl_reset_a,

        en_i    => ctrl_enable_a,
        adr_i   => adr_is(bit_width(slaves) downto 0),
        dat_i   => dat_is(data_w - 1 downto 0),
        dat_o   => dat_os(data_w - 1 downto 0),

        MOSI    => MOSI,
        MISO    => MISO,
        SCLK    => SCLK,
        CS      => CS,

        ack_o   => stat_ready_a,
        irq_o   => stat_davail_a
    );

end behavior;