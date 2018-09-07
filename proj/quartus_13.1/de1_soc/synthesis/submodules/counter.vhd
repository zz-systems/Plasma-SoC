library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- set reload
-- set direction
-- reset
-- enable  
entity counter is
generic 
(
    constant data_w : positive := 32
);
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    en_i    : in std_logic;
    rld_i   : in std_logic_vector(data_w - 1 downto 0);
    dir_i   : in std_logic;
    cnt_o   : out std_logic_vector(data_w - 1 downto 0);

    irq_o   : out std_logic
);
end;

architecture behavior of counter is
    constant zero   : unsigned(cnt_o'range) := (others => '0');
    signal cnt_s    : unsigned(cnt_o'range) := (others => '0');
    signal rld_s    : unsigned(rld_i'range) := (others => '0');
begin
    irq_o <= '1' when (dir_i = '0' and cnt_s = rld_s and rld_s /= 0) else
             '1' when (dir_i = '1' and cnt_s = 0) else 
             '0';

    cnt_o <= std_logic_vector(cnt_s);

    process(clk_i, rst_i, en_i)
    begin
        if rst_i = '1' then
            if dir_i = '0' then
                cnt_s <= zero;
            else
                cnt_s <= rld_s;
            end if;
        else
            if rising_edge(clk_i) then
                rld_s <= unsigned(rld_i) - 1;

                if en_i = '1' then 
                    if dir_i = '0' then -- count up
                        if cnt_s = rld_s and rld_s /= 0 then
                            cnt_s <= zero;
                        else
                            cnt_s <= cnt_s + 1;
                        end if;
                    else                -- count down
                        if cnt_s = 0 then
                            cnt_s <= rld_s;
                        else
                            cnt_s <= cnt_s - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end behavior;