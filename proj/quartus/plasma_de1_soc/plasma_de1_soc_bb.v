
module plasma_de1_soc (
	clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	plasma_soc_0_leds_ld,
	plasma_soc_0_sd_card_sd_cd,
	plasma_soc_0_sd_card_sd_spi_cs,
	plasma_soc_0_sd_card_sd_spi_miso,
	plasma_soc_0_sd_card_sd_spi_mosi,
	plasma_soc_0_sd_card_sd_spi_sclk,
	plasma_soc_0_sd_card_sd_wp,
	plasma_soc_0_switches_sw,
	plasma_soc_0_uart_uart_rx,
	plasma_soc_0_uart_uart_tx);	

	input		clk_clk;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
	output	[7:0]	plasma_soc_0_leds_ld;
	input		plasma_soc_0_sd_card_sd_cd;
	output		plasma_soc_0_sd_card_sd_spi_cs;
	input		plasma_soc_0_sd_card_sd_spi_miso;
	output		plasma_soc_0_sd_card_sd_spi_mosi;
	output		plasma_soc_0_sd_card_sd_spi_sclk;
	input		plasma_soc_0_sd_card_sd_wp;
	input	[7:0]	plasma_soc_0_switches_sw;
	input		plasma_soc_0_uart_uart_rx;
	output		plasma_soc_0_uart_uart_tx;
endmodule
