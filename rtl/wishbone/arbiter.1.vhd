-- plasma system bus
-- @author Sergej Zuyev

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;


library zz_systems;
    use zz_systems.wb_pkg.all;
    use zz_systems.util_pkg.all;

entity arbiter is
    generic
    (
        constant channels : natural := 1
    );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;

        request_i       : in std_logic_vector(channels - 1 downto 0);
        ack_i           : in std_logic_vector(channels - 1 downto 0);

        grant_o         : out std_logic_vector(channels - 1 downto 0);
        grant_enc_o     : out std_logic_vector(bit_width(channels) downto 0);
        grant_valid_o   : out std_logic
    );
end arbiter;

architecture behavior of arbiter is
    signal mask, mask_s         : std_logic_vector(channels - 1 downto 0) := (0 => '1', others => '0');    
    signal grant, grant_s       : std_logic_vector(channels - 1 downto 0);
    signal grant_enc            : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
begin
    grant_o         <= grant;
    grant_enc_o     <= grant_enc;
    grant_valid_o   <= or_reduce(grant);

    process(clk_i, rst_i)
        variable grant_enc_v : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
    begin
        if rst_i = '1' then
            mask        <= (0 => '1', others => '0');
            mask_s      <= (0 => '1', others => '0');
            grant       <= (others => '0');
            grant_s     <= (others => '0');
            grant_enc   <= (others => '0');
        else
            if rising_edge(clk_i) then
                grant_enc_v := (others => '0');

                mask    <= mask_s;
                grant   <= grant_s;

                if unsigned(grant and ack_i) /= 0 then
                    mask_s  <= mask(channels - 2 downto 0) & mask(channels - 1);                    
                end if;

                grant_s <= request_i and mask;
                
                for i in grant'range loop
                    if grant(i) = '1' then
                        grant_enc_v := grant_enc_v or std_logic_vector(to_unsigned(i, grant_enc_v'length));
                    end if;
                end loop;

                grant_enc <= grant_enc_v;
            end if;
        end if;
    end process;
end;
