library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    
library plasma_lib;
    use plasma_lib.mlite_pack.all;

entity slave_memory is 
generic
(
    constant memory_type : string := "XILINX_16X";
    constant access_delay : natural := 0
);
port
(
    clk_i : in std_logic;
    rst_i : in std_logic;

    cyc_i : in std_logic;
    stb_i : in std_logic;
    we_i   : in std_logic;

    adr_i : in std_logic_vector(31 downto 0);
    dat_i : in std_logic_vector(31 downto 0);

    sel_i : in std_logic_vector(3 downto 0);

    dat_o : out  std_logic_vector(31 downto 0);
    ack_o : out std_logic;
    rty_o : out std_logic;
    stall_o : out std_logic;
    err_o : out std_logic
);
end slave_memory;

architecture behavior of slave_memory is 
    signal dat_os : std_logic_vector(31 downto 0) := (others => '0');
    signal delay_reg : std_logic_vector(access_delay downto 0);
    alias delay_done : std_logic is delay_reg(access_delay);
    signal enable_s : std_logic := '0';
begin
    stall_o <= '0';
    err_o   <= '0';
    rty_o   <= '0';
    --ack_o   <= ack_os;

    GEN_IMMEDIATE:
    if access_delay = 0 generate
        proc_immediate: process(clk_i, rst_i) is
        begin         
            if rst_i = '1' then   
                ack_o <= '0';
            elsif rising_edge(clk_i) then
                ack_o <= stb_i;
            end if;
        end process;

        enable_s    <= stb_i;
        dat_o       <= dat_os;
    end generate;  

    GEN_DELAY:
    if access_delay /= 0 generate
        proc_delay: process(clk_i, rst_i) is 
        begin
            if rst_i = '1' then
                enable_s    <= '0';
                ack_o       <= '0';
                dat_o       <= (others => '0');
            elsif rising_edge(clk_i) then
                if stb_i = '1' then
                    enable_s    <= '1';
                    ack_o       <= '0';
                    dat_o       <= (others => '0');
                    delay_reg   <= (0 => '1', others => '0');
                elsif cyc_i = '1' then
                    if delay_done = '1' or access_delay = 0 then
                        enable_s    <= '0';
                        ack_o       <= '1';
                        dat_o       <= dat_os;
                    else
                        delay_reg   <= delay_reg(access_delay - 1 downto 0) & '0';
                    end if;
                else 
                    enable_s    <= '0';
                    ack_o       <= '0';
                    dat_o       <= (others => '0');
                    delay_reg   <= (0 => '1', others => '0');
                end if;
            end if;
        end process;
    end generate;    

    ram: entity plasma_lib.ram
    generic map (memory_type => memory_type)
    port map 
    (
        clk               => clk_i,
        enable            => enable_s,
        write_byte_enable => sel_i and (sel_i'range => we_i),
        address           => adr_i(31 downto 2),
        data_write        => dat_i,
        data_read         => dat_os
    );

end behavior;