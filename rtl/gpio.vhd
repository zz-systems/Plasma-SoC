library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

entity gpio is
port
(
    clk_i   : in std_logic;
    rst_i   : in std_logic;

    we_i    : in std_logic;

    mask_i  : in std_logic_vector(31 downto 0);
    dat_i   : in std_logic_vector(31 downto 0);
    dat_o   : out std_logic_vector(31 downto 0);

    gpio_i  : in std_logic_vector(31 downto 0);
    gpio_o  : out std_logic_vector(31 downto 0);

    irq_o   : out std_logic
);
end;

architecture behavior of gpio is
    signal mask_s : std_logic_vector(mask_i'range);
begin
    irq_o <= or_reduce(gpio_i and not mask_s);

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            dat_o   <= (others => '0');
            mask_s  <= (others => '0');
        else
            if rising_edge(clk_i) then
                mask_s <= mask_i;
                dat_o <= gpio_i;

                if we_i = '1' then
                    gpio_o <= dat_i;
                end if;
            end if;
        end if;
    end process;
end behavior;