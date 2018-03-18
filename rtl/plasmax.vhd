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
    use ieee.std_logic_misc.all;

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
    constant masters    : positive := 1;
    constant slaves     : positive := 6;
  
    signal master_select    : std_logic_vector(bit_width(masters) downto 0);    
    signal slave_select     : std_logic_vector(bit_width(slaves) downto 0);

    signal master_ports : wb_master_ports;
    signal slave_ports  : wb_slave_ports;


    type ports is array(natural range<>) of wb_port;
    signal m_ports : ports(masters - 1 downto 0);
    signal s_ports : ports(slaves - 1 downto 0);
     
    alias cpu_port      : wb_port is m_ports(0);
    alias mem_port      : wb_port is s_ports(0);
    alias ext_mem_port  : wb_port is s_ports(1);
    alias irc_port      : wb_port is s_ports(2);
    alias uart_port     : wb_port is s_ports(3);
    alias counter0_port : wb_port is s_ports(4);
    alias gpio0_port    : wb_port is s_ports(5);

    signal irq          : std_logic;
    signal irq_inputs   : std_logic_vector(31 downto 0);

    signal irq_uart      : std_logic;
    signal irq_gpio0      : std_logic;
    signal irq_counter0  : std_logic;
begin  --architecture

-- INTERRUPTS ------------------------------------------------------------------
    irq_inputs <= ZERO(31 downto 4)
                & irq_gpio0
                & irq_counter0
                & not uart_port.stall   -- uart write available
                & irq_uart;             -- uart read available
