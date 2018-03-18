library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

package wb_pkg is 
    constant addr_w : natural := 32;
    constant data_w : natural := 32;
    constant sel_w : natural := addr_w / 8;
    constant masters : natural := 1;
    constant slaves : natural := 7;

    type map_entry is record
        base_addr : std_logic_vector(31 downto 0);
        size : std_logic_vector(31 downto 0);
    end record;

    type memmap_t is array (natural range<>) of map_entry;

    type channel_descriptor is record 
        priority : natural;
    end record;

    type cdesc_t is array (natural range<>) of positive;

    subtype addr_t is std_logic_vector(addr_w - 1 downto 0);
    subtype data_t is std_logic_vector(data_w - 1 downto 0);

    type wb_port is record
        cyc     : std_logic;
        stb     : std_logic;

        adr     : addr_t;
        we      : std_logic;
        dat_i   : data_t;
        dat_o   : data_t;

        sel     : std_logic_vector(addr_w / 8 - 1 downto 0);

        ack     : std_logic;
        stall   : std_logic;
        err     : std_logic;
        rty     : std_logic;
    end record;

    type master_ports_t is array (masters - 1 downto 0) of wb_port;
    type slave_ports_t is array (slaves - 1 downto 0) of wb_port;

    subtype master_ports_chan_range is natural range masters - 1 downto 0;
    subtype master_ports_data_range is natural range masters * data_w - 1 downto 0;
    subtype master_ports_addr_range is natural range masters * addr_w - 1 downto 0;
    subtype master_ports_sel_range  is natural range masters * addr_w / 8 - 1 downto 0;

    subtype slave_ports_chan_range is natural range slaves - 1 downto 0;
    subtype slave_ports_data_range is natural range slaves * data_w - 1 downto 0;
    subtype slave_ports_addr_range is natural range slaves * addr_w - 1 downto 0;
    subtype slave_ports_sel_range  is natural range slaves * addr_w / 8 - 1 downto 0;

    type wb_master_ports is record
        cyc     : std_logic_vector(master_ports_chan_range);
        stb     : std_logic_vector(master_ports_chan_range);

        adr     : std_logic_vector(master_ports_addr_range);
        we      : std_logic_vector(master_ports_chan_range);
        dat_i   : std_logic_vector(master_ports_data_range);
        dat_o   : data_t;

        sel     : std_logic_vector(master_ports_sel_range);

        ack     : std_logic;
        stall   : std_logic;
        err     : std_logic;
        rty     : std_logic;
    end record;

    type wb_slave_ports is record
        cyc     : std_logic_vector(slave_ports_chan_range);
        stb     : std_logic_vector(slave_ports_chan_range);

        adr     : addr_t;
        we      : std_logic;
        dat_i   : data_t;
        dat_o   : std_logic_vector(slave_ports_data_range);

        sel     : std_logic_vector(addr_w / 8 - 1 downto 0);

        ack     : std_logic_vector(slave_ports_chan_range);
        stall   : std_logic_vector(slave_ports_chan_range);
        err     : std_logic_vector(slave_ports_chan_range);
        rty     : std_logic_vector(slave_ports_chan_range);
    end record;

    procedure wb_map_master_at(i : in natural; signal channel : inout wb_master_ports; signal master : inout wb_port);
    procedure wb_map_slave_at(i : in natural; signal channel : inout wb_slave_ports; signal slave : inout wb_port);

    procedure wb_map_master_to_channel(i : in natural; signal channel : out wb_master_ports; signal master : in wb_port);
    procedure wb_map_channel_to_master(i : in natural; signal channel : in wb_master_ports; signal master : out wb_port);

    procedure wb_map_slave_to_channel(i : in natural; signal channel : out wb_slave_ports; signal slave : in wb_port);
    procedure wb_map_channel_to_slave(i : in natural; signal channel : in wb_slave_ports; signal slave : out wb_port);
end package wb_pkg;

package body wb_pkg is

    procedure wb_map_master_at(i : in natural; signal channel : inout wb_master_ports; signal master : inout wb_port) is
    begin
        channel.cyc(i)              <= master.cyc;
        channel.stb(i)              <= master.stb;

        channel.adr((i + 1) * addr_w - 1 downto i * addr_w)      <= master.adr;
        channel.we(i)               <= master.we;
        channel.dat_o               <= master.dat_o;
        channel.sel((i + 1) * sel_w - 1  downto i * sel_w)      <= master.sel;

        master.dat_i                <= channel.dat_i((i + 1) * data_w - 1 downto i * data_w);

        master.ack                  <= channel.ack;
        master.stall                <= channel.stall;
        master.err                  <= channel.err;
        master.rty                  <= channel.rty;
    end procedure wb_map_master_at;

    procedure wb_map_slave_at(i : in natural; signal channel : inout wb_slave_ports; signal slave : inout wb_port) is
    begin
        slave.cyc                   <= channel.cyc(i);
        slave.stb                   <= channel.stb(i);

        slave.adr                   <= channel.adr;
        slave.we                    <= channel.we;
        slave.dat_o                 <= channel.dat_o((i + 1) * data_w - 1 downto i * data_w);
        slave.sel                   <= channel.sel;

        channel.dat_i               <= slave.dat_i;

        channel.ack(i)              <= slave.ack;
        channel.stall(i)            <= slave.stall;
        channel.err(i)              <= slave.err;
        channel.rty(i)              <= slave.rty;
    end procedure wb_map_slave_at;

    procedure wb_map_master_to_channel(i : in natural; signal channel : out wb_master_ports; signal master : in wb_port) is
    begin
        channel.cyc(i)              <= master.cyc;
        channel.stb(i)              <= master.stb;

        channel.adr((i + 1) * addr_w - 1 downto i * addr_w)      <= master.adr;
        channel.we(i)               <= master.we;
        channel.dat_o               <= master.dat_o;
        channel.sel((i + 1) * sel_w - 1  downto i * sel_w)      <= master.sel;
    end procedure wb_map_master_to_channel;

    procedure wb_map_slave_to_channel(i : in natural; signal channel : out wb_slave_ports; signal slave : in wb_port) is
    begin
        channel.dat_i               <= slave.dat_i;

        channel.ack(i)              <= slave.ack;
        channel.stall(i)            <= slave.stall;
        channel.err(i)              <= slave.err;
        channel.rty(i)              <= slave.rty;
    end procedure wb_map_slave_to_channel;

    procedure wb_map_channel_to_master(i : in natural; signal channel : in wb_master_ports; signal master : out wb_port) is
    begin
        master.dat_i                <= channel.dat_i((i + 1) * data_w - 1 downto i * data_w);

        master.ack                  <= channel.ack;
        master.stall                <= channel.stall;
        master.err                  <= channel.err;
        master.rty                  <= channel.rty;
    end procedure wb_map_channel_to_master;

    procedure wb_map_channel_to_slave(i : in natural; signal channel : in wb_slave_ports; signal slave : out wb_port) is
    begin
        slave.cyc                   <= channel.cyc(i);
        slave.stb                   <= channel.stb(i);

        slave.adr                   <= channel.adr;
        slave.we                    <= channel.we;
        slave.dat_o                 <= channel.dat_o((i + 1) * data_w - 1 downto i * data_w);
        slave.sel                   <= channel.sel;
    end procedure wb_map_channel_to_slave;
end package body;