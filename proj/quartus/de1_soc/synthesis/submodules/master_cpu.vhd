library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity master_cpu is 
generic
(
    constant memory_type : string := "XILINX_16X"
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    irq_i : in std_logic;
    grant_i : in std_logic;

    mem_pause_o : out std_logic;

    cyc_o : out std_logic;
    stb_o : out std_logic;
    we_o   : out std_logic;

    adr_o : out std_logic_vector(31 downto 0);
    dat_o : out std_logic_vector(31 downto 0);

    sel_o : out std_logic_vector(3 downto 0);


    dat_i : in  std_logic_vector(31 downto 0);
    ack_i : in std_logic;
    rty_i : in std_logic;
    stall_i : in std_logic;
    err_i : in std_logic
);
end master_cpu;

architecture behavior of master_cpu is 
    signal cyc_os : std_logic := '0';
    signal stb_os : std_logic := '0';

    signal adr_os : std_logic_vector(adr_o'range) := (others => '0');
    signal sel_os : std_logic_vector(sel_o'range) := (others => '0');

    signal dat_is : std_logic_vector(dat_i'range) := (others => '0');

    signal clk : std_logic := '0';
    signal stall_s : std_logic := '0';
begin
    -- clk_div : process(clk_i)
    -- begin
    --     if rising_edge(clk_b) then
    --         clk <= not clk;
    --     end if;
    -- end process;

    process(clk_i, rst_i)
    begin         
        if rst_i = '1' then 
            cyc_os <= '0';
            stb_os <= '0';
            dat_is <= (others => '0');
        elsif rising_edge(clk_i) then
            if (err_i  = '1' and cyc_os  = '1') then
                cyc_os <= '0';
                stb_os <= '0';
                --stall_s <= '0';
            elsif stb_os  = '1' and grant_i = '1' then
                if stall_i = '0' then
                    stb_os <= '0';
                end if;

                if stall_i = '0' and ack_i = '1' then
                    cyc_os <= '0';

                    dat_is <= dat_i;
                end if; 
            elsif cyc_os  = '1' and grant_i = '1' then
                if ack_i  = '1' then
                    cyc_os <= '0';

                    dat_is <= dat_i;
                end if;
            else 
                cyc_os <= '1';
                stb_os <= '1';
            end if;

            -- Plasma CPU sets the byte selector only for write-access
            -- Wishbone protocol relies on byte selector for both read and write operations
            -- Avalon relies on the byte selector for both read and write operations aswell.
            if sel_os /= (sel_os'range => '0') then
                we_o <= '1';
                sel_o <= sel_os;
            else 
                we_o <= '0';
                sel_o <= x"F"; -- Assume 4 byte transfer
            end if;
        end if;
    end process;

    -- stall_s <= cyc_o;
    -- process(clk)
    -- begin
    --     if rst_i = '1' then 
    --     elsif rising_edge(clk_i) then
    --         dat_is
    --     end if;
    -- end process;


    cyc_o <= cyc_os;
    stb_o <= stb_os;

    u1_cpu: mlite_cpu
    generic map (memory_type => memory_type)
    port map 
    (
        clk          => clk_i,
        reset_in     => rst_i,
        intr_in      => irq_i,

        mem_address  => adr_o,
        mem_data_w   => dat_o,
        mem_data_r   => dat_i,
        mem_byte_we  => sel_os,
        mem_pause    => cyc_os or stall_i
    );

    mem_pause_o <= stall_s;
end behavior;