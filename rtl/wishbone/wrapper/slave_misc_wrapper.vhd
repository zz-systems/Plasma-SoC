library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

library plasma_lib;
    use plasma_lib.mlite_pack.all;

library plasmax_lib;
    use plasmax_lib.wb_pkg.all;
    use plasmax_lib.util_pkg.all;


entity slave_misc is 
    port
    (
        clk_i : in std_logic;
        rst_i : in std_logic;


        cyc_i : in std_logic;
        stb_i : in std_logic;
        we_i  : in std_logic;

        adr_i : in std_logic_vector(31 downto 0);
        dat_i : in std_logic_vector(31 downto 0);

        sel_i : in std_logic_vector(3 downto 0);


        dat_o : out  std_logic_vector(31 downto 0);
        ack_o : out std_logic;
        stall_o :out std_logic;
        err_o : out std_logic
    );
end slave_misc;

architecture behavior of slave_misc is 
    signal cyc_s, stb_s : std_logic;
    signal misc_port : wb_port;
    signal gpio0_reg : std_logic_vector(31 downto 0);
    signal gpioA_in : std_logic_vector(31 downto 0);

    signal data_read_uart        : std_logic_vector(7 downto 0);
    signal irq_mask_reg        : std_logic_vector(7 downto 0);
    signal irq_status_raw        : std_logic_vector(7 downto 0);
    signal uart_write_busy : std_logic;
    signal counter_reg         : std_logic_vector(31 downto 0);
begin
    process(clk_i)
    begin 
        if rst_i = '1' then
            irq_mask_reg           <= ZERO(7 downto 0);
            gpio0_reg              <= ZERO;
            counter_reg            <= ZERO;
        
            misc_port.dat_o        <= (others => '0');
            misc_port.stall <= '0';                       
            misc_port.ack <= '0';
        elsif rising_edge(clk_i) then
            counter_reg <= bv_inc(counter_reg);
            
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
                        misc_port.dat_o <= ZERO(31 downto 8) & irq_status_raw;
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
                else 
                    case misc_port.adr(7 downto 4) is
                    when "0000" =>      --uart
                        misc_port.stall <= uart_write_busy;
                        misc_port.ack <= not uart_write_busy;
                    when "0001" =>      --irq_mask
                        irq_mask_reg <= misc_port.dat_i(7 downto 0);
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0010" =>      --irq_status
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    when "0011" =>      --gpio0
                        gpio0_reg    <= misc_port.dat_i;  
                        misc_port.stall <= '0';                                            
                        misc_port.ack <= '1';
                    when "0101" =>      --gpioA 
                        misc_port.stall <= '0';                                              
                        misc_port.ack <= '1';
                    when "0110" =>      --counter
                        misc_port.stall <= '0';
                        misc_port.ack <= '1';
                    when others =>
                        misc_port.stall <= '0';                       
                        misc_port.ack <= '1';
                    end case;    
                end if;
            else
                misc_port.dat_o <= (others => '0');
                misc_port.stall <= '0';                       
                misc_port.ack <= '0';
            end if;
        end if;
    end process;
    
    misc_port.cyc <= cyc_i;
    misc_port.stb <= stb_i;

    misc_port.we <= we_i ;

    misc_port.adr <= adr_i;
    misc_port.dat_i <= dat_i;

    misc_port.sel <= sel_i;

    dat_o <= misc_port.dat_o;
    ack_o <= misc_port.ack;
    stall_o <= misc_port.stall;
    err_o <= misc_port.err;
end behavior;