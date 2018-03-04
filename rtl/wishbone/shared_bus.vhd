library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;   
   use ieee.math_real.all;

library plasmax_lib;    
    use plasmax_lib.wb_pkg.all;
    use plasmax_lib.util_pkg.all;


entity shared_bus is    
    generic (
        constant masters : natural := 1;
        constant slaves : natural := 2;
        constant addr_w : natural := 32;
        constant data_w : natural := 32;
        constant sel_w : natural := 4;

        constant addr_dec_w : natural := 32;
        constant memmap : memmap_t := 
        (
            ( x"00000000", x"0FFFFFFE" ),
            ( x"10000000", x"0FFFFFFF" )
        )
    );
    port (
        clk_i           : in std_logic;
        rst_i           : in std_logic;

        busy_o          : out std_logic;

        -- arbiter interface 
        master_gnt_i    : in std_logic_vector(bit_width(masters) downto 0);

        -- master interface
        master_cyc_i    : in std_logic_vector(masters - 1 downto 0);
        master_stb_i    : in std_logic_vector(masters - 1 downto 0);

        master_adr_i    : in std_logic_vector(masters * addr_w - 1 downto 0);
        master_we_i     : in std_logic_vector(masters - 1 downto 0);
        master_dat_i    : in std_logic_vector(masters * data_w - 1 downto 0);
        master_sel_i    : in std_logic_vector(masters * sel_w - 1 downto 0);

        master_dat_o    : out std_logic_vector(data_w - 1 downto 0);

        master_ack_o    : out std_logic;
        master_stall_o  : out std_logic;
        master_err_o    : out std_logic;
        master_rty_o    : out std_logic;

        -- slave interface
        slave_cyc_o      : out std_logic_vector(slaves - 1 downto 0);
        slave_stb_o      : out std_logic_vector(slaves - 1 downto 0);

        slave_adr_o     : out std_logic_vector(addr_w - 1 downto 0);
        slave_we_o      : out std_logic;
        slave_dat_o     : out std_logic_vector(data_w - 1 downto 0);
        slave_sel_o     : out std_logic_vector(sel_w - 1 downto 0);

        slave_dat_i     : in  std_logic_vector(slaves * data_w - 1 downto 0);

        slave_ack_i     : in  std_logic_vector(slaves - 1 downto 0);
        slave_stall_i   : in  std_logic_vector(slaves - 1 downto 0);
        slave_err_i     : in  std_logic_vector(slaves - 1 downto 0);
        slave_rty_i     : in  std_logic_vector(slaves - 1 downto 0);

        cs_o : out std_logic_vector(slaves - 1 downto 0)
    );
end shared_bus;

