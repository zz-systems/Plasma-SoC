library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;   
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
    signal cnt_s : integer := 0;
    signal rld_s : integer := 0;
begin
    irq_o <= '1' when en_i = '1' and ((dir_i = '0' and cnt_s = rld_s - 1) or (dir_i = '1' and cnt_s = 0)) else '0';
    cnt_o <= std_logic_vector(to_unsigned(cnt_s, cnt_o'length));

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            cnt_s <= 0;
        else
            if rising_edge(clk_i) then
                rld_s <= to_integer(unsigned(rld_i));

                if en_i = '1' then 
                    if dir_i = '0' then -- count up
                        if cnt_s >= rld_s - 1 then
                            cnt_s <= 0;
                        else
                            cnt_s <= cnt_s + 1;
                        end if;
                    else                -- count down
                        if cnt_s <= 1 then
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