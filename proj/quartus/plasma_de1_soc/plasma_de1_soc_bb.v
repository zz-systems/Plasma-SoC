
module plasma_de1_soc (
	clk_clk,
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
	plasma_soc_0_leds_ld,
	plasma_soc_0_sd_card_sd_cd,
	plasma_soc_0_sd_card_sd_spi_cs,
	plasma_soc_0_sd_card_sd_spi_miso,
	plasma_soc_0_sd_card_sd_spi_mosi,
	plasma_soc_0_sd_card_sd_spi_sclk,
	plasma_soc_0_sd_card_sd_wp,
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
	sys_sdram_pll_0_sdram_clk_clk);	

	input		clk_clk;
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
	output	[9:0]	plasma_soc_0_leds_ld;
	input		plasma_soc_0_sd_card_sd_cd;
	output		plasma_soc_0_sd_card_sd_spi_cs;
	input		plasma_soc_0_sd_card_sd_spi_miso;
	output		plasma_soc_0_sd_card_sd_spi_mosi;
	output		plasma_soc_0_sd_card_sd_spi_sclk;
	input		plasma_soc_0_sd_card_sd_wp;
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
	output		sys_sdram_pll_0_sdram_clk_clk;
endmodule
