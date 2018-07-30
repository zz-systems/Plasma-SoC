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
    
library zz_systems;
    use zz_systems.wb_pkg.all;
    use zz_systems.avalon_pkg.all;
    use zz_systems.util_pkg.all;

entity plasma_soc is
    generic
    (
        memory_type : string := "ALTERA_LPM";   
        log_file    : string := "UNUSED";

        constant spi_slaves : positive := 1;
        constant sys_clk    : positive := 50000000;
        constant spi_clk    : positive := 1000000
    );
    port
    (
        clk               : in std_logic;
        reset             : in std_logic;

        uart_write        : out std_logic;
        uart_read         : in std_logic;        

        gpio_o            : out std_logic_vector(127 downto 0);
        gpio_i            : in std_logic_vector(127 downto 0);

        -- SPI
        MOSI              : out std_logic;
        MISO              : in std_logic;
        SCLK              : out std_logic;
        CS                : out std_logic_vector(spi_slaves - 1 downto 0);

        -- avalon slave interface
        avs_address           : in std_logic_vector(31 downto 0);
        avs_byteenable        : in std_logic_vector(3 downto 0);
        avs_write_n           : in std_logic;
        avs_read_n            : in std_logic;
        avs_readdata          : out std_logic_vector(31 downto 0);
        avs_writedata         : in std_logic_vector(31 downto 0);
        avs_waitrequest       : out std_logic; 
        avs_response          : out std_logic_vector(1 downto 0);

        -- avalon master interface
        avm_address           : out std_logic_vector(31 downto 0);
        avm_byteenable        : out std_logic_vector(3 downto 0);
        avm_write_n           : out std_logic;
        avm_read_n            : out std_logic;
        avm_readdata          : in std_logic_vector(31 downto 0);
        avm_writedata         : out std_logic_vector(31 downto 0);
        avm_waitrequest       : in std_logic; 
        avm_response          : in std_logic_vector(1 downto 0)
    );
end; --entity plasma

architecture logic of plasma_soc is
    constant masters    : positive := 2;
    constant slaves     : positive := 17;
  
    signal master_select    : std_logic_vector(bit_width(masters) downto 0);    
    signal slave_select     : std_logic_vector(bit_width(slaves) downto 0);

    signal master_ports_aggregate : wb_master_ports;
    signal slave_ports_aggregate  : wb_slave_ports;


    type ports is array(natural range<>) of wb_port;
    signal master_ports : ports(masters - 1 downto 0);
    signal slave_ports : ports(slaves - 1 downto 0);
     
    alias cpu_port      : wb_port is master_ports(0);

    alias avalon_slave2wb_master_port   
                        : wb_port is master_ports(1);

    alias mem_port      : wb_port is slave_ports(0);
    alias irc_port      : wb_port is slave_ports(1);
    alias uart_port     : wb_port is slave_ports(2);
    alias timer_ports   : ports(3 downto 0) is slave_ports(6 downto 3);
    alias counter_ports : ports(3 downto 0) is slave_ports(10 downto 7);
    alias gpio_ports    : ports(3 downto 0) is slave_ports(14 downto 11);
    alias spic_port     : wb_port is slave_ports(15);

    alias avalon_master2wb_slave_port
                        : wb_port is slave_ports(16);

    signal irq          : std_logic;
    signal irq_inputs   : std_logic_vector(31 downto 0);

    signal irq_uart      : std_logic;
    signal irq_gpios     : std_logic_vector(3 downto 0);
    signal irq_counters  : std_logic_vector(3 downto 0);
    signal irq_timers    : std_logic_vector(3 downto 0);
begin  --architecture

-- INTERRUPTS ------------------------------------------------------------------
    irq_inputs <= cpu_port.err          -- access violation
                & ZERO(30 downto 14)
                & irq_gpios
                & irq_counters
                & irq_timers & "00";
                --& not uart_port.stall   -- uart write available
                --& irq_uart;             -- uart read available
