
module de1_soc (
	clk_clk,
	hex_0_external_connection_export,
	hex_1_external_connection_export,
	hex_2_external_connection_export,
	hex_3_external_connection_export,
	hex_4_external_connection_export,
	hex_5_external_connection_export,
	hps_0_ddr_mem_a,
	hps_0_ddr_mem_ba,
	hps_0_ddr_mem_ck,
	hps_0_ddr_mem_ck_n,
	hps_0_ddr_mem_cke,
	hps_0_ddr_mem_cs_n,
	hps_0_ddr_mem_ras_n,
	hps_0_ddr_mem_cas_n,
	hps_0_ddr_mem_we_n,
	hps_0_ddr_mem_reset_n,
	hps_0_ddr_mem_dq,
	hps_0_ddr_mem_dqs,
	hps_0_ddr_mem_dqs_n,
	hps_0_ddr_mem_odt,
	hps_0_ddr_mem_dm,
	hps_0_ddr_oct_rzqin,
	hps_io_0_hps_io_emac1_inst_TX_CLK,
	hps_io_0_hps_io_emac1_inst_TXD0,
	hps_io_0_hps_io_emac1_inst_TXD1,
	hps_io_0_hps_io_emac1_inst_TXD2,
	hps_io_0_hps_io_emac1_inst_TXD3,
	hps_io_0_hps_io_emac1_inst_RXD0,
	hps_io_0_hps_io_emac1_inst_MDIO,
	hps_io_0_hps_io_emac1_inst_MDC,
	hps_io_0_hps_io_emac1_inst_RX_CTL,
	hps_io_0_hps_io_emac1_inst_TX_CTL,
	hps_io_0_hps_io_emac1_inst_RX_CLK,
	hps_io_0_hps_io_emac1_inst_RXD1,
	hps_io_0_hps_io_emac1_inst_RXD2,
	hps_io_0_hps_io_emac1_inst_RXD3,
	hps_io_0_hps_io_qspi_inst_IO0,
	hps_io_0_hps_io_qspi_inst_IO1,
	hps_io_0_hps_io_qspi_inst_IO2,
	hps_io_0_hps_io_qspi_inst_IO3,
	hps_io_0_hps_io_qspi_inst_SS0,
	hps_io_0_hps_io_qspi_inst_CLK,
	hps_io_0_hps_io_sdio_inst_CMD,
	hps_io_0_hps_io_sdio_inst_D0,
	hps_io_0_hps_io_sdio_inst_D1,
	hps_io_0_hps_io_sdio_inst_CLK,
	hps_io_0_hps_io_sdio_inst_D2,
	hps_io_0_hps_io_sdio_inst_D3,
	hps_io_0_hps_io_usb1_inst_D0,
	hps_io_0_hps_io_usb1_inst_D1,
	hps_io_0_hps_io_usb1_inst_D2,
	hps_io_0_hps_io_usb1_inst_D3,
	hps_io_0_hps_io_usb1_inst_D4,
	hps_io_0_hps_io_usb1_inst_D5,
	hps_io_0_hps_io_usb1_inst_D6,
	hps_io_0_hps_io_usb1_inst_D7,
	hps_io_0_hps_io_usb1_inst_CLK,
	hps_io_0_hps_io_usb1_inst_STP,
	hps_io_0_hps_io_usb1_inst_DIR,
	hps_io_0_hps_io_usb1_inst_NXT,
	hps_io_0_hps_io_spim1_inst_CLK,
	hps_io_0_hps_io_spim1_inst_MOSI,
	hps_io_0_hps_io_spim1_inst_MISO,
	hps_io_0_hps_io_spim1_inst_SS0,
	hps_io_0_hps_io_uart0_inst_RX,
	hps_io_0_hps_io_uart0_inst_TX,
	hps_io_0_hps_io_i2c0_inst_SDA,
	hps_io_0_hps_io_i2c0_inst_SCL,
	hps_io_0_hps_io_i2c1_inst_SDA,
	hps_io_0_hps_io_i2c1_inst_SCL,
	keys_external_connection_export,
	plasma_soc_0_leds_ld,
	plasma_soc_0_sd_card_spi_cs,
	plasma_soc_0_sd_card_spi_miso,
	plasma_soc_0_sd_card_spi_mosi,
	plasma_soc_0_sd_card_spi_sclk,
	plasma_soc_0_switches_sw,
	plasma_soc_0_uart_uart_rx,
	plasma_soc_0_uart_uart_tx,
	sdram_controller_0_wire_addr,
	sdram_controller_0_wire_ba,
	sdram_controller_0_wire_cas_n,
	sdram_controller_0_wire_cke,
	sdram_controller_0_wire_cs_n,
	sdram_controller_0_wire_dq,
	sdram_controller_0_wire_dqm,
	sdram_controller_0_wire_ras_n,
	sdram_controller_0_wire_we_n,
	switches_external_connection_export,
	sys_sdram_pll_0_sdram_clk_clk);	

	input		clk_clk;
	output	[6:0]	hex_0_external_connection_export;
	output	[6:0]	hex_1_external_connection_export;
	output	[6:0]	hex_2_external_connection_export;
	output	[6:0]	hex_3_external_connection_export;
	output	[6:0]	hex_4_external_connection_export;
	output	[6:0]	hex_5_external_connection_export;
	output	[14:0]	hps_0_ddr_mem_a;
	output	[2:0]	hps_0_ddr_mem_ba;
	output		hps_0_ddr_mem_ck;
	output		hps_0_ddr_mem_ck_n;
	output		hps_0_ddr_mem_cke;
	output		hps_0_ddr_mem_cs_n;
	output		hps_0_ddr_mem_ras_n;
	output		hps_0_ddr_mem_cas_n;
	output		hps_0_ddr_mem_we_n;
	output		hps_0_ddr_mem_reset_n;
	inout	[31:0]	hps_0_ddr_mem_dq;
	inout	[3:0]	hps_0_ddr_mem_dqs;
	inout	[3:0]	hps_0_ddr_mem_dqs_n;
	output		hps_0_ddr_mem_odt;
	output	[3:0]	hps_0_ddr_mem_dm;
	input		hps_0_ddr_oct_rzqin;
	output		hps_io_0_hps_io_emac1_inst_TX_CLK;
	output		hps_io_0_hps_io_emac1_inst_TXD0;
	output		hps_io_0_hps_io_emac1_inst_TXD1;
	output		hps_io_0_hps_io_emac1_inst_TXD2;
	output		hps_io_0_hps_io_emac1_inst_TXD3;
	input		hps_io_0_hps_io_emac1_inst_RXD0;
	inout		hps_io_0_hps_io_emac1_inst_MDIO;
	output		hps_io_0_hps_io_emac1_inst_MDC;
	input		hps_io_0_hps_io_emac1_inst_RX_CTL;
	output		hps_io_0_hps_io_emac1_inst_TX_CTL;
	input		hps_io_0_hps_io_emac1_inst_RX_CLK;
	input		hps_io_0_hps_io_emac1_inst_RXD1;
	input		hps_io_0_hps_io_emac1_inst_RXD2;
	input		hps_io_0_hps_io_emac1_inst_RXD3;
	inout		hps_io_0_hps_io_qspi_inst_IO0;
	inout		hps_io_0_hps_io_qspi_inst_IO1;
	inout		hps_io_0_hps_io_qspi_inst_IO2;
	inout		hps_io_0_hps_io_qspi_inst_IO3;
	output		hps_io_0_hps_io_qspi_inst_SS0;
	output		hps_io_0_hps_io_qspi_inst_CLK;
	inout		hps_io_0_hps_io_sdio_inst_CMD;
	inout		hps_io_0_hps_io_sdio_inst_D0;
	inout		hps_io_0_hps_io_sdio_inst_D1;
	output		hps_io_0_hps_io_sdio_inst_CLK;
	inout		hps_io_0_hps_io_sdio_inst_D2;
	inout		hps_io_0_hps_io_sdio_inst_D3;
	inout		hps_io_0_hps_io_usb1_inst_D0;
	inout		hps_io_0_hps_io_usb1_inst_D1;
	inout		hps_io_0_hps_io_usb1_inst_D2;
	inout		hps_io_0_hps_io_usb1_inst_D3;
	inout		hps_io_0_hps_io_usb1_inst_D4;
	inout		hps_io_0_hps_io_usb1_inst_D5;
	inout		hps_io_0_hps_io_usb1_inst_D6;
	inout		hps_io_0_hps_io_usb1_inst_D7;
	input		hps_io_0_hps_io_usb1_inst_CLK;
	output		hps_io_0_hps_io_usb1_inst_STP;
	input		hps_io_0_hps_io_usb1_inst_DIR;
	input		hps_io_0_hps_io_usb1_inst_NXT;
	output		hps_io_0_hps_io_spim1_inst_CLK;
	output		hps_io_0_hps_io_spim1_inst_MOSI;
	input		hps_io_0_hps_io_spim1_inst_MISO;
	output		hps_io_0_hps_io_spim1_inst_SS0;
	input		hps_io_0_hps_io_uart0_inst_RX;
	output		hps_io_0_hps_io_uart0_inst_TX;
	inout		hps_io_0_hps_io_i2c0_inst_SDA;
	inout		hps_io_0_hps_io_i2c0_inst_SCL;
	inout		hps_io_0_hps_io_i2c1_inst_SDA;
	inout		hps_io_0_hps_io_i2c1_inst_SCL;
	input	[3:0]	keys_external_connection_export;
	output	[9:0]	plasma_soc_0_leds_ld;
	output		plasma_soc_0_sd_card_spi_cs;
	input		plasma_soc_0_sd_card_spi_miso;
	output		plasma_soc_0_sd_card_spi_mosi;
	output		plasma_soc_0_sd_card_spi_sclk;
	input	[9:0]	plasma_soc_0_switches_sw;
	input		plasma_soc_0_uart_uart_rx;
	output		plasma_soc_0_uart_uart_tx;
	output	[12:0]	sdram_controller_0_wire_addr;
	output	[1:0]	sdram_controller_0_wire_ba;
	output		sdram_controller_0_wire_cas_n;
	output		sdram_controller_0_wire_cke;
	output		sdram_controller_0_wire_cs_n;
	inout	[15:0]	sdram_controller_0_wire_dq;
	output	[1:0]	sdram_controller_0_wire_dqm;
	output		sdram_controller_0_wire_ras_n;
	output		sdram_controller_0_wire_we_n;
	input	[9:0]	switches_external_connection_export;
	output		sys_sdram_pll_0_sdram_clk_clk;
endmodule
