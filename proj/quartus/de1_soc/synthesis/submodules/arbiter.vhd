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
        ack_i           : in std_logic;--_vector(channels - 1 downto 0);

        grant_o         : out std_logic_vector(channels - 1 downto 0);
        grant_enc_o     : out std_logic_vector(bit_width(channels) downto 0);
        grant_valid_o   : out std_logic
    );
end arbiter;

architecture behavior of arbiter is
    type states is (idle, evaluate, await, reschedule);
    signal state : states;

    signal request_s            : std_logic_vector(request_i'range);
    signal mask, mask_s         : std_logic_vector(channels - 1 downto 0) := (0 => '1', others => '0');    
    signal grant, grant_s       : std_logic_vector(channels - 1 downto 0);
    signal grant_enc            : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
	 
	signal grant_q  : std_logic_vector(channels-1 downto 0) := (others => '0');
	signal pre_req  : std_logic_vector(channels-1 downto 0) := (others => '0');
	signal sel_gnt  : std_logic_vector(channels-1 downto 0) := (others => '0');
	signal isol_lsb : std_logic_vector(channels-1 downto 0) := (others => '0');
	signal mask_pre : std_logic_vector(channels-1 downto 0) := (others => '0');
	signal win      : std_logic_vector(channels-1 downto 0) := (others => '0');
begin
    --grant_o         <= "01"; --grant;
    --grant_enc_o     <= "00"; --grant_enc;
    --grant_valid_o   <= '1'; --or_reduce(grant);

    -- process(clk_i, rst_i)
    --     variable grant_enc_v : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
    -- begin
    --     if rst_i = '1' then
    --         mask        <= (0 => '1', others => '0');
    --         mask_s      <= (0 => '1', others => '0');
    --         grant       <= (others => '0');
    --         grant_s     <= (others => '0');
    --         grant_enc   <= (others => '0');
    --     else
    --         if rising_edge(clk_i) then
    --             grant_enc_v := (others => '0');

    --             mask    <= mask_s;
    --             grant   <= grant_s;

    --             if unsigned(grant) = 0 or unsigned(grant and ack_i) /= 0 then
    --                 mask_s  <= mask(channels - 2 downto 0) & mask(channels - 1);                    
    --             end if;

    --             grant_s <= request_i and mask;

    --             for i in grant'range loop
    --                 if grant(i) = '1' then
    --                     grant_enc_v := grant_enc_v or std_logic_vector(to_unsigned(i, grant_enc_v'length));
    --                 end if;
    --             end loop;
    --         end if;
    --     end if;
    -- end process;

--    process(clk_i, rst_i)
--        variable grant_enc_v : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
--    begin
--        if rst_i = '1' then
--            state       <= idle;
--
--            request_s   <= (others => '0');
--            mask        <= (0 => '1', others => '0');
--            mask_s      <= (0 => '1', others => '0');
--            grant       <= (others => '0');
--            grant_s     <= (others => '0');
--            grant_enc   <= (others => '0');
--        else
--            if rising_edge(clk_i) then
--                mask    <= mask_s;
--                grant   <= grant_s;
--
--                case state is
--                    when idle =>
--                        state <= evaluate;
--
--                    when evaluate => 
--                        if request_s /= request_i then
--                            state <= reschedule;
--                        elsif unsigned(grant) /= 0 and unsigned(grant and ack_i) = 0 then
--                            state <= await;
--                        end if;
--
--                    when await =>
--                        if unsigned(grant and ack_i) /= 0 then
--                            state <= evaluate;
--                        end if;                    
--
--                    when reschedule =>
--                        mask_s  <= mask(channels - 2 downto 0) & mask(channels - 1);
--
--                        request_s <= request_i;
--                        grant_s <= request_i and mask;
--
--
--                        grant_enc_v := (others => '0');
--
--                        for i in grant_s'range loop
--                            if grant_s(i) = '1' then
--                                grant_enc_v := grant_enc_v or std_logic_vector(to_unsigned(i, grant_enc_v'length));
--                            end if;
--                        end loop;
--
--                        grant_enc <= grant_enc_v;
--
--                        state <= evaluate;
--                end case;
--            end if;
--        end if;
--    end process;

		grant_o    <= grant_q;
		grant_enc_o <= grant_enc;
		grant_valid_o <= or_reduce(grant_q);
		
		mask_pre <=      request_i and not (std_logic_vector(unsigned(pre_req) - 1) or pre_req); -- Mask off previous winners
		sel_gnt  <= mask_pre and      std_logic_vector(unsigned(not(mask_pre)) + 1);       -- Select new winner
		isol_lsb <=      request_i and      std_logic_vector(unsigned(not(request_i)) + 1);            -- Isolate least significant set bit.
		win      <= sel_gnt when mask_pre /= (channels-1 downto 0 => '0') else isol_lsb;

		process (clk_i, rst_i)
          variable grant_enc_v : std_logic_vector(bit_width(channels) downto 0) := (others => '0');
		begin
		if rst_i = '1' then
			pre_req <= (others => '0');
			grant_q <= (others => '0');
		elsif rising_edge(clk_i) then
			grant_q <= grant_q;
			pre_req <= pre_req;
			if unsigned(grant_q) = 0 or ack_i = '1' then
				if unsigned(win) /= 0 then
					pre_req <= win;
				end if;
				grant_q <= win;
                
                grant_enc_v := (others => '0');

				for i in channels - 1 downto 0 loop
					if win(i) = '1' then
						 grant_enc_v := grant_enc_v or std_logic_vector(to_unsigned(i, grant_enc_v'length));
					end if;
			  end loop;
			  

			  grant_enc <= grant_enc_v;
			end if;
		end if;
		end process;
end;
