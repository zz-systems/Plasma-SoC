--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
-- Modified by Sergej Zuyev
--
-- Description: Top level controller that controls the OLED display.
--

library ieee;
    use ieee.std_logic_1164.all;    
    use ieee.numeric_std.all;

library zz_systems;
    use zz_systems.timer_pkg.all;

entity oled_control is
generic
(
    constant sys_clk        : positive := 50000000;
    constant spi_clk        : positive := 1000000;

    constant example_active : boolean := true
);
port 
(  
    clk_i       : in std_logic;
    rst_i       : in std_logic;

    sdin_o      : out std_logic;
    sclk_o      : out std_logic;
    dc_o        : out std_logic;
    res_o       : out std_logic;
    vbat_o      : out std_logic;
    vdd_o       : out std_logic;

    adr_i       : in std_logic_vector(9 downto 0);
    dat_i       : in std_logic_vector(7 downto 0);
    we_i        : in std_logic;

    cmd_i       : in std_logic; -- issue direct commands via spi
    text_mode_i : in std_logic; -- text mode
    flush_i     : in std_logic; -- flush the video buffer to screen
    clear_i     : in std_logic; -- clear screen
    ready_o     : out std_logic
);
end oled_control;

architecture behavioral of oled_control is

    constant in_simulation : boolean := false
    --pragma synthesis_off
                                        or true
    --pragma synthesis_on
    ;
    constant in_synthesis : boolean := not in_simulation;


    signal unit : unit_t := unit_msec;

     -- States for state machine
     type states is 
     (
        Reset,
        Idle,
        Init,
        Example,

        --OledExample,
        SendImmediate,
        Flush1,
        Flush2,

        -- Initializer sequence
        VddOn,
        Wait1,
        DispOff,
        ResetOn,
        Wait2,
        ResetOff,
        ChargePump1,
        ChargePump2,
        PreCharge1,
        PreCharge2,
        VbatOn,
        Wait3,
        DispContrast1,
        DispContrast2,
        InvertDisp1,
        InvertDisp2,
        ComConfig1,
        ComConfig2,
        DispOn,
        InitDone,

        -- Example sequence
        --ExamplePicture,
        ExampleAlphabet,
        ExampleWait1,
        ExampleClearScreen,
        ExampleWait2,
        ExampleHelloWorldScreen,
        ExampleDone,

        -- Write sequence
        ClearDC,
        SetPage,
        PageNum,
        LeftColumn1,
        LeftColumn2,
        SetDC,
        UpdateScreen,
        SendChar1,
        SendChar2,
        SendChar3,
        SendChar4,
        SendChar5,
        SendChar6,
        SendChar7,
        SendChar8,
        ReadMem,
        ReadMem2,
        Done,

        -- SPI transitions
        Transition1,
        Transition2,
        Transition3,
        Transition4,
        Transition5
    );

    -- Current overall state of the state machine
    signal current_state : states := Reset;

    -- State to go to after the SPI transmission is finished
    signal after_state : states;

    -- State to go to after the set page sequence
    signal after_page_state : states;

    -- State to go to after sending the character sequence
    signal after_char_state : states;

    -- State to go to after the UpdateScreen is finished
    signal after_update_state : states;

    -- Contains the value to be outputted to oled_dc

    signal temp_dc      : std_logic := '0';
    signal temp_res     : std_logic := '1';
    signal temp_vbat    : std_logic := '1';
    signal temp_vdd     : std_logic := '1';

    signal temp_char    : std_logic_vector (7 downto 0) := (others => '0'); -- Contains ASCII value for character
    signal temp_addr    : std_logic_vector (10 downto 0) := (others => '0'); -- Contains address to byte needed in memory
    signal temp_dout    : std_logic_vector (7 downto 0); -- Contains byte outputted from memory
    signal temp_page    : unsigned (1 downto 0) := (others => '0'); -- Current page
    signal temp_index   : integer range 0 to 15 := 0; -- Current character on page


    signal example_en       : std_logic := '0';

    signal spi_en           : std_logic := '0';
    signal spi_done         : std_logic := '0';
    signal spi_data         : std_logic_vector(7 downto 0);

    signal delay_en         : std_logic := '0';
    signal delay_done       : std_logic := '0';
    signal delay_ms         : std_logic_vector(11 downto 0);

    signal example_delay_ms     : std_logic_vector(11 downto 0);

    subtype vram_t is std_logic_vector(0 to 4095);
    subtype vtextram_t is std_logic_vector(0 to 511);

    signal vram : vtextram_t;

    signal dat_s : std_logic_vector(dat_i'range);
    signal text_mode_s : std_logic := '0';


    -- Constant that contains the screen filled with the Alphabet and numbers
    constant alphabet_screen : vtextram_t := ( x"41" & x"42" & x"43" & x"44" & x"45" & x"46" & x"47" & x"48" & x"49" & x"4A" & x"4B" & x"4C" & x"4D" & x"4E" & x"4F" & x"50"
                                         & x"51" & x"52" & x"53" & x"54" & x"55" & x"56" & x"57" & x"58" & x"59" & x"5A" & x"61" & x"62" & x"63" & x"64" & x"65" & x"66"
                                         & x"67" & x"68" & x"69" & x"6A" & x"6B" & x"6C" & x"6D" & x"6E" & x"6F" & x"70" & x"71" & x"72" & x"73" & x"74" & x"75" & x"76"
                                         & x"77" & x"78" & x"79" & x"7A" & x"30" & x"31" & x"32" & x"33" & x"34" & x"35" & x"36" & x"37" & x"38" & x"39" & x"7F" & x"7F");

    -- Constant that fills the screen with blank (spaces) entries
    constant clear_screen : vtextram_t := ( x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20"
                                      & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20"
                                      & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20"
                                      & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20");

    -- Constant that holds "Hello world!"
    constant hello_world_screen : vtextram_t := ( x"48" & x"65" & x"6c" & x"6c" & x"6f" & x"20" & x"77" & x"6f" & x"72" & x"6c" & x"64" & x"21" & x"20" & x"20" & x"20" & x"20"
                                            & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20"
                                            & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20"
                                            & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20" & x"20");
begin

    -- Instantiate SPI controller									
	spi: entity zz_systems.spi_control 
	generic map
	(
		slaves      => 1,
		data_w      => 8,
		sys_clk     => sys_clk,
		spi_clk     => spi_clk
	)
	port map
	(
		clk_i   => clk_i,
		rst_i   => rst_i,

		en_i    => spi_en,
		adr_i   => "0",
		dat_i   => spi_data,

		MOSI    => sdin_o,
		MISO    => '0',
		SCLK    => sclk_o,

		ack_o   => spi_done
	);

    -- Instantiate delay
	delay : entity zz_systems.timer
	generic map
	(
		sys_clk => sys_clk,
		data_w => 12
	)
	port map
	(
		clk_i   => clk_i,
		rst_i   => rst_i,
	
		en_i    => delay_en,
		unit_i  => unit,
        rld_i   => delay_ms,
        cnt_o   => open,
	
		irq_o   => delay_done
    );

    -- Instantiate ASCII character library
    char_lib_comp : entity zz_systems.ascii_rom port map (clk => clk_i,
                                        addr => temp_addr,
                                        dout => temp_dout);

    dc_o        <= temp_dc;
    res_o 	    <= temp_res;
    vbat_o 	    <= temp_vbat;
    vdd_o 	    <= temp_vdd;

    ready_o     <= '1' when current_state = Idle else '0';

    unit        <= unit_usec when in_simulation else unit_msec;
    
    delay_ms    <=  example_delay_ms    when example_en = '1' else  
                    x"064"              when after_state = DispContrast1 else   -- 100ms
                    x"001";                                                     -- 1ms;

   
    process (clk_i, rst_i)
        variable addr_v : integer := 0;
        variable index_v : integer := 0;
    begin
        if rst_i = '1' then
            example_en      <= '0';

            temp_dc         <= '0';
            temp_res        <= '1';
            temp_vbat       <= '1';
            temp_vdd        <= '1';

            temp_page       <= "00";
            temp_index      <= 0;

            spi_data        <= (others => '0');
            spi_en          <= '0';
            delay_en        <= '0';

            vram            <= (others => '0');

            current_state   <= Reset;
        elsif rising_edge(clk_i) then
            case current_state is               
                when Reset => 
                    current_state   <= Init;
                
                when Idle =>
                    if we_i = '1' then
                        if cmd_i = '1' then 
                            dat_s <= dat_i;

                            after_state   <= Idle;
                            current_state <= SendImmediate;
                        else
                            addr_v := to_integer(unsigned(adr_i));

                            vram(addr_v * 8 to (addr_v + 1) * 8 - 1) <= dat_i;
                        end if;
                    elsif flush_i = '1' then
                        current_state <= Flush1;
                    elsif clear_i = '1' then
                        vram                <= clear_screen;
                        current_state       <= Flush1;
                    else                       
                        current_state <= Idle;
                    end if;

                    text_mode_s <= text_mode_i;

                
                -- Allow direct SPI command issue
                when SendImmediate => 
                    spi_data   <= dat_s;
                    current_state   <= Transition1;   

                -- Do example and return to idle when finished
                when Flush1 =>
                    current_state <= ClearDC;
                    after_page_state <= Flush2;
                    temp_page <= "00";

                when Flush2 => 
                    current_state <= UpdateScreen;
                    after_update_state <= Idle;
                
                when Init => 
                    current_state <= VddOn;
                -- Go through the initialization sequence
                -- Initialization Sequence
				-- This should be done everytime the OLED display is started
				when VddOn =>
                    temp_vdd <= '0';
                    current_state <= Wait1;
                when Wait1 =>
                    after_state <= DispOff;
                    current_state <= Transition3;
                when DispOff =>
                    spi_data <= x"AE";
                    after_state <= ResetOn;
                    current_state <= Transition1;
                when ResetOn =>
                    temp_res <= '0';
                    current_state <= Wait2;
                when Wait2 =>
                    after_state <= ResetOff;
                    current_state <= Transition3;
                when ResetOff =>
                    temp_res <= '1';
                    after_state <= ChargePump1;
                    current_state <= Transition3;
                when ChargePump1 =>
                    spi_data <= x"8D";
                    after_state <= ChargePump2;
                    current_state <= Transition1;
                when ChargePump2 =>
                    spi_data <= x"14";
                    after_state <= PreCharge1;
                    current_state <= Transition1;
                when PreCharge1  =>
                    spi_data <= x"D9";
                    after_state <= PreCharge2;
                    current_state <= Transition1;
                when PreCharge2 =>
                    spi_data <= x"F1";
                    after_state <= VbatOn;
                    current_state <= Transition1;
                when VbatOn =>
                    temp_vbat <= '0';
                    current_state <= Wait3;
                when Wait3 =>
                    after_state <= DispContrast1;
                    current_state <= Transition3;
                when DispContrast1=>
                    spi_data <= x"81";
                    after_state <= DispContrast2;
                    current_state <= Transition1;
                when DispContrast2=>
                    spi_data <= x"0F";
                    after_state <= InvertDisp1;
                    current_state <= Transition1;
                when InvertDisp1 =>
                    spi_data <= x"A0";
                    after_state <= InvertDisp2;
                    current_state <= Transition1;
                when InvertDisp2 =>
                    spi_data <= x"C0";
                    after_state <= ComConfig1;
                    current_state <= Transition1;
                when ComConfig1 => 
                    spi_data <= x"DA"; -- COM pin configuration (DAh)
                    after_state <= ComConfig2;
                    current_state <= Transition1;
                when ComConfig2 =>
                    spi_data <= x"00"; -- COM pin configuration sequential (00h)
                    after_state <= DispOn;
                    current_state <= Transition1;
                when DispOn =>
                    spi_data <= x"AF";
                    after_state <= InitDone;
                    current_state <= Transition1;

                when InitDone => 
                    if example_active and in_synthesis then 
                        current_state <= Example;
                    else 
                        current_state <= Idle;
                    end if;

                -- End Initialization sequence               
                
                -- Do example and return to idle when finished
                when Example =>
                    example_en <= '1';
                    current_state <= ClearDC;
                    after_page_state <= ExampleAlphabet;
                    temp_page <= "00";

                -- when ExamplePicture =>
                --     --vram <= picture_screen;
                --     text_mode_s <= '0';
                --     current_state <= UpdateScreen;
                --     after_update_state <= ExampleDone;

                -- Set current_screen to constant alphabet_screen and update the screen; go to state Wait1 afterwards
                when ExampleAlphabet =>
                    vram <= alphabet_screen;
                    text_mode_s <= '1';
                    current_state <= UpdateScreen;
                    after_update_state <= ExampleWait1;
                -- Wait 4ms and go to ClearScreen
                when ExampleWait1 =>
                    example_delay_ms <= x"FA0"; -- 4000
                    after_state <= ExampleClearScreen;
                    current_state <= Transition3; -- Transition3 = delay transition states
                -- Set current_screen to constant clear_screen and update the screen; go to state Wait2 afterwards
                when ExampleClearScreen =>
                    vram <= clear_screen;
                    text_mode_s <= '1';
                    after_update_state <= ExampleWait2;
                    current_state <= UpdateScreen;
                -- Wait 1ms and go to HelloWorldScreen
                when ExampleWait2 =>
                    example_delay_ms <= x"3E8"; -- 1000
                    after_state <= ExampleHelloWorldScreen;
                    current_state <= Transition3; -- Transition3 = delay transition states
                -- Set currentScreen to constant hello_world_screen and update the screen; go to state Done afterwards
                when ExampleHelloWorldScreen =>
                    vram <= hello_world_screen;
                    text_mode_s <= '1';
                    after_update_state <= ExampleDone;
                    current_state <= UpdateScreen;

                when ExampleDone => 
                    --vram            <= (others => '0');
                    text_mode_s     <= '0';
                    example_en      <= '0';
                    current_state   <= Idle;

                -- UpdateScreen State
                -- 1. Gets value from vram at the current page and the current spot
                --    of the page
                -- 2. If on the last character of the page transition update the page number, if on
                --    the last page(3) then the updateScreen go to "after_update_state" after
                when UpdateScreen =>  
                    -- TEXT MODE ---------------------------------------------------
                    index_v := to_integer(temp_page) * 16 + temp_index;

                    temp_char <= vram(index_v * 8 to (index_v + 1) * 8 - 1);
                    
                    if temp_index = 15 then
                        temp_index <= 0;
                        temp_page <= temp_page + 1;
                        after_char_state <= ClearDC;
                        if temp_page = "11" then
                            after_page_state <= after_update_state;
                        else
                            after_page_state <= UpdateScreen;
                        end if;
                    else
                        temp_index <= temp_index + 1;
                        after_char_state <= UpdateScreen;
                    end if;

                    if text_mode_s = '1' then
                        current_state <= SendChar1;
                    else 
                        after_state <= after_char_state;
                        current_state <= SendImmediate;
                    end if;

                -- Update Page states
                -- 1. Sets oled_dc to command mode
                -- 2. Sends the SetPage Command
                -- 3. Sends the Page to be set to
                -- 4. Sets the start pixel to the left column
                -- 5. Sets oled_dc to data mode
                when ClearDC =>
                    temp_dc <= '0';
                    current_state <= SetPage;
                when SetPage =>
                    spi_data <= "00100010";
                    after_state <= PageNum;
                    current_state <= Transition1;
                when PageNum =>
                    spi_data <= "000000" & std_logic_vector(temp_page);
                    after_state <= LeftColumn1;
                    current_state <= Transition1;
                when LeftColumn1 =>
                    spi_data <= "00000000";
                    after_state <= LeftColumn2;
                    current_state <= Transition1;
                when LeftColumn2 =>
                    spi_data <= "00010000";
                    after_state <= SetDC;
                    current_state <= Transition1;
                when SetDC =>
                    temp_dc <= '1';
                    current_state <= after_page_state;
                -- End update Page states

                -- Send character states
                -- 1. Sets the address to ASCII value of character with the counter appended to the
                --    end
                -- 2. Waits a clock cycle for the data to get ready by going to ReadMem and ReadMem2
                --    states
                -- 3. Send the byte of data given by the ROM
                -- 4. Repeat 7 more times for the rest of the character bytes
                when SendChar1 =>
                    temp_addr <= temp_char & "000";
                    after_state <= SendChar2;
                    current_state <= ReadMem;
                when SendChar2 =>
                    temp_addr <= temp_char & "001";
                    after_state <= SendChar3;
                    current_state <= ReadMem;
                when SendChar3 =>
                    temp_addr <= temp_char & "010";
                    after_state <= SendChar4;
                    current_state <= ReadMem;
                when SendChar4 =>
                    temp_addr <= temp_char & "011";
                    after_state <= SendChar5;
                    current_state <= ReadMem;
                when SendChar5 =>
                    temp_addr <= temp_char & "100";
                    after_state <= SendChar6;
                    current_state <= ReadMem;
                when SendChar6 =>
                    temp_addr <= temp_char & "101";
                    after_state <= SendChar7;
                    current_state <= ReadMem;
                when SendChar7 =>
                    temp_addr <= temp_char & "110";
                    after_state <= SendChar8;
                    current_state <= ReadMem;
                when SendChar8 =>
                    temp_addr <= temp_char & "111";
                    after_state <= after_char_state;
                    current_state <= ReadMem;
                when ReadMem =>
                    current_state <= ReadMem2;
                when ReadMem2 =>
                    spi_data <= temp_dout;
                    current_state <= Transition1;
                -- End send character states

                -- SPI transitions
                -- 1. Set en to 1
                -- 2. Waits for spi_ctrl to finish
                -- 3. Goes to clear state (Transition5)
                when Transition1 =>
                    spi_en <= '1';
                    current_state <= Transition2;
                when Transition2 =>
                    if spi_done = '1' then
                        current_state <= Transition5;
                    end if;
                -- End SPI transitions

                -- Delay transitions
                -- 1. Set delay_en to 1
                -- 2. Waits for delay to finish
                -- 3. Goes to Clear state (Transition5)
                when Transition3 =>
                    delay_en <= '1';
                    current_state <= Transition4;
                when Transition4 =>
                    if delay_done = '1' then
                        current_state <= Transition5;
                    end if;
                -- End Delay transitions

                -- Clear transition
                -- 1. Sets both delay_en and en to 0
                -- 2. Go to after state
                when Transition5 =>
                    spi_en <= '0';
                    delay_en <= '0';
                    current_state <= after_state;
                -- End Clear transition

                when others =>
                    current_state <= Init;
            end case;
        end if;
    end process;

end behavioral;