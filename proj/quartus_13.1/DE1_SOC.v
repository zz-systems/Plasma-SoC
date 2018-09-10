
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE1_SOC(

	//////////// ADC //////////
	// output		          		ADC_CONVST,
	// output		          		ADC_DIN,
	// input 		          		ADC_DOUT,
	// output		          		ADC_SCLK,

	//////////// Audio //////////
	// input 		          		AUD_ADCDAT,
	// inout 		          		AUD_ADCLRCK,
	// inout 		          		AUD_BCLK,
	// output		          		AUD_DACDAT,
	// inout 		          		AUD_DACLRCK,
	// output		          		AUD_XCK,

	//////////// CLOCK //////////
	// input 		          		CLOCK2_50,
	// input 		          		CLOCK3_50,
	// input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	// output		          		FPGA_I2C_SCLK,
	// inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	// input 		          		IRDA_RXD,
	// output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	// inout 		          		PS2_CLK,
	// inout 		          		PS2_CLK2,
	// inout 		          		PS2_DAT,
	// inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	// input 		          		TD_CLK27,
	// input 		     [7:0]		TD_DATA,
	// input 		          		TD_HS,
	// output		          		TD_RESET_N,
	// input 		          		TD_VS,

	//////////// VGA //////////
	// output		          		VGA_BLANK_N,
	// output		     [7:0]		VGA_B,
	// output		          		VGA_CLK,
	// output		     [7:0]		VGA_G,
	// output		          		VGA_HS,
	// output		     [7:0]		VGA_R,
	// output		          		VGA_SYNC_N,
	// output		          		VGA_VS,

	//////////// HPS //////////
	// inout 		          		HPS_CONV_USB_N,
	output		    [14:0]		HPS_DDR3_ADDR,
	output		     [2:0]		HPS_DDR3_BA,
	output		          		HPS_DDR3_CAS_N,
	output		          		HPS_DDR3_CKE,
	output		          		HPS_DDR3_CK_N,
	output		          		HPS_DDR3_CK_P,
	output		          		HPS_DDR3_CS_N,
	output		     [3:0]		HPS_DDR3_DM,
	inout 		    [31:0]		HPS_DDR3_DQ,
	inout 		     [3:0]		HPS_DDR3_DQS_N,
	inout 		     [3:0]		HPS_DDR3_DQS_P,
	output		          		HPS_DDR3_ODT,
	output		          		HPS_DDR3_RAS_N,
	output		          		HPS_DDR3_RESET_N,
	input 		          		HPS_DDR3_RZQ,
	output		          		HPS_DDR3_WE_N,
	output		          		HPS_ENET_GTX_CLK,
	inout 		          		HPS_ENET_INT_N,
	output		          		HPS_ENET_MDC,
	inout 		          		HPS_ENET_MDIO,
	input 		          		HPS_ENET_RX_CLK,
	input 		     [3:0]		HPS_ENET_RX_DATA,
	input 		          		HPS_ENET_RX_DV,
	output		     [3:0]		HPS_ENET_TX_DATA,
	output		          		HPS_ENET_TX_EN,
	inout 		     [3:0]		HPS_FLASH_DATA,
	output		          		HPS_FLASH_DCLK,
	output		          		HPS_FLASH_NCSO,
	// inout 		     [1:0]		HPS_GPIO,
	// inout 		          		HPS_GSENSOR_INT,
	inout 		          		HPS_I2C1_SCLK,
	inout 		          		HPS_I2C1_SDAT,
	inout 		          		HPS_I2C2_SCLK,
	inout 		          		HPS_I2C2_SDAT,
	// inout 		          		HPS_I2C_CONTROL,
	// inout 		          		HPS_KEY,
	// inout 		          		HPS_LED,
	output		          		HPS_SD_CLK,
	inout 		          		HPS_SD_CMD,
	inout 		     [3:0]		HPS_SD_DATA,
	output		          		HPS_SPIM_CLK,
	input 		          		HPS_SPIM_MISO,
	output		          		HPS_SPIM_MOSI,
	inout 		          		HPS_SPIM_SS,
	input 		          		HPS_UART_RX,
	output		          		HPS_UART_TX,
	input 		          		HPS_USB_CLKOUT,
	inout 		     [7:0]		HPS_USB_DATA,
	input 		          		HPS_USB_DIR,
	input 		          		HPS_USB_NXT,
	output		          		HPS_USB_STP,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

  wire  hps_fpga_reset_n;
  wire [3:0] fpga_debounced_buttons;
  wire [2:0]  hps_reset_req;
  wire        hps_cold_reset;
  wire        hps_warm_reset;
  wire        hps_debug_reset;
  wire        fpga_clk_50;
// connection of internal logics
  assign fpga_clk_50=CLOCK_50;

//=======================================================
//  Structural coding
//=======================================================


de1_soc de1_soc(
	// CLK & Reset -------------------------------------------------------------
	.clk_clk(fpga_clk_50),
	.reset_reset_n(1'b1),	

	.hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),                //                hps_0_h2f_reset.reset_n
	.hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset ),      //       hps_0_f2h_cold_reset_req.reset_n
    .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset ),     //      hps_0_f2h_debug_reset_req.reset_n
    .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset ),      //       hps_0_f2h_warm_reset_req.reset_n
	
	// HPS DDR3 ----------------------------------------------------------------
	.hps_0_ddr_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
	.hps_0_ddr_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
	.hps_0_ddr_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
	.hps_0_ddr_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
	.hps_0_ddr_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
	.hps_0_ddr_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
	.hps_0_ddr_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
	.hps_0_ddr_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
	.hps_0_ddr_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
	.hps_0_ddr_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
	.hps_0_ddr_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
	.hps_0_ddr_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
	.hps_0_ddr_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
	.hps_0_ddr_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
	.hps_0_ddr_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
	.hps_0_ddr_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin
	
	// HPS ethernet	------------------------------------------------------------
	.hps_io_0_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),       //                             hps_0_hps_io.hps_io_emac1_inst_TX_CLK
	.hps_io_0_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),   //                             .hps_io_emac1_inst_TXD0
	.hps_io_0_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),   //                             .hps_io_emac1_inst_TXD1
	.hps_io_0_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),   //                             .hps_io_emac1_inst_TXD2
	.hps_io_0_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),   //                             .hps_io_emac1_inst_TXD3
	.hps_io_0_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),   //                             .hps_io_emac1_inst_RXD0
	.hps_io_0_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),         //                             .hps_io_emac1_inst_MDIO
	.hps_io_0_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),         //                             .hps_io_emac1_inst_MDC
	.hps_io_0_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),         //                             .hps_io_emac1_inst_RX_CTL
	.hps_io_0_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),         //                             .hps_io_emac1_inst_TX_CTL
	.hps_io_0_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),        //                             .hps_io_emac1_inst_RX_CLK
	.hps_io_0_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),   //                             .hps_io_emac1_inst_RXD1
	.hps_io_0_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),   //                             .hps_io_emac1_inst_RXD2
	.hps_io_0_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),   //                             .hps_io_emac1_inst_RXD3

	//HPS USB ------------------------------------------------------------------
	.hps_io_0_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),      //                               .hps_io_usb1_inst_D0
	.hps_io_0_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),      //                               .hps_io_usb1_inst_D1
	.hps_io_0_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),      //                               .hps_io_usb1_inst_D2
	.hps_io_0_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),      //                               .hps_io_usb1_inst_D3
	.hps_io_0_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),      //                               .hps_io_usb1_inst_D4
	.hps_io_0_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),      //                               .hps_io_usb1_inst_D5
	.hps_io_0_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),      //                               .hps_io_usb1_inst_D6
	.hps_io_0_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),      //                               .hps_io_usb1_inst_D7
	.hps_io_0_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),       //                               .hps_io_usb1_inst_CLK
	.hps_io_0_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),          //                               .hps_io_usb1_inst_STP
	.hps_io_0_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),          //                               .hps_io_usb1_inst_DIR
	.hps_io_0_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),          //                               .hps_io_usb1_inst_NXT
	
	// HPS QSPI ----------------------------------------------------------------
	.hps_io_0_hps_io_qspi_inst_IO0     ( HPS_FLASH_DATA[0]    ),     //                               .hps_io_qspi_inst_IO0
	.hps_io_0_hps_io_qspi_inst_IO1     ( HPS_FLASH_DATA[1]    ),     //                               .hps_io_qspi_inst_IO1
	.hps_io_0_hps_io_qspi_inst_IO2     ( HPS_FLASH_DATA[2]    ),     //                               .hps_io_qspi_inst_IO2
	.hps_io_0_hps_io_qspi_inst_IO3     ( HPS_FLASH_DATA[3]    ),     //                               .hps_io_qspi_inst_IO3
	.hps_io_0_hps_io_qspi_inst_SS0     ( HPS_FLASH_NCSO    ),        //                               .hps_io_qspi_inst_SS0
	.hps_io_0_hps_io_qspi_inst_CLK     ( HPS_FLASH_DCLK    ),        //                               .hps_io_qspi_inst_CLK

	// HPS SPI -----------------------------------------------------------------
	.hps_io_0_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),           //                               .hps_io_spim1_inst_CLK
	.hps_io_0_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),           //                               .hps_io_spim1_inst_MOSI
	.hps_io_0_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),           //                               .hps_io_spim1_inst_MISO
	.hps_io_0_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS ),             //                               .hps_io_spim1_inst_SS0

	// HPS SD card -------------------------------------------------------------	
	.hps_io_0_hps_io_sdio_inst_CMD       (HPS_SD_CMD),       //                     hps_io_0.hps_io_sdio_inst_CMD
	.hps_io_0_hps_io_sdio_inst_D0        (HPS_SD_DATA[0]),        //                             .hps_io_sdio_inst_D0
	.hps_io_0_hps_io_sdio_inst_D1        (HPS_SD_DATA[1]),        //                             .hps_io_sdio_inst_D1
	.hps_io_0_hps_io_sdio_inst_CLK       (HPS_SD_CLK),       //                             .hps_io_sdio_inst_CLK
	.hps_io_0_hps_io_sdio_inst_D2        (HPS_SD_DATA[2]),        //                             .hps_io_sdio_inst_D2
	.hps_io_0_hps_io_sdio_inst_D3        (HPS_SD_DATA[3]),        //                             .hps_io_sdio_inst_D3
	
	// HPS UART ----------------------------------------------------------------
	.hps_io_0_hps_io_uart0_inst_RX       (HPS_UART_RX),       //                             .hps_io_uart0_inst_RX
	.hps_io_0_hps_io_uart0_inst_TX       (HPS_UART_TX),       //                             .hps_io_uart0_inst_TX

	// HPS I2C1 ----------------------------------------------------------------
	.hps_io_0_hps_io_i2c0_inst_SDA     ( HPS_I2C1_SDAT    ),        //                               .hps_io_i2c0_inst_SDA
	.hps_io_0_hps_io_i2c0_inst_SCL     ( HPS_I2C1_SCLK    ),        //                               .hps_io_i2c0_inst_SCL
	// HPS I2C2 ----------------------------------------------------------------
	.hps_io_0_hps_io_i2c1_inst_SDA     ( HPS_I2C2_SDAT    ),        //                               .hps_io_i2c1_inst_SDA
	.hps_io_0_hps_io_i2c1_inst_SCL     ( HPS_I2C2_SCLK    ),        //                               .hps_io_i2c1_inst_SCL

	// Plasma-SoC SD CARD ------------------------------------------------------
	.plasma_soc_0_sd_card_spi_cs(),
	.plasma_soc_0_sd_card_spi_miso(),
	.plasma_soc_0_sd_card_spi_mosi(),
	.plasma_soc_0_sd_card_spi_sclk(),

	// BASIC I/O ---------------------------------------------------------------
	.plasma_soc_0_leds_ld(LEDR),
	.plasma_soc_0_switches_sw(SW),

	.switches_external_connection_export(SW), 

	.buttons_external_connection_export(fpga_debounced_buttons),

	.hex_0_external_connection_export(HEX0),
	.hex_1_external_connection_export(HEX1),
	.hex_2_external_connection_export(HEX2),
	.hex_3_external_connection_export(HEX3),
	.hex_4_external_connection_export(HEX4),
	.hex_5_external_connection_export(HEX5),
	
	// Plasma-SoC UART ---------------------------------------------------------
	.plasma_soc_0_uart_uart_rx(), //HPS_UART_RX),
	.plasma_soc_0_uart_uart_tx(), //HPS_UART_TX),

	// SDRAM -------------------------------------------------------------------
	.sdram_controller_0_wire_addr(DRAM_ADDR),
	.sdram_controller_0_wire_ba(DRAM_BA),
	.sdram_controller_0_wire_cas_n(DRAM_CAS_N),
	.sdram_controller_0_wire_cke(DRAM_CKE),
	.sdram_controller_0_wire_cs_n(DRAM_CS_N),
	.sdram_controller_0_wire_dq(DRAM_DQ),
	.sdram_controller_0_wire_dqm({DRAM_UDQM, DRAM_LDQM}),
	.sdram_controller_0_wire_ras_n(DRAM_RAS_N),
	.sdram_controller_0_wire_we_n(DRAM_WE_N),
	.pll_0_sdram_clk_clk(DRAM_CLK)
);

// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
  .clk                                  (fpga_clk_50),
  .reset_n                              (hps_fpga_reset_n),  
  .data_in                              (KEY),
  .data_out                             (fpga_debounced_buttons)
);
  defparam debounce_inst.WIDTH = 4;
  defparam debounce_inst.POLARITY = "LOW";
  defparam debounce_inst.TIMEOUT = 50000;               // at 50Mhz this is a debounce time of 1ms
  defparam debounce_inst.TIMEOUT_WIDTH = 16;            // ceil(log2(TIMEOUT))
  
// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (fpga_clk_50),
  .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;
  
altera_edge_detector pulse_debug_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;
endmodule