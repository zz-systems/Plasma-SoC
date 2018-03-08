---------------------------------------------------------------------
-- TITLE: Plasma (CPU core with memory)
-- AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
-- DATE CREATED: 6/4/02
-- FILENAME: plasma.vhd
-- PROJECT: Plasma CPU core
-- COPYRIGHT: Software placed into the public domain by the author.
--    Software 'as is' without warranty.  Author liable for nothing.
-- DESCRIPTION:
--    This entity combines the CPU core with memory and a UART.
--
-- Memory Map:
--   0x00000000 - 0x0000ffff   Internal RAM (16KB)
--   0x10000000 - 0x000fffff   External RAM (1MB)
--   Access all Misc registers with 32-bit accesses
--   0x20000000  Uart Write (will pause CPU if busy)
--   0x20000000  Uart Read
--   0x20000010  IRQ Mask
--   0x20000020  IRQ Status
--   0x20000030  GPIO0 Out
--   0x20000050  GPIOA In
--   0x20000060  Counter
--   IRQ bits:
--      7   GPIO31
--      6   GPIO30
--      5  ^GPIO31
--      4  ^GPIO30
--      3   Counter(18)
--      2  ^Counter(18)
--      1  ^UartWriteBusy
--      0   UartDataAvailable
---------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;
    
library plasmax_lib;
    use plasmax_lib.wb_pkg.all;
    use plasmax_lib.util_pkg.all;

entity plasmax is
   generic(memory_type : string := "XILINX_16X"; --"DUAL_PORT_" "ALTERA_LPM";
           log_file    : string := "UNUSED");
   port(clk               : in std_logic;
        reset             : in std_logic;

        uart_write        : out std_logic;
        uart_read         : in std_logic;

        address           : out std_logic_vector(31 downto 2);
        data_write        : out std_logic_vector(31 downto 0);
        data_read         : in std_logic_vector(31 downto 0);
        write_byte_enable : out std_logic_vector(3 downto 0);
        mem_pause_in      : in std_logic;

        gpio0_out         : out std_logic_vector(31 downto 0);
        gpioA_in          : in std_logic_vector(31 downto 0)
    );
end; --entity plasma

architecture logic of plasmax is
    
   constant masters : positive := 1;
   constant slaves : positive := 3;

   signal data_read_uart      : std_logic_vector(7 downto 0);
   signal data_write_uart     : std_logic_vector(7 downto 0);

   signal mem_pause           : std_logic;

   signal enable_internal_ram : std_logic;
   signal enable_misc         : std_logic;
   signal enable_uart         : std_logic;
   signal enable_uart_read    : std_logic;
   signal enable_uart_write   : std_logic;

   signal gpio0_reg           : std_logic_vector(31 downto 0);

   signal uart_write_busy     : std_logic;
   signal uart_data_avail     : std_logic;
   signal irq_mask_reg        : std_logic_vector(7 downto 0);
   signal irq_status_raw      : std_logic_vector(7 downto 0);
   signal irq_invert          : std_logic_vector(7 downto 0);
   signal irq                 : std_logic;
   signal counter_reg         : std_logic_vector(31 downto 0);

    signal uart_we : std_logic;
    signal uart_data_o : std_logic_vector(7 downto 0);
  
    signal master_select    : std_logic_vector(bit_width(masters) downto 0);    
    signal slave_select     : std_logic_vector(bit_width(slaves) downto 0);
        
    signal cpu_port : wb_port;
    signal mem_port, ext_mem_port, misc_port : wb_port;

    signal bus_busy : std_logic;

    signal master_ports : wb_master_ports;
    signal slave_ports : wb_slave_ports;

    signal gpio_enable : std_logic;   
    
    
    constant debug : string := "false";    
        
    attribute mark_debug : string;
    attribute mark_debug of cpu_port : signal is debug;
    attribute mark_debug of mem_port : signal is debug;
    attribute mark_debug of ext_mem_port : signal is debug;
    attribute mark_debug of misc_port : signal is debug;
    attribute mark_debug of slave_select : signal is debug;
