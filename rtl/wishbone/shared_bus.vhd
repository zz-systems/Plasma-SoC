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

   signal slave_we_os : std_logic;
   signal slave_sel_os : std_logic_vector(slave_sel_o'range) := (others => '0');

   signal master_adr_is : std_logic_vector(master_adr_i'range) := (others => '0');
   signal slave_dat_os : std_logic_vector(slave_dat_o'range) := (others => '0');

   signal delay_s : std_logic := '0';
begin

    cs_o <= cs_s;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            master_id_s <= 0;
           
            addr_s <= (others => '0');

            slave_dat_os    <= (others => '0');
            slave_we_os     <= '0'; 
            slave_sel_os    <= (others => '0');

            busy_o <= '0';
        else
            if rising_edge(clk_i) then
                master_id_s     <= to_integer(unsigned(master_gnt_i));

                addr_s          <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w);

                slave_dat_os    <= master_dat_i((master_id_s + 1) * data_w - 1  downto master_id_s * data_w);
                slave_we_os     <= master_we_i(master_id_s);
                slave_sel_os    <= master_sel_i((master_id_s + 1) * sel_w - 1   downto master_id_s * sel_w);

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

    addr_dec : for i in 0 to slaves - 1 generate
        cs_s(i) <= '1' when memmap(i).base_addr = (addr_s and not memmap(i).size) else 
                   '0';
    end generate;

    process(cs_s)
        variable offset, total_offset : std_logic_vector(addr_w - 1 downto 0);
        variable cs_v : integer := 0;
    begin
        total_offset    := (others => '0');

        for i in 0 to slaves - 1 loop
            total_offset := total_offset or (memmap(i).size and (offset'range => cs_s(i)));
        end loop;

        addr_offset_s <= total_offset;
    end process;

    -- master to slave
    slave_stb_cyc : for i in 0 to slaves - 1 generate
        slave_stb_o(i) <= '1' when cs_s(i) = '1' and master_stb_i /= (master_stb_i'range => '0') else '0';
        slave_cyc_o(i) <= '1' when cs_s(i) = '1' and master_cyc_i /= (master_cyc_i'range => '0') else '0';
    end generate;

    slave_adr_o <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w) and addr_offset_s;
    slave_dat_o <= master_dat_i((master_id_s + 1) * data_w - 1  downto master_id_s * data_w);
    slave_sel_o <= master_sel_i((master_id_s + 1) * sel_w - 1   downto master_id_s * sel_w);
    slave_we_o  <= master_we_i(master_id_s);

    -- slave to master
    slave_to_master : for i in 0 to slaves - 1 generate
        master_ack_s(i)     <= (slave_ack_i(i) and cs_s(i));
        master_err_s(i)     <= (slave_err_i(i) and cs_s(i));
        master_rty_s(i)     <= (slave_rty_i(i) and cs_s(i));
        master_stall_s(i)   <= (slave_stall_i(i) and cs_s(i));
    end generate;
    
    master_ack_o <= '1' when slave_ack_i /= (slave_ack_i'range => '0') else '0';
    master_err_o <= '1' when slave_err_i /= (slave_err_i'range => '0') else '0';
    master_rty_o <= '1' when slave_rty_i /= (slave_rty_i'range => '0') else '0';
    master_stall_o <= '1' when slave_stall_i /= (slave_stall_i'range => '0') else '0';

    process(slave_dat_i, cs_s)
        variable dat : std_logic_vector(data_w - 1 downto 0);
    begin 

        if cs_s /= (cs_s'range => '0') then
            dat := (others => '0');
            
            for i in 0 to slaves - 1 loop
                dat := dat or (slave_dat_i((i + 1) * data_w - 1  downto i * data_w) and (dat'range => cs_s(i)));
            end loop;
            master_dat_o <= dat;
        end if;
    end process;
end behavior;

