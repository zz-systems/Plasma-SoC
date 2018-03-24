--------------------------------------------------------------------------------
-- TITLE:  Display controller Wishbone interface
-- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
--------------------------------------------------------------------------------
-- DISPLAY CONTROLLER
----------------|-----------|-------|-------------------------------------------
-- REGISTER     | address   | mode  | description
----------------|-----------|-------|-------------------------------------------
-- control      | 0x0       | r/w   | control register
-- status       | 0x4       | r     | status register
-- data         | 0x8       | w     | vram data window
-- vaddr        | 0xC       | r/w   | vram address
----------------|-----------|-------|-------------------------------------------
-- CONTROL      |           |       | 
----------------|-----------|-------|-------------------------------------------
-- reset        | 0         | r/w   | reset device
-- enable       | 1         | r/w   | enable device
-- immediate    | 2         | r/w   | immediate mode (immediate SPI commands)
-- textmode     | 3         | r/w   | text mode (interpret vram as ASCII)
-- flush        | 4         | r/w   | flush vram to screen
----------------|-----------|-------|-------------------------------------------
-- STATUS       |           |       | 
----------------|-----------|-------|-------------------------------------------
-- ready        | 0         | r     | display ready
----------------|-----------|-------|-------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;

entity slave_oledc is 
generic
(
    constant sys_clk        : positive := 50000000;
    constant spi_clk        : positive := 1000000
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    sdin_o  : out std_logic;
    sclk_o  : out std_logic;
    dc_o    : out std_logic;
    res_o   : out std_logic;
    vbat_o  : out std_logic;
    vdd_o   : out std_logic;

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
end slave_oledc;

architecture behavior of slave_oledc is 
    signal ctrl_s  : std_logic_vector(31 downto 0) := (others => '0');
    signal stat_s  : std_logic_vector(31 downto 0) := (others => '0');
    
    signal dat_is  : std_logic_vector(7 downto 0)  := (others => '0');
    signal dat_os  : std_logic_vector(31 downto 0) := (others => '0');

    signal adr_s   : std_logic_vector(9 downto 0)  := (others => '0');

    signal ack_s    : std_logic := '0';
    signal err_s    : std_logic := '0';
    signal we_s     : std_logic := '0';

    alias stat_ready_a      : std_logic is stat_s(0);

    alias ctrl_rst_a        : std_logic is ctrl_s(0);
    alias ctrl_imm_a        : std_logic is ctrl_s(1);
    alias ctrl_txtm_a       : std_logic is ctrl_s(2);
    alias ctrl_flush_a      : std_logic is ctrl_s(3);
begin
    irq_o   <= stat_ready_a;

    dat_o   <= dat_os;

    ack_o   <= ack_s;
    rty_o   <= '0';
    stall_o <= '0';
    err_o   <= err_s;

    process(clk_i, rst_i)
        variable ack_v  : std_logic := '0';
        variable err_v  : std_logic := '0';
        variable we_v   : std_logic := '0';
    begin         
        if rst_i = '1' then
            ctrl_s  <= (others => '0');

            dat_is  <= (others => '0');
            dat_os  <= (others => '0');

            adr_s   <= (others => '0');

            ack_s   <= '0';
            err_s   <= '0'; 
            we_s    <= '0'; 
        elsif rising_edge(clk_i) then
            ack_v := '0';
            err_v := '0';
            we_v  := '0';

            if stb_i = '1' then
                ack_v := '1';

                if we_i = '0' then
                    case adr_i(3 downto 0) is 
                        when x"0" => dat_os     <= ctrl_s;
                        when x"4" => dat_os     <= stat_s;
                        when x"C" => dat_os     <= ZERO(31 downto 10) & adr_s;
                        when others => err_v := '1';
                    end case;
                else
                    case adr_i(3 downto 0) is 
                        when x"0" => ctrl_s     <= dat_i;
                        when x"8" => adr_s      <= dat_i(9 downto 0);
                        when x"C" => 
                            dat_is     <= dat_i(7 downto 0);
                            we_v    := '1';
                        when others => err_v := '1';
                    end case;
                end if;
            end if;

            ack_s   <= ack_v and not err_v;    
            err_s   <= err_v;
            we_s    <= we_v;
        end if;
    end process;

    u_oled: entity plasmax_lib.oled_control
    generic map
    (
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
    )
    port map 
    (  
        clk_i       => clk_i,
        rst_i       => rst_i or ctrl_rst_a,

        sdin_o      => sdin_o,
        sclk_o      => sclk_o,
        dc_o        => dc_o,
        res_o       => res_o,
        vbat_o      => vbat_o,
        vdd_o       => vdd_o,

        adr_i       => adr_s,
        dat_i       => dat_is,
        we_i        => we_s,

        cmd_i       => ctrl_imm_a,
        text_mode_i => ctrl_txtm_a,
        flush_i     => ctrl_flush_a,
        ready_o     => stat_ready_a
    );

end behavior;