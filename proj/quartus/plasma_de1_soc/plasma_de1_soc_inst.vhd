	component plasma_de1_soc is
		port (
			clk_clk                          : in    std_logic                     := 'X';             -- clk
			hps_0_ddr_mem_a                  : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_0_ddr_mem_ba                 : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_0_ddr_mem_ck                 : out   std_logic;                                        -- mem_ck
			hps_0_ddr_mem_ck_n               : out   std_logic;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                : out   std_logic;                                        -- mem_cke
			hps_0_ddr_mem_cs_n               : out   std_logic;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n              : out   std_logic;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n              : out   std_logic;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n               : out   std_logic;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n            : out   std_logic;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                 : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n              : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                : out   std_logic;                                        -- mem_odt
			hps_0_ddr_mem_dm                 : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_0_ddr_oct_rzqin              : in    std_logic                     := 'X';             -- oct_rzqin
			plasma_soc_0_leds_ld             : out   std_logic_vector(9 downto 0);                     -- ld
			plasma_soc_0_sd_card_sd_cd       : in    std_logic                     := 'X';             -- sd_cd
			plasma_soc_0_sd_card_sd_spi_cs   : out   std_logic;                                        -- sd_spi_cs
			plasma_soc_0_sd_card_sd_spi_miso : in    std_logic                     := 'X';             -- sd_spi_miso
			plasma_soc_0_sd_card_sd_spi_mosi : out   std_logic;                                        -- sd_spi_mosi
			plasma_soc_0_sd_card_sd_spi_sclk : out   std_logic;                                        -- sd_spi_sclk
			plasma_soc_0_sd_card_sd_wp       : in    std_logic                     := 'X';             -- sd_wp
			plasma_soc_0_switches_sw         : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- sw
			plasma_soc_0_uart_uart_rx        : in    std_logic                     := 'X';             -- uart_rx
			plasma_soc_0_uart_uart_tx        : out   std_logic;                                        -- uart_tx
			sdram_controller_0_wire_addr     : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_0_wire_ba       : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_0_wire_cas_n    : out   std_logic;                                        -- cas_n
			sdram_controller_0_wire_cke      : out   std_logic;                                        -- cke
			sdram_controller_0_wire_cs_n     : out   std_logic;                                        -- cs_n
			sdram_controller_0_wire_dq       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_0_wire_dqm      : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_0_wire_ras_n    : out   std_logic;                                        -- ras_n
			sdram_controller_0_wire_we_n     : out   std_logic;                                        -- we_n
			sys_sdram_pll_0_sdram_clk_clk    : out   std_logic                                         -- clk
		);
	end component plasma_de1_soc;

	u0 : component plasma_de1_soc
		port map (
			clk_clk                          => CONNECTED_TO_clk_clk,                          --                       clk.clk
			hps_0_ddr_mem_a                  => CONNECTED_TO_hps_0_ddr_mem_a,                  --                 hps_0_ddr.mem_a
			hps_0_ddr_mem_ba                 => CONNECTED_TO_hps_0_ddr_mem_ba,                 --                          .mem_ba
			hps_0_ddr_mem_ck                 => CONNECTED_TO_hps_0_ddr_mem_ck,                 --                          .mem_ck
			hps_0_ddr_mem_ck_n               => CONNECTED_TO_hps_0_ddr_mem_ck_n,               --                          .mem_ck_n
			hps_0_ddr_mem_cke                => CONNECTED_TO_hps_0_ddr_mem_cke,                --                          .mem_cke
			hps_0_ddr_mem_cs_n               => CONNECTED_TO_hps_0_ddr_mem_cs_n,               --                          .mem_cs_n
			hps_0_ddr_mem_ras_n              => CONNECTED_TO_hps_0_ddr_mem_ras_n,              --                          .mem_ras_n
			hps_0_ddr_mem_cas_n              => CONNECTED_TO_hps_0_ddr_mem_cas_n,              --                          .mem_cas_n
			hps_0_ddr_mem_we_n               => CONNECTED_TO_hps_0_ddr_mem_we_n,               --                          .mem_we_n
			hps_0_ddr_mem_reset_n            => CONNECTED_TO_hps_0_ddr_mem_reset_n,            --                          .mem_reset_n
			hps_0_ddr_mem_dq                 => CONNECTED_TO_hps_0_ddr_mem_dq,                 --                          .mem_dq
			hps_0_ddr_mem_dqs                => CONNECTED_TO_hps_0_ddr_mem_dqs,                --                          .mem_dqs
			hps_0_ddr_mem_dqs_n              => CONNECTED_TO_hps_0_ddr_mem_dqs_n,              --                          .mem_dqs_n
			hps_0_ddr_mem_odt                => CONNECTED_TO_hps_0_ddr_mem_odt,                --                          .mem_odt
			hps_0_ddr_mem_dm                 => CONNECTED_TO_hps_0_ddr_mem_dm,                 --                          .mem_dm
			hps_0_ddr_oct_rzqin              => CONNECTED_TO_hps_0_ddr_oct_rzqin,              --                          .oct_rzqin
			plasma_soc_0_leds_ld             => CONNECTED_TO_plasma_soc_0_leds_ld,             --         plasma_soc_0_leds.ld
			plasma_soc_0_sd_card_sd_cd       => CONNECTED_TO_plasma_soc_0_sd_card_sd_cd,       --      plasma_soc_0_sd_card.sd_cd
			plasma_soc_0_sd_card_sd_spi_cs   => CONNECTED_TO_plasma_soc_0_sd_card_sd_spi_cs,   --                          .sd_spi_cs
			plasma_soc_0_sd_card_sd_spi_miso => CONNECTED_TO_plasma_soc_0_sd_card_sd_spi_miso, --                          .sd_spi_miso
			plasma_soc_0_sd_card_sd_spi_mosi => CONNECTED_TO_plasma_soc_0_sd_card_sd_spi_mosi, --                          .sd_spi_mosi
			plasma_soc_0_sd_card_sd_spi_sclk => CONNECTED_TO_plasma_soc_0_sd_card_sd_spi_sclk, --                          .sd_spi_sclk
			plasma_soc_0_sd_card_sd_wp       => CONNECTED_TO_plasma_soc_0_sd_card_sd_wp,       --                          .sd_wp
			plasma_soc_0_switches_sw         => CONNECTED_TO_plasma_soc_0_switches_sw,         --     plasma_soc_0_switches.sw
			plasma_soc_0_uart_uart_rx        => CONNECTED_TO_plasma_soc_0_uart_uart_rx,        --         plasma_soc_0_uart.uart_rx
			plasma_soc_0_uart_uart_tx        => CONNECTED_TO_plasma_soc_0_uart_uart_tx,        --                          .uart_tx
			sdram_controller_0_wire_addr     => CONNECTED_TO_sdram_controller_0_wire_addr,     --   sdram_controller_0_wire.addr
			sdram_controller_0_wire_ba       => CONNECTED_TO_sdram_controller_0_wire_ba,       --                          .ba
			sdram_controller_0_wire_cas_n    => CONNECTED_TO_sdram_controller_0_wire_cas_n,    --                          .cas_n
			sdram_controller_0_wire_cke      => CONNECTED_TO_sdram_controller_0_wire_cke,      --                          .cke
			sdram_controller_0_wire_cs_n     => CONNECTED_TO_sdram_controller_0_wire_cs_n,     --                          .cs_n
			sdram_controller_0_wire_dq       => CONNECTED_TO_sdram_controller_0_wire_dq,       --                          .dq
			sdram_controller_0_wire_dqm      => CONNECTED_TO_sdram_controller_0_wire_dqm,      --                          .dqm
			sdram_controller_0_wire_ras_n    => CONNECTED_TO_sdram_controller_0_wire_ras_n,    --                          .ras_n
			sdram_controller_0_wire_we_n     => CONNECTED_TO_sdram_controller_0_wire_we_n,     --                          .we_n
			sys_sdram_pll_0_sdram_clk_clk    => CONNECTED_TO_sys_sdram_pll_0_sdram_clk_clk     -- sys_sdram_pll_0_sdram_clk.clk
		);

