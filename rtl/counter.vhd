library ieee;
    use ieee.std_logic_1164.all;

entity ir_control is
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    rld_i   : in std_logic_vector(31 downto 0);
    dir_i   : in std_logic;
    cnt_o   : out std_logic_vector(31 downto 0);

    irq_o   : out std_logic
);
end;

architecture behavior of ir_channel is
    signal cnt_s : integer;
    signal rld_s : integer;
begin
    irq_o <= '1' when (dir_i = '0' and cnt_s = rld_s) or (dir_i = '1' and cnt_s = 0) else '0';

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
        else
            if rising_edge(clk_i) then
                rld_s <= to_integer(unsigned(rld_i));

                if dir_i = '0' then -- count up
                    if cnt_s = rld_s then
                        cnt_s <= 0;
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
    end process;
end behavior;