-- -----------------------------------------------------------------------------
-- Copyright (c) 2009 Benjamin Krill <benjamin@krll.de>
-- Modified by Sergej Zuyev (2018)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the follograntg conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- -----------------------------------------------------------------------------

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
    signal grant_enc    : std_logic_vector(grant_enc_o'range)   := (others => '0');
	signal grant_q      : std_logic_vector(grant_o'range)       := (others => '0');
	signal grant_prev   : std_logic_vector(grant_o'range)       := (others => '0');
	signal grant_next   : std_logic_vector(grant_o'range)       := (others => '0');
	signal req_lsb      : std_logic_vector(grant_o'range)       := (others => '0');
	signal mask         : std_logic_vector(grant_o'range)       := (others => '0');
	signal grant        : std_logic_vector(grant_o'range)       := (others => '0');
begin
    grant_o         <= grant_q;
    grant_enc_o     <= grant_enc;
    grant_valid_o   <= or_reduce(grant_q);
    
    mask        <= request_i    and not (std_logic_vector(unsigned(grant_prev) - 1) or grant_prev);       -- Mask off previous grantners
    grant_next  <= mask         and      std_logic_vector(unsigned(not(mask)) + 1);                 -- Select new grantner
    req_lsb     <= request_i    and      std_logic_vector(unsigned(not(request_i)) + 1);            -- Isolate least significant set bit.
    grant       <= grant_next   when     unsigned(mask) /= 0 else req_lsb;

    process (clk_i, rst_i)
        variable grant_enc_v : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
    begin
    if rst_i = '1' then
        grant_prev <= (others => '0');
        grant_q <= (others => '0');
    elsif rising_edge(clk_i) then
        grant_q <= grant_q;
        grant_prev <= grant_prev;
        if unsigned(grant_q) = 0 or or_reduce(ack_i) = '1' then
            if unsigned(grant) /= 0 then
                grant_prev <= grant;
            end if;
            grant_q <= grant;
            
            grant_enc_v := (others => '0');

            for i in channels - 1 downto 0 loop
                if grant(i) = '1' then
                    grant_enc_v := grant_enc_v or std_logic_vector(to_unsigned(i, grant_enc_v'length));
                end if;
            end loop;
            

            grant_enc <= grant_enc_v;
        end if;
    end if;
    end process;
end;