-- BUS SYSTEM ------------------------------------------------------------------
    -- connect wishbone masters to aggregated ports 
    master_con: for i in 0 to masters - 1 generate
        master_ports_aggregate.cyc(i)   <= master_ports(i).cyc;
        master_ports_aggregate.stb(i)   <= master_ports(i).stb;

        master_ports_aggregate.adr((i + 1) * addr_w - 1 downto i * addr_w)       
                                        <= master_ports(i).adr;

        master_ports_aggregate.we(i)    <= master_ports(i).we;
        master_ports(i).dat_i           <= master_ports_aggregate.dat_i;

        master_ports_aggregate.sel((i + 1) * sel_w - 1 downto i * sel_w)          
                                        <= master_ports(i).sel;

        master_ports_aggregate.dat_o((i + 1) * data_w - 1 downto i * data_w)
                                        <= master_ports(i).dat_o;

        master_ports(i).ack             <= master_ports_aggregate.ack;
        master_ports(i).stall           <= master_ports_aggregate.stall;
        master_ports(i).err             <= master_ports_aggregate.err;   
        master_ports(i).rty             <= master_ports_aggregate.rty;
    end generate;    

    -- connect wishbone slaves to aggregated ports 
    slave_con: for i in 0 to slaves - 1 generate
        slave_ports(i).cyc              <= slave_ports_aggregate.cyc(i);
        slave_ports(i).stb              <= slave_ports_aggregate.stb(i);

        slave_ports(i).adr              <= slave_ports_aggregate.adr;

        slave_ports(i).we               <= slave_ports_aggregate.we;
        slave_ports(i).dat_i            <= slave_ports_aggregate.dat_i;

        slave_ports(i).sel              <= slave_ports_aggregate.sel;

        slave_ports_aggregate.dat_o((i + 1) * data_w - 1 downto i * data_w)
                                        <= slave_ports(i).dat_o;

        slave_ports_aggregate.ack(i)    <= slave_ports(i).ack;
        slave_ports_aggregate.stall(i)  <= slave_ports(i).stall;
        slave_ports_aggregate.err(i)    <= slave_ports(i).err;   
        slave_ports_aggregate.rty(i)    <= slave_ports(i).rty;
    end generate;

    -- bus arbiter
    arbiter : entity zz_systems.arbiter
    generic map
    (
        channel_descriptors => ( 0 => 16#1#, 1 => 16#1# ),
        channels => 2
    )
    port map(
        clk_i => clk,
        rst_i => reset,
        
        interruptible_i => (others => '1'),

        busy_i => or_reduce(master_ports_aggregate.cyc),

        cs_o => master_select
    );

    -- system bus
    system_bus : entity zz_systems.shared_bus
    generic map (
        masters => masters,
        slaves => slaves,

        memmap => 
        (
            ( x"00000000", x"00004FFF" ),  -- internal memory             
            ( x"00005000", x"0000001F" ),  -- irc       
            ( x"00005100", x"0000000F" ),  -- uart

            -- timers ----------------------------------------------------------
            ( x"00005200", x"0000000F" ),  -- timer0
            ( x"00005210", x"0000000F" ),  -- timer1
            ( x"00005220", x"0000000F" ),  -- timer2
            ( x"00005230", x"0000000F" ),  -- timer3

            -- counters --------------------------------------------------------
            ( x"00005300", x"0000000F" ),  -- counter0
            ( x"00005310", x"0000000F" ),  -- counter1
            ( x"00005320", x"0000000F" ),  -- counter2
            ( x"00005330", x"0000000F" ),  -- counter3
           
            -- gpios -----------------------------------------------------------
            ( x"00005400", x"0000000F" ),  -- gpio0
            ( x"00005410", x"0000000F" ),  -- gpio1
            ( x"00005420", x"0000000F" ),  -- gpio2
            ( x"00005430", x"0000000F" ),  -- gpio3

            ( x"00005500", x"0000000F" ),  -- spic

            -- avalon ----------------------------------------------------------
            ( x"10000000", x"0FFFFFFF" )   -- avalon slaves    
        )
    )
    port map
    (
        clk_i => clk,
        rst_i => reset,

        -- arbiter interface 
        master_gnt_i => "00",--master_select,

        -- master interface
        master_cyc_i    => master_ports_aggregate.cyc,
        master_stb_i    => master_ports_aggregate.stb,

        master_adr_i    => master_ports_aggregate.adr,
        master_we_i     => master_ports_aggregate.we,
        master_dat_i    => master_ports_aggregate.dat_o,
        master_sel_i    => master_ports_aggregate.sel,

        master_dat_o    => master_ports_aggregate.dat_i,

        master_ack_o    => master_ports_aggregate.ack,
        master_stall_o  => master_ports_aggregate.stall,
        master_err_o    => master_ports_aggregate.err,
        master_rty_o    => master_ports_aggregate.rty,

        -- slave interface
        slave_cyc_o     => slave_ports_aggregate.cyc,
        slave_stb_o     => slave_ports_aggregate.stb,

        slave_adr_o     => slave_ports_aggregate.adr,
        slave_we_o      => slave_ports_aggregate.we,
        slave_dat_o     => slave_ports_aggregate.dat_i,
        slave_sel_o     => slave_ports_aggregate.sel,

        slave_dat_i     => slave_ports_aggregate.dat_o,

        slave_ack_i     => slave_ports_aggregate.ack,
        slave_stall_i   => slave_ports_aggregate.stall,
        slave_err_i     => slave_ports_aggregate.err,
        slave_rty_i     => slave_ports_aggregate.rty
    );  

-- COMPONENTS ------------------------------------------------------------------

    u_cpu : entity zz_systems.master_cpu
    generic map
	(
		memory_type => "DUAL_PORT_X"
	)
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
    
    u_avalon_slave2wb_master: entity zz_systems.avalon_slave2wb_master
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        address           => avs_address,
        byteenable        => avs_byteenable,
        write_n           => avs_write_n,
        read_n            => avs_read_n,
        readdata          => avs_readdata,
        writedata         => avs_writedata,
        waitrequest       => avs_waitrequest,
        response          => avs_response,

        cyc_o   => avalon_slave2wb_master_port.cyc,
        stb_o   => avalon_slave2wb_master_port.stb,
        we_o    => avalon_slave2wb_master_port.we,

        adr_o   => avalon_slave2wb_master_port.adr,
        dat_o   => avalon_slave2wb_master_port.dat_o,

        sel_o   => avalon_slave2wb_master_port.sel,

        dat_i   => avalon_slave2wb_master_port.dat_i,
        ack_i   => avalon_slave2wb_master_port.ack,
        rty_i   => avalon_slave2wb_master_port.rty,
        stall_i => avalon_slave2wb_master_port.stall,
        err_i   => avalon_slave2wb_master_port.err
    );

    u_avalon_master2wb_slave: entity zz_systems.avalon_master2wb_slave
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        address           => avm_address,
        byteenable        => avm_byteenable,
        write_n           => avm_write_n,
        read_n            => avm_read_n,
        readdata          => avm_readdata,
        writedata         => avm_writedata,
        waitrequest       => avm_waitrequest,
        response          => avm_response,

        cyc_i   => avalon_master2wb_slave_port.cyc,
        stb_i   => avalon_master2wb_slave_port.stb,
        we_i    => avalon_master2wb_slave_port.we,

        adr_i   => avalon_master2wb_slave_port.adr,
        dat_i   => avalon_master2wb_slave_port.dat_i,

        sel_i   => avalon_master2wb_slave_port.sel,

        dat_o   => avalon_master2wb_slave_port.dat_o,
        ack_o   => avalon_master2wb_slave_port.ack,
        rty_o   => avalon_master2wb_slave_port.rty,
        stall_o => avalon_master2wb_slave_port.stall,
        err_o   => avalon_master2wb_slave_port.err
    );

    u_irc : entity zz_systems.slave_irc
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

    u_ram: entity zz_systems.slave_memory
    generic map
    (
        memory_type => memory_type
    )
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

    u_uart: entity zz_systems.slave_uart
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
        irq_o   => irq_uart,

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

    gen_timer: for i in 0 to 3 generate
        u_timer: entity zz_systems.slave_timer
        port map
        (
            clk_i   => clk,
            rst_i   => reset,
            
            irq_o   => irq_timers(i),

            cyc_i   => timer_ports(i).cyc,
            stb_i   => timer_ports(i).stb,
            we_i    => timer_ports(i).we,

            adr_i   => timer_ports(i).adr,
            dat_i   => timer_ports(i).dat_i,

            sel_i   => timer_ports(i).sel,

            dat_o   => timer_ports(i).dat_o,
            ack_o   => timer_ports(i).ack,
            rty_o   => timer_ports(i).rty,
            stall_o => timer_ports(i).stall,
            err_o   => timer_ports(i).err
        );
    end generate;

    gen_counter: for i in 0 to 3 generate
        u_counter: entity zz_systems.slave_counter 
        port map
        (
            clk_i   => clk,
            rst_i   => reset,
            
            irq_o   => irq_counters(i),

            cyc_i   => counter_ports(i).cyc,
            stb_i   => counter_ports(i).stb,
            we_i    => counter_ports(i).we,

            adr_i   => counter_ports(i).adr,
            dat_i   => counter_ports(i).dat_i,

            sel_i   => counter_ports(i).sel,

            dat_o   => counter_ports(i).dat_o,
            ack_o   => counter_ports(i).ack,
            rty_o   => counter_ports(i).rty,
            stall_o => counter_ports(i).stall,
            err_o   => counter_ports(i).err
        );
    end generate;

    gen_gpio: for i in 0 to 3 generate
        u_gpio: entity zz_systems.slave_gpio 
        port map
        (
            clk_i   => clk,
            rst_i   => reset,

            gpio_i  => gpio_i((i + 1) * 32 - 1 downto i * 32),
            gpio_o  => gpio_o((i + 1) * 32 - 1 downto i * 32),

            irq_o   => irq_gpios(i),

            cyc_i   => gpio_ports(i).cyc,
            stb_i   => gpio_ports(i).stb,
            we_i    => gpio_ports(i).we,

            adr_i   => gpio_ports(i).adr,
            dat_i   => gpio_ports(i).dat_i,

            sel_i   => gpio_ports(i).sel,

            dat_o   => gpio_ports(i).dat_o,
            ack_o   => gpio_ports(i).ack,
            rty_o   => gpio_ports(i).rty,
            stall_o => gpio_ports(i).stall,
            err_o   => gpio_ports(i).err
        );
    end generate;

    u_spic: entity zz_systems.slave_spic 
    generic map
    (
        slaves      => spi_slaves,
        data_w      => 8,
        sys_clk     => sys_clk,
        spi_clk     => spi_clk
    )
    port map
    (
        clk_i   => clk,
        rst_i   => reset,

        MOSI    => MOSI,
        MISO    => MISO,
        SCLK    => SCLK,
        CS      => CS,

        cyc_i   => spic_port.cyc,
        stb_i   => spic_port.stb,
        we_i    => spic_port.we,

        adr_i   => spic_port.adr,
        dat_i   => spic_port.dat_i,

        sel_i   => spic_port.sel,

        dat_o   => spic_port.dat_o,
        ack_o   => spic_port.ack,
        rty_o   => spic_port.rty,
        stall_o => spic_port.stall,
        err_o   => spic_port.err
    );

end; --architecture logic