begin  --architecture

    irq_status_raw <= gpioA_in(31 downto 30)
                   & (gpioA_in(31 downto 30) xor "11") 
                   & counter_reg(18) 
                   & not counter_reg(18) 
                   & not uart_write_busy 
                   & uart_data_avail;

    irq <= '1' when (irq_status_raw and irq_mask_reg) /= ZERO(7 downto 0) else '0';
    gpio0_out <= gpio0_reg;   


    gpio_enable <= '1' when misc_port.adr(7 downto 4) = "0011" and misc_port.stb = '1' else '0';
    --error_code(bit_width(slaves) downto 0) <= slave_select;
    --error_code <= x"00" & "00" & gpio_enable & cpu_port.stall & cpu_port.we & mem_port.stb & ext_mem_port.stb & misc_port.stb;

    master_ports.cyc(0)     <= cpu_port.cyc;
    master_ports.stb(0)     <= cpu_port.stb;

    master_ports.adr        <= cpu_port.adr;
    master_ports.we(0)      <= cpu_port.we;
    cpu_port.dat_i           <= master_ports.dat_i;
    master_ports.sel        <= cpu_port.sel;

    master_ports.dat_o      <= cpu_port.dat_o;

    cpu_port.ack        <= master_ports.ack;
    cpu_port.stall      <= master_ports.stall;
    cpu_port.err        <= master_ports.err;   
    cpu_port.rty        <= master_ports.rty;  

    mem_port.cyc             <= slave_ports.cyc(0);
    ext_mem_port.cyc         <= slave_ports.cyc(1);
    misc_port.cyc            <= slave_ports.cyc(2);

    mem_port.stb             <= slave_ports.stb(0);
    ext_mem_port.stb         <= slave_ports.stb(1);
    misc_port.stb            <= slave_ports.stb(2);

    mem_port.adr            <= slave_ports.adr;
    ext_mem_port.adr        <= slave_ports.adr;
    misc_port.adr           <= slave_ports.adr;
                
    mem_port.we             <= slave_ports.we;
    ext_mem_port.we         <= slave_ports.we;
    misc_port.we            <= slave_ports.we;

    mem_port.dat_i          <= slave_ports.dat_i;
    ext_mem_port.dat_i      <= slave_ports.dat_i;
    misc_port.dat_i         <= slave_ports.dat_i;

    mem_port.sel            <= slave_ports.sel;
    ext_mem_port.sel        <= slave_ports.sel;
    misc_port.sel           <= slave_ports.sel;

    slave_ports.dat_o      <= mem_port.dat_o & ext_mem_port.dat_o & misc_port.dat_o;

    slave_ports.ack(0)     <= mem_port.ack;
    slave_ports.ack(1)     <= ext_mem_port.ack;
    slave_ports.ack(2)     <= misc_port.ack;

    slave_ports.stall(0)     <= mem_port.stall;
    slave_ports.stall(1)     <= ext_mem_port.stall;
    slave_ports.stall(2)     <= misc_port.stall;

    slave_ports.err(0)     <= mem_port.err;
    slave_ports.err(1)     <= ext_mem_port.err;
    slave_ports.err(2)     <= misc_port.err;

    slave_ports.rty(0)     <= mem_port.rty;
    slave_ports.rty(1)     <= ext_mem_port.rty;
    slave_ports.rty(2)     <= misc_port.rty;

    -- slave_ports.ack        <= mem_port.ack & ext_mem_port.ack & misc_port.ack;
    -- slave_ports.stall      <= mem_port.stall & ext_mem_port.stall & misc_port.stall;
    -- slave_ports.err        <= mem_port.err & ext_mem_port.err & misc_port.err;   
    -- slave_ports.rty        <= mem_port.rty & ext_mem_port.rty & misc_port.rty;

    -- wb_map_master_to_channel(0, master_ports, cpu_port);
    -- wb_map_channel_to_master(0, master_ports, cpu_port);

    -- wb_map_slave_to_channel(0, slave_ports, mem_port);
    -- wb_map_channel_to_slave(0, slave_ports, mem_port);

    -- wb_map_slave_to_channel(1, slave_ports, ext_mem_port);
    -- wb_map_channel_to_slave(1, slave_ports, ext_mem_port);

    -- wb_map_slave_to_channel(2, slave_ports, misc_port);
    -- wb_map_channel_to_slave(2, slave_ports, misc_port);


    arbiter : entity plasmax_lib.arbiter
    generic map(
        channel_descriptors => ( 0 => 16#1# )
    )
    port map(
        clk_i => clk,
        rst_i => reset,
        
        interruptible_i => (others => '1'),

        busy_i => bus_busy,

        cs_o => master_select
    );

    system_bus : entity plasmax_lib.shared_bus
    generic map (
        masters => 1,
        slaves => 3,

        memmap => (
            ( x"00000000", x"0FFFFFFF" ),  -- internal memory
            ( x"10000000", x"001FFFFF" ),  -- external memory
            ( x"20000000", x"0FFFFFFF" )   -- misc
        )
    )
    port map
    (
        clk_i => clk,
        rst_i => reset,

        busy_o => bus_busy,
        cs_o => slave_select,
        -- arbiter interface 
        master_gnt_i => "0",--master_select,

        -- master interface
        master_cyc_i    => master_ports.cyc,
        master_stb_i    => master_ports.stb,

        master_adr_i    => master_ports.adr,
        master_we_i     => master_ports.we,
        master_dat_i    => master_ports.dat_o,
        master_sel_i    => master_ports.sel,

        master_dat_o    => master_ports.dat_i,

        master_ack_o    => master_ports.ack,
        master_stall_o  => master_ports.stall,
        master_err_o    => master_ports.err,
        master_rty_o    => master_ports.rty,

        -- slave interface
        slave_cyc_o     => slave_ports.cyc,
        slave_stb_o     => slave_ports.stb,

        slave_adr_o     => slave_ports.adr,
        slave_we_o      => slave_ports.we,
        slave_dat_o     => slave_ports.dat_i,
        slave_sel_o     => slave_ports.sel,

        slave_dat_i     => slave_ports.dat_o,

        slave_ack_i     => slave_ports.ack,
        slave_stall_i   => slave_ports.stall,
        slave_err_i     => slave_ports.err,
        slave_rty_i     => slave_ports.rty
    );  

    u1_cpu : entity plasmax_lib.master_cpu
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        irq_i   => irq,
        mem_pause_o => mem_pause,

        cyc_o   => cpu_port.cyc,
        stb_o   => cpu_port.stb,
        we_o    => cpu_port.we,

        adr_o   => cpu_port.adr,
        dat_o   => cpu_port.dat_o,

        sel_o   => cpu_port.sel,

        dat_i   => cpu_port.dat_i,
        ack_i   => cpu_port.ack,
        rty_i   => cpu_port.rty,
        stall_i => cpu_port.stall,
        err_i   => cpu_port.err
    );

    u2_ram: entity plasmax_lib.slave_memory
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        cyc_i => mem_port.cyc,
        stb_i => mem_port.stb,
        we_i  => mem_port.we,

        adr_i => mem_port.adr,
        dat_i => mem_port.dat_i,

        sel_i => mem_port.sel,

        dat_o => mem_port.dat_o,
        ack_o => mem_port.ack,
        rty_o => mem_port.rty,
        stall_o => mem_port.stall,
        err_o => mem_port.err
    );

    -- ext. mem:

    address <= ext_mem_port.adr(31 downto 2);
    data_write <= ext_mem_port.dat_i;
    ext_mem_port.dat_o <= data_read;
    write_byte_enable <= ext_mem_port.sel;

    ext_mem_port.ack <= '0';
    ext_mem_port.rty <= '0';
    ext_mem_port.stall <= mem_pause_in;
    ext_mem_port.err <= '0';

    -- uart

    enable_uart <= '1' when misc_port.stb = '1' and misc_port.adr(7 downto 4) = "0000" else '0';
    uart_we <= '1' when misc_port.stb = '1' and misc_port.sel /= "0000" else '0';
    enable_uart_read <= misc_port.stb and enable_uart;
    enable_uart_write <= '1' when misc_port.stb = '1' and enable_uart = '1' and uart_we = '1' else '0';

    u3_uart: entity plasma_lib.uart
    generic map (log_file => log_file)
    port map
    (
        clk          => clk,
        reset        => reset,

        enable_read  => enable_uart_read, 
        enable_write => enable_uart_write, 
        data_in      => misc_port.dat_i(7 downto 0),
        data_out     => data_read_uart,
        uart_read    => uart_read,
        uart_write   => uart_write,
        busy_write   => uart_write_busy,
        data_avail   => uart_data_avail
    );

    misc_port.err <= '0';
    misc_port.rty <= '0';
    
    misc : process(clk, reset, misc_port.stb)
    begin 
        if reset = '1' then
            irq_mask_reg           <= ZERO(7 downto 0);
            gpio0_reg              <= ZERO;
            counter_reg            <= ZERO;
        
            misc_port.dat_o        <= (others => '0');
            misc_port.stall <= '0';                       
            misc_port.ack <= '0';
        elsif rising_edge(clk) then
            counter_reg <= bv_inc(counter_reg);
            --misc_port.dat_o <= mem_port.dat_o;

            if misc_port.stb = '1' then
                if misc_port.we = '0' then 
                    case misc_port.adr(7 downto 4) is
                    when "0000" =>      --uart
                        misc_port.dat_o <= ZERO(31 downto 8) & data_read_uart;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0001" =>      --irq_mask
                        misc_port.dat_o <= ZERO(31 downto 8) & irq_mask_reg;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0010" =>      --irq_status
                        misc_port.dat_o <= ZERO(31 downto 8) & irq_status_raw; --x"02";--
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0011" =>      --gpio0
                        misc_port.dat_o <= gpio0_reg;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0101" =>      --gpioA
                        misc_port.dat_o <= gpioA_in;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0110" =>      --counter
                        misc_port.dat_o <= counter_reg;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when others =>
                        misc_port.dat_o <= gpioA_in;
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    end case;
                    misc_port.err <= '0';
                else 
                    --misc_port.dat_o <= mem_port.dat_o;

                    case misc_port.adr(7 downto 4) is
                    when "0000" =>      --uart
                        misc_port.stall <= uart_write_busy;
                        misc_port.ack <= not uart_write_busy;
                        misc_port.err <= '0';
                    when "0001" =>      --irq_mask
                        irq_mask_reg <= misc_port.dat_i(7 downto 0);
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                        misc_port.err <= '0';
                    when "0010" =>      --irq_status
                        misc_port.err <= '1';
                    when "0011" =>      --gpio0
                        gpio0_reg    <= misc_port.dat_i;  
                        misc_port.stall <= '0';                                            
                        misc_port.ack <= '1';
                        misc_port.err <= '0';
                    when "0101" =>      --gpioA 
                        misc_port.stall <= '0';                                              
                        misc_port.ack <= '1';
                        misc_port.err <= '0';
                    when "0110" =>      --counter
                        misc_port.err <= '1';
                    when others =>
                        misc_port.err <= '1';
                    end case;    
                end if;
            else
                --misc_port.dat_o <= (others => '0');
                --misc_port.dat_o <= mem_port.dat_o;
                misc_port.stall <= '0';                       
                misc_port.ack <= '0';
                misc_port.err <= '0';
            end if;
        end if;
    end process;

end; --architecture logic
