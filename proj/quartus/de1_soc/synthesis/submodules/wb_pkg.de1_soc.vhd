library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

package wb_pkg is 
    constant addr_w : natural := 32;
    constant data_w : natural := 32;
    constant sel_w : natural := addr_w / 8;
    constant masters : natural := 2;
    constant slaves : natural := 17;

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
        dat_i   : data_t;
        dat_o   : std_logic_vector(master_ports_data_range);

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
end package wb_pkg;

package body wb_pkg is
end package body;