-- BUS SYSTEM ------------------------------------------------------------------
    -- connect wishbone masters to aggregated ports 
    master_con: for i in 0 to masters - 1 generate
        master_ports.cyc(i)     <= m_ports(i).cyc;
        master_ports.stb(i)     <= m_ports(i).stb;

        master_ports.adr((i + 1) * addr_w - 1 downto i * addr_w)       
                                <= m_ports(i).adr;

        master_ports.we(i)      <= m_ports(i).we;
        m_ports(i).dat_i        <= master_ports.dat_i((i + 1) * data_w - 1 downto i * data_w);

        master_ports.sel((i + 1) * sel_w - 1 downto i * sel_w)          
                                <= m_ports(i).sel;

        master_ports.dat_o      <= m_ports(i).dat_o;

        m_ports(i).ack          <= master_ports.ack;
        m_ports(i).stall        <= master_ports.stall;
        m_ports(i).err          <= master_ports.err;   
        m_ports(i).rty          <= master_ports.rty;
    end generate;    

    -- connect wishbone slaves to aggregated ports 
    slave_con: for i in 0 to slaves - 1 generate
        s_ports(i).cyc          <= slave_ports.cyc(i);
        s_ports(i).stb          <= slave_ports.stb(i);

        s_ports(i).adr          <= slave_ports.adr;

        s_ports(i).we           <= slave_ports.we;
        s_ports(i).dat_i        <= slave_ports.dat_i;

        s_ports(i).sel          <= slave_ports.sel;

        slave_ports.dat_o((i + 1) * data_w - 1 downto i * data_w)
                                <= s_ports(i).dat_o;

        slave_ports.ack(i)      <= s_ports(i).ack;
        slave_ports.stall(i)    <= s_ports(i).stall;
        slave_ports.err(i)      <= s_ports(i).err;   
        slave_ports.rty(i)      <= s_ports(i).rty;
    end generate;

    -- bus arbiter
    arbiter : entity plasmax_lib.arbiter
    generic map(
        channel_descriptors => ( 0 => 16#1# )
    )
    port map(
        clk_i => clk,
        rst_i => reset,
        
        interruptible_i => (others => '1'),

        busy_i => or_reduce(master_ports.cyc),

        cs_o => master_select
    );

    -- system bus
    system_bus : entity plasmax_lib.shared_bus
    generic map (
        masters => masters,
        slaves => slaves,

        memmap => 
        (
            ( x"00000000", x"0FFFFFFF" ),  -- internal memory
            ( x"10000000", x"001FFFFF" ),  -- external memory                 
            ( x"20000000", x"0FFFF0FF" ),  -- irc       
            ( x"20000100", x"0FFFF0FF" ),  -- uart
            ( x"20000200", x"0FFFF0FF" ),  -- counter
            ( x"20000300", x"0FFFF0FF" )   -- gpio0
        )
    )
    port map
    (
        clk_i => clk,
        rst_i => reset,

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

-- COMPONENTS ------------------------------------------------------------------

    u_cpu : entity plasmax_lib.master_cpu
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        irq_i   => irq,

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

    u_irc : entity plasmax_lib.slave_irc
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        ir_i    => irq_inputs,
        irq_o   => irq,

        cyc_i   => irc_port.cyc,
        stb_i   => irc_port.stb,
        we_i    => irc_port.we,

        adr_i   => irc_port.adr,
        dat_i   => irc_port.dat_i,

        sel_i   => irc_port.sel,

        dat_o   => irc_port.dat_o,
        ack_o   => irc_port.ack,
        rty_o   => irc_port.rty,
        stall_o => irc_port.stall,
        err_o   => irc_port.err
    );

    u_ram: entity plasmax_lib.slave_memory
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        cyc_i   => mem_port.cyc,
        stb_i   => mem_port.stb,
        we_i    => mem_port.we,

        adr_i   => mem_port.adr,
        dat_i   => mem_port.dat_i,

        sel_i   => mem_port.sel,

        dat_o   => mem_port.dat_o,
        ack_o   => mem_port.ack,
        rty_o   => mem_port.rty,
        stall_o => mem_port.stall,
        err_o   => mem_port.err
    );

    u_ext_mem: entity plasmax_lib.slave_ext_memory
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        address             => address,
        data_write          => data_write,
        data_read           => data_read,
        write_byte_enable   => write_byte_enable,

        cyc_i   => ext_mem_port.cyc,
        stb_i   => ext_mem_port.stb,
        we_i    => ext_mem_port.we,

        adr_i   => ext_mem_port.adr,
        dat_i   => ext_mem_port.dat_i,

        sel_i   => ext_mem_port.sel,

        dat_o   => ext_mem_port.dat_o,
        ack_o   => ext_mem_port.ack,
        rty_o   => ext_mem_port.rty,
        stall_o => ext_mem_port.stall,
        err_o   => ext_mem_port.err
    );

    u_uart: entity plasmax_lib.slave_uart
    generic map 
    (
        log_file => log_file
    )
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        tx      => uart_write,
        rx      => uart_read,
        irq     => irq_uart,

        cyc_i   => uart_port.cyc,
        stb_i   => uart_port.stb,
        we_i    => uart_port.we,

        adr_i   => uart_port.adr,
        dat_i   => uart_port.dat_i,

        sel_i   => uart_port.sel,

        dat_o   => uart_port.dat_o,
        ack_o   => uart_port.ack,
        rty_o   => uart_port.rty,
        stall_o => uart_port.stall,
        err_o   => uart_port.err
    );

    u_counter: entity plasmax_lib.slave_counter 
    port map
    (
        clk_i   => clk,
        rst_i   => reset,
        
        irq_o   => irq_counter0,

        cyc_i   => counter0_port.cyc,
        stb_i   => counter0_port.stb,
        we_i    => counter0_port.we,

        adr_i   => counter0_port.adr,
        dat_i   => counter0_port.dat_i,

        sel_i   => counter0_port.sel,

        dat_o   => counter0_port.dat_o,
        ack_o   => counter0_port.ack,
        rty_o   => counter0_port.rty,
        stall_o => counter0_port.stall,
        err_o   => counter0_port.err
    );

    u_gpio0: entity plasmax_lib.slave_gpio 
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        gpio_i  => gpioA_in,
        gpio_o  => gpio0_out,
        irq_o   => irq_gpio0,

        cyc_i   => gpio0_port.cyc,
        stb_i   => gpio0_port.stb,
        we_i    => gpio0_port.we,

        adr_i   => gpio0_port.adr,
        dat_i   => gpio0_port.dat_i,

        sel_i   => gpio0_port.sel,

        dat_o   => gpio0_port.dat_o,
        ack_o   => gpio0_port.ack,
        rty_o   => gpio0_port.rty,
        stall_o => gpio0_port.stall,
        err_o   => gpio0_port.err
    );

end; --architecture logic
