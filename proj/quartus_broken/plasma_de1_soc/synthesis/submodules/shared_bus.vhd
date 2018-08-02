library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
    use ieee.math_real.all;
    use ieee.std_logic_misc.all;

library zz_systems;    
    use zz_systems.wb_pkg.all;
    use zz_systems.util_pkg.all;


entity shared_bus is    
    generic 
    (
        constant masters    : natural := 1;
        constant slaves     : natural := 2;
        constant addr_w     : natural := 32;
        constant data_w     : natural := 32;
        constant sel_w      : natural := 4;

        constant addr_dec_w : natural := 32;
        constant memmap     : memmap_t := 
        (
            ( x"00000000", x"0FFFFFFE" ),
            ( x"10000000", x"0FFFFFFF" )
        )
    );
    port 
    (
        clk_i           : in std_logic;
        rst_i           : in std_logic;

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
        slave_cyc_o     : out std_logic_vector(slaves - 1 downto 0);
        slave_stb_o     : out std_logic_vector(slaves - 1 downto 0);

        slave_adr_o     : out std_logic_vector(addr_w - 1 downto 0);
        slave_we_o      : out std_logic;
        slave_dat_o     : out std_logic_vector(data_w - 1 downto 0);
        slave_sel_o     : out std_logic_vector(sel_w - 1 downto 0);

        slave_dat_i     : in  std_logic_vector(slaves * data_w - 1 downto 0);

        slave_ack_i     : in  std_logic_vector(slaves - 1 downto 0);
        slave_stall_i   : in  std_logic_vector(slaves - 1 downto 0);
        slave_err_i     : in  std_logic_vector(slaves - 1 downto 0);
        slave_rty_i     : in  std_logic_vector(slaves - 1 downto 0)
    );
end shared_bus;

architecture behavior of shared_bus is    
    signal master_id_s      : integer range 0 to masters - 1;
    signal addr_s           : std_logic_vector(addr_w - 1 downto 0) := (others => '0');
    signal addr_offset_s    : std_logic_vector(addr_s'range) := (others => '0');
    
    signal cs_s : std_logic_vector(slaves - 1 downto 0) := (others => '0');
begin
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            master_id_s <= 0;           
            addr_s      <= (others => '0');
        else
            if rising_edge(clk_i) then
                master_id_s     <= to_integer(unsigned(master_gnt_i));
                addr_s          <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w);
            end if;
        end if;
    end process;

    -- address translation -----------------------------------------------------

    addr_dec : for i in 0 to slaves - 1 generate
        cs_s(i) <= '1' when memmap(i).base_addr = (addr_s and not memmap(i).size) else 
                   '0';
    end generate;

    process(cs_s)
        variable offset : std_logic_vector(addr_w - 1 downto 0);
    begin
        offset    := (others => '0');

        for i in 0 to slaves - 1 loop
            offset := offset or (memmap(i).size and (offset'range => cs_s(i)));
        end loop;

        addr_offset_s <= offset;
    end process;

    -- master to slave ---------------------------------------------------------
    slave_stb_cyc : for i in 0 to slaves - 1 generate
        slave_stb_o(i) <= cs_s(i) and or_reduce(master_stb_i);
        slave_cyc_o(i) <= cs_s(i) and or_reduce(master_cyc_i);
    end generate;

    slave_adr_o <= master_adr_i((master_id_s + 1) * addr_w - 1  downto master_id_s * addr_w) and addr_offset_s;
    slave_dat_o <= master_dat_i((master_id_s + 1) * data_w - 1  downto master_id_s * data_w);
    slave_sel_o <= master_sel_i((master_id_s + 1) * sel_w - 1   downto master_id_s * sel_w);
    slave_we_o  <= master_we_i(master_id_s);

    -- slave to master ---------------------------------------------------------
    
    master_ack_o    <= or_reduce(slave_ack_i);
    master_err_o    <= or_reduce(slave_err_i) or nor_reduce(cs_s); -- error if slave reports error or invalid address provided
    master_rty_o    <= or_reduce(slave_rty_i);
    master_stall_o  <= or_reduce(slave_stall_i);

    process(clk_i, rst_i, slave_dat_i, cs_s)
        variable dat : std_logic_vector(data_w - 1 downto 0);
    begin 
        if rst_i = '1' then
            dat := (others => '0');       
            master_dat_o <= (others => '0');
        else
            if rising_edge(clk_i) and unsigned(cs_s) /= 0 then
                dat := (others => '0');

                for i in 0 to slaves - 1 loop
                    dat := dat or (slave_dat_i((i + 1) * data_w - 1  downto i * data_w) and (dat'range => cs_s(i)));
                end loop;
                master_dat_o <= dat;				
            end if;
        end if;
    end process;
end behavior;