architecture behavior of shared_bus is    
    signal master_id_s      : integer range 0 to masters - 1;
    signal addr_s           : std_logic_vector(addr_w - 1 downto 0) := (others => '0');
    signal base_addr_s      : std_logic_vector(slaves * addr_w - 1 downto 0) := (others => '0');
    signal addr_offset_s    : std_logic_vector(addr_s'range) := (others => '0');

    signal master_ack_s    : std_logic_vector(slaves - 1 downto 0) := (others => '0');
    signal master_stall_s  : std_logic_vector(slaves - 1 downto 0) := (others => '0');
    signal master_err_s    : std_logic_vector(slaves - 1 downto 0) := (others => '0');
    signal master_rty_s    : std_logic_vector(slaves - 1 downto 0) := (others => '0');
    
    signal cs_s : std_logic_vector(slaves - 1 downto 0) := (others => '0');
    signal cs : natural range 0 to bit_width(slaves);

   signal slave_cyc_os : std_logic_vector(slave_cyc_o'range) := (others => '0');
begin

    cs_o <= cs_s;

    process(clk_i, rst_i)
        variable csn_v : integer := 0;
        variable cs_v : std_logic_vector(slaves - 1 downto 0) := (others => '0');
        variable offset_v : std_logic_vector(addr_w - 1 downto 0) := (others => '0');
        variable dat_o : std_logic_vector(data_w - 1 downto 0) := (others => '0');
    begin
        cs_v := (others => '0');
        csn_v := 0;
        if rst_i = '1' then
            master_id_s <= 0;

            busy_o <= '0';

            master_ack_s    <= (others => '0');
            master_stall_s  <= (others => '0'); 
            master_err_s    <= (others => '0'); 
            master_rty_s    <= (others => '0');
            --master_dat_o <= (others => '0');

            addr_offset_s <= (others => '0');
            addr_s <= (others => '0');
            cs_s <= (others => '0');
            cs <= 0;
            --master_dat_o <= (others => '0');
        else
            if rising_edge(clk_i) then
                master_id_s <= to_integer(unsigned(master_gnt_i));
                addr_s <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w);

                offset_v := (others => '0');
                --dat_o := (others => '0');

                for i in 0 to slaves - 1 loop
                    if memmap(i).base_addr = (addr_s and not memmap(i).size) then
                        cs_v(i) := '1';
                        csn_v := i;
                    else
                        cs_v(i) := '0';
                        --csn_v := 0;
                    end if;

                    offset_v := offset_v or (memmap(i).size and (offset_v'range => cs_v(i)));
                    --dat_o := dat_o or (slave_dat_i((slaves - i) * data_w - 1  downto (slaves - i - 1) * data_w) and (dat_o'range => cs_v(i)));
                end loop;

                --master_dat_o <= dat_o;
                addr_offset_s <= offset_v;
                cs_s <= cs_v;
                cs <= csn_v;

                if slave_cyc_os /= (slave_cyc_os'range => '0') then
                    busy_o <= '1';
                else 
                    busy_o <= '0';
                end if;
            end if;
        end if;
    end process;

    -- master arbitration
    -- address translation

    

    -- addr_dec : for i in 0 to slaves - 1 generate
    --     --base_addr_s((i + 1) * addr_w - 1 downto i * addr_w) <= addr_s and not memmap(i).size;
    --     --cs_s(i)         <= '1' when memmap(i).base_addr = base_addr_s((i + 1) * addr_w - 1 downto i * addr_w) else
    --     --                   '0';        
    --     cs_s(i) <= '1' when memmap(i).base_addr = (addr_s and not memmap(i).size) else 
    --                '0';
    -- end generate;

    --cs <= natural(ceil(log2(real(to_integer(unsigned(cs_s))))));-- natural(bit_width(unsigned(cs_s)));

    -- process(cs_s)
    --     variable offset, total_offset : std_logic_vector(addr_w - 1 downto 0);
    --     variable cs_v : integer := 0;
    -- begin

    --     offset          := (others => '0');
    --     total_offset    := (others => '0');

    --     for i in 0 to slaves - 1 loop
    --         offset     := memmap(i).size; --std_ulogic_vector(to_integer(memmap(i).size, addr_dec_w) - 1);
    --         total_offset := total_offset or (offset and (offset'range => cs_s(i)));

    --         if cs_s(i) = '1' then
    --             cs_v := i;
    --         else 
    --             cs_v := 0;
    --         end if;
    --     end loop;

    --     addr_offset_s <= total_offset;
    --     cs <= cs_v;        
    -- end process;

    -- master to slave

    slave_stb_cyc : for i in 0 to slaves - 1 generate
        -- slave_stb_o(i) <= '1' when cs_s(i) = '1' and master_stb_i /= (master_stb_i'range => '0') else '0';
        -- slave_cyc_o(i) <= '1' when cs_s(i) = '1' and master_cyc_i /= (master_cyc_i'range => '0') else '0';

        slave_stb_o(i) <= cs_s(i);
        slave_cyc_o(i) <= cs_s(i);
    end generate;
    
    -- slave_adr_os <= master_adr_is((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w) and addr_offset_s;
    -- slave_dat_os <= master_dat_is((master_id_s + 1) * data_w - 1  downto master_id_s * data_w);
    -- slave_sel_os <= master_sel_is((master_id_s + 1) * sel_w - 1   downto master_id_s * sel_w);
    -- slave_we_os  <= master_we_is(master_id_s);

    slave_adr_o <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w) and addr_offset_s;-- memmap(cs).size;
    slave_dat_o <= master_dat_i((master_id_s + 1) * data_w - 1  downto master_id_s * data_w);
    slave_sel_o <= master_sel_i((master_id_s + 1) * sel_w - 1   downto master_id_s * sel_w);
    slave_we_o  <= master_we_i(master_id_s);

    -- slave to master
    slave_to_master : for i in 0 to slaves - 1 generate
        --master_dat_s(i)     <= (slave_dat_i((i + 1) * data_w - 1  downto i * data_w) and (dat'range => cs_s(slaves - i - 1)));

        master_ack_s(i)     <= (slave_ack_i(i) and cs_s(slaves - i - 1));
        master_err_s(i)     <= (slave_err_i(i) and cs_s(slaves - i - 1));
        master_rty_s(i)     <= (slave_rty_i(i) and cs_s(slaves - i - 1));
        master_stall_s(i)   <= (slave_stall_i(i) and cs_s(slaves - i - 1));
    end generate;
    
    -- master_ack_os <= '1' when master_ack_s /= (master_ack_s'range => '0') else '0';
    -- master_err_os <= '1' when master_err_s /= (master_err_s'range => '0') else '0';
    -- master_rty_os <= '1' when master_rty_s /= (master_rty_s'range => '0') else '0';
    -- master_stall_os <= '1' when master_stall_s /= (master_stall_s'range => '0') else '0';

    -- master_ack_o <= '1' when master_ack_s /= (master_ack_s'range => '0') else '0';
    -- master_err_o <= '1' when master_err_s /= (master_err_s'range => '0') else '0';
    -- master_rty_o <= '1' when master_rty_s /= (master_rty_s'range => '0') else '0';
    -- master_stall_o <= '1' when master_stall_s /= (master_stall_s'range => '0') else '0';

    master_ack_o <= '1' when slave_ack_i /= (slave_ack_i'range => '0') else '0';
    master_err_o <= '1' when slave_err_i /= (slave_err_i'range => '0') else '0';
    master_rty_o <= '1' when slave_rty_i /= (slave_rty_i'range => '0') else '0';
    master_stall_o <= '1' when slave_stall_i /= (slave_stall_i'range => '0') else '0';

    process(slave_dat_i, cs_s)
        variable dat : std_logic_vector(data_w - 1 downto 0);
    begin 
        dat := (others => '0');

        for i in 0 to slaves - 1 loop
            dat := dat or (slave_dat_i((i + 1) * data_w - 1  downto i * data_w) and (dat'range => cs_s(slaves - i - 1)));
        end loop;

        --master_dat_os <= dat;
        master_dat_o <= dat;
    end process;

    --master_dat_o <= slave_dat_i((cs + 1) * data_w - 1  downto cs * data_w) and (master_dat_o'range => cs_s(cs));

    -- process(slave_ack_i, cs_s)
    --     variable ack : std_logic;
    -- begin 
    --     ack := '0';

    --     for i in 0 to slaves - 1 loop
    --         ack := ack or (slave_ack_i(i) and cs_s(slaves - i - 1));
    --     end loop;
        
    --     master_ack_o <= ack;
    -- end process;

    -- process(slave_err_i, cs_s)
    --     variable err : std_logic;
    -- begin 
    --     err := '0';

    --     for i in 0 to slaves - 1 loop
    --         err := err or (slave_err_i(i) and cs_s(slaves - i - 1));
    --     end loop;

    --     master_err_o <= err;
    -- end process;

    -- process(slave_rty_i, cs_s)
    --     variable rty : std_logic;
    -- begin 
    --     rty := '0';

    --     for i in 0 to slaves - 1 loop
    --         rty := rty or (slave_rty_i(i) and cs_s(slaves - i - 1));
    --     end loop;

    --     master_rty_o <= rty;
    -- end process;

    -- master_stall_o <= '1' when slave_stall_i /= (slave_stall_i'range => '0') else '0';
end behavior;

