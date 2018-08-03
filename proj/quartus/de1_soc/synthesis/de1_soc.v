// de1_soc.v

// Generated using ACDS version 18.0 614

`timescale 1 ps / 1 ps
module de1_soc (
		input  wire        clk_clk,                          //                       clk.clk
		output wire [6:0]  hex_0_external_connection_export, // hex_0_external_connection.export
		output wire [6:0]  hex_1_external_connection_export, // hex_1_external_connection.export
		output wire [6:0]  hex_2_external_connection_export, // hex_2_external_connection.export
		output wire [6:0]  hex_3_external_connection_export, // hex_3_external_connection.export
		output wire [6:0]  hex_4_external_connection_export, // hex_4_external_connection.export
		output wire [6:0]  hex_5_external_connection_export, // hex_5_external_connection.export
		output wire [14:0] hps_0_ddr_mem_a,                  //                 hps_0_ddr.mem_a
		output wire [2:0]  hps_0_ddr_mem_ba,                 //                          .mem_ba
		output wire        hps_0_ddr_mem_ck,                 //                          .mem_ck
		output wire        hps_0_ddr_mem_ck_n,               //                          .mem_ck_n
		output wire        hps_0_ddr_mem_cke,                //                          .mem_cke
		output wire        hps_0_ddr_mem_cs_n,               //                          .mem_cs_n
		output wire        hps_0_ddr_mem_ras_n,              //                          .mem_ras_n
		output wire        hps_0_ddr_mem_cas_n,              //                          .mem_cas_n
		output wire        hps_0_ddr_mem_we_n,               //                          .mem_we_n
		output wire        hps_0_ddr_mem_reset_n,            //                          .mem_reset_n
		inout  wire [31:0] hps_0_ddr_mem_dq,                 //                          .mem_dq
		inout  wire [3:0]  hps_0_ddr_mem_dqs,                //                          .mem_dqs
		inout  wire [3:0]  hps_0_ddr_mem_dqs_n,              //                          .mem_dqs_n
		output wire        hps_0_ddr_mem_odt,                //                          .mem_odt
		output wire [3:0]  hps_0_ddr_mem_dm,                 //                          .mem_dm
		input  wire        hps_0_ddr_oct_rzqin,              //                          .oct_rzqin
		output wire [9:0]  plasma_soc_0_leds_ld,             //         plasma_soc_0_leds.ld
		input  wire        plasma_soc_0_sd_card_sd_cd,       //      plasma_soc_0_sd_card.sd_cd
		output wire        plasma_soc_0_sd_card_sd_spi_cs,   //                          .sd_spi_cs
		input  wire        plasma_soc_0_sd_card_sd_spi_miso, //                          .sd_spi_miso
		output wire        plasma_soc_0_sd_card_sd_spi_mosi, //                          .sd_spi_mosi
		output wire        plasma_soc_0_sd_card_sd_spi_sclk, //                          .sd_spi_sclk
		input  wire        plasma_soc_0_sd_card_sd_wp,       //                          .sd_wp
		input  wire [9:0]  plasma_soc_0_switches_sw,         //     plasma_soc_0_switches.sw
		input  wire        plasma_soc_0_uart_uart_rx,        //         plasma_soc_0_uart.uart_rx
		output wire        plasma_soc_0_uart_uart_tx,        //                          .uart_tx
		output wire [12:0] sdram_controller_0_wire_addr,     //   sdram_controller_0_wire.addr
		output wire [1:0]  sdram_controller_0_wire_ba,       //                          .ba
		output wire        sdram_controller_0_wire_cas_n,    //                          .cas_n
		output wire        sdram_controller_0_wire_cke,      //                          .cke
		output wire        sdram_controller_0_wire_cs_n,     //                          .cs_n
		inout  wire [15:0] sdram_controller_0_wire_dq,       //                          .dq
		output wire [1:0]  sdram_controller_0_wire_dqm,      //                          .dqm
		output wire        sdram_controller_0_wire_ras_n,    //                          .ras_n
		output wire        sdram_controller_0_wire_we_n,     //                          .we_n
		output wire        sys_sdram_pll_0_sdram_clk_clk     // sys_sdram_pll_0_sdram_clk.clk
	);

	wire         sys_sdram_pll_0_sys_clk_clk;                           // sys_sdram_pll_0:sys_clk_clk -> [hex_0:clk, hex_1:clk, hex_2:clk, hex_3:clk, hex_4:clk, hex_5:clk, hps_0:f2h_axi_clk, hps_0:h2f_axi_clk, mm_interconnect_0:sys_sdram_pll_0_sys_clk_clk, plasma_soc_0:GCLK, rst_controller:clk, sdram_controller_0:clk]
	wire         hps_0_h2f_reset_reset;                                 // hps_0:h2f_rst_n -> sys_sdram_pll_0:ref_reset_reset
	wire         plasma_soc_0_avalon_master_0_waitrequest;              // mm_interconnect_0:plasma_soc_0_avalon_master_0_waitrequest -> plasma_soc_0:avm_waitrequest_n
	wire  [31:0] plasma_soc_0_avalon_master_0_readdata;                 // mm_interconnect_0:plasma_soc_0_avalon_master_0_readdata -> plasma_soc_0:avm_readdata
	wire  [31:0] plasma_soc_0_avalon_master_0_address;                  // plasma_soc_0:avm_address -> mm_interconnect_0:plasma_soc_0_avalon_master_0_address
	wire   [3:0] plasma_soc_0_avalon_master_0_byteenable;               // plasma_soc_0:avm_byteenable -> mm_interconnect_0:plasma_soc_0_avalon_master_0_byteenable
	wire         plasma_soc_0_avalon_master_0_read;                     // plasma_soc_0:avm_read -> mm_interconnect_0:plasma_soc_0_avalon_master_0_read
	wire   [1:0] plasma_soc_0_avalon_master_0_response;                 // mm_interconnect_0:plasma_soc_0_avalon_master_0_response -> plasma_soc_0:avm_response
	wire         plasma_soc_0_avalon_master_0_write;                    // plasma_soc_0:avm_write -> mm_interconnect_0:plasma_soc_0_avalon_master_0_write
	wire  [31:0] plasma_soc_0_avalon_master_0_writedata;                // plasma_soc_0:avm_writedata -> mm_interconnect_0:plasma_soc_0_avalon_master_0_writedata
	wire         mm_interconnect_0_sdram_controller_0_s1_chipselect;    // mm_interconnect_0:sdram_controller_0_s1_chipselect -> sdram_controller_0:az_cs
	wire  [15:0] mm_interconnect_0_sdram_controller_0_s1_readdata;      // sdram_controller_0:za_data -> mm_interconnect_0:sdram_controller_0_s1_readdata
	wire         mm_interconnect_0_sdram_controller_0_s1_waitrequest;   // sdram_controller_0:za_waitrequest -> mm_interconnect_0:sdram_controller_0_s1_waitrequest
	wire  [24:0] mm_interconnect_0_sdram_controller_0_s1_address;       // mm_interconnect_0:sdram_controller_0_s1_address -> sdram_controller_0:az_addr
	wire         mm_interconnect_0_sdram_controller_0_s1_read;          // mm_interconnect_0:sdram_controller_0_s1_read -> sdram_controller_0:az_rd_n
	wire   [1:0] mm_interconnect_0_sdram_controller_0_s1_byteenable;    // mm_interconnect_0:sdram_controller_0_s1_byteenable -> sdram_controller_0:az_be_n
	wire         mm_interconnect_0_sdram_controller_0_s1_readdatavalid; // sdram_controller_0:za_valid -> mm_interconnect_0:sdram_controller_0_s1_readdatavalid
	wire         mm_interconnect_0_sdram_controller_0_s1_write;         // mm_interconnect_0:sdram_controller_0_s1_write -> sdram_controller_0:az_wr_n
	wire  [15:0] mm_interconnect_0_sdram_controller_0_s1_writedata;     // mm_interconnect_0:sdram_controller_0_s1_writedata -> sdram_controller_0:az_data
	wire         mm_interconnect_0_hex_0_s1_chipselect;                 // mm_interconnect_0:hex_0_s1_chipselect -> hex_0:chipselect
	wire  [31:0] mm_interconnect_0_hex_0_s1_readdata;                   // hex_0:readdata -> mm_interconnect_0:hex_0_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_0_s1_address;                    // mm_interconnect_0:hex_0_s1_address -> hex_0:address
	wire         mm_interconnect_0_hex_0_s1_write;                      // mm_interconnect_0:hex_0_s1_write -> hex_0:write_n
	wire  [31:0] mm_interconnect_0_hex_0_s1_writedata;                  // mm_interconnect_0:hex_0_s1_writedata -> hex_0:writedata
	wire         mm_interconnect_0_hex_1_s1_chipselect;                 // mm_interconnect_0:hex_1_s1_chipselect -> hex_1:chipselect
	wire  [31:0] mm_interconnect_0_hex_1_s1_readdata;                   // hex_1:readdata -> mm_interconnect_0:hex_1_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_1_s1_address;                    // mm_interconnect_0:hex_1_s1_address -> hex_1:address
	wire         mm_interconnect_0_hex_1_s1_write;                      // mm_interconnect_0:hex_1_s1_write -> hex_1:write_n
	wire  [31:0] mm_interconnect_0_hex_1_s1_writedata;                  // mm_interconnect_0:hex_1_s1_writedata -> hex_1:writedata
	wire         mm_interconnect_0_hex_2_s1_chipselect;                 // mm_interconnect_0:hex_2_s1_chipselect -> hex_2:chipselect
	wire  [31:0] mm_interconnect_0_hex_2_s1_readdata;                   // hex_2:readdata -> mm_interconnect_0:hex_2_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_2_s1_address;                    // mm_interconnect_0:hex_2_s1_address -> hex_2:address
	wire         mm_interconnect_0_hex_2_s1_write;                      // mm_interconnect_0:hex_2_s1_write -> hex_2:write_n
	wire  [31:0] mm_interconnect_0_hex_2_s1_writedata;                  // mm_interconnect_0:hex_2_s1_writedata -> hex_2:writedata
	wire         mm_interconnect_0_hex_3_s1_chipselect;                 // mm_interconnect_0:hex_3_s1_chipselect -> hex_3:chipselect
	wire  [31:0] mm_interconnect_0_hex_3_s1_readdata;                   // hex_3:readdata -> mm_interconnect_0:hex_3_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_3_s1_address;                    // mm_interconnect_0:hex_3_s1_address -> hex_3:address
	wire         mm_interconnect_0_hex_3_s1_write;                      // mm_interconnect_0:hex_3_s1_write -> hex_3:write_n
	wire  [31:0] mm_interconnect_0_hex_3_s1_writedata;                  // mm_interconnect_0:hex_3_s1_writedata -> hex_3:writedata
	wire         mm_interconnect_0_hex_4_s1_chipselect;                 // mm_interconnect_0:hex_4_s1_chipselect -> hex_4:chipselect
	wire  [31:0] mm_interconnect_0_hex_4_s1_readdata;                   // hex_4:readdata -> mm_interconnect_0:hex_4_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_4_s1_address;                    // mm_interconnect_0:hex_4_s1_address -> hex_4:address
	wire         mm_interconnect_0_hex_4_s1_write;                      // mm_interconnect_0:hex_4_s1_write -> hex_4:write_n
	wire  [31:0] mm_interconnect_0_hex_4_s1_writedata;                  // mm_interconnect_0:hex_4_s1_writedata -> hex_4:writedata
	wire         mm_interconnect_0_hex_5_s1_chipselect;                 // mm_interconnect_0:hex_5_s1_chipselect -> hex_5:chipselect
	wire  [31:0] mm_interconnect_0_hex_5_s1_readdata;                   // hex_5:readdata -> mm_interconnect_0:hex_5_s1_readdata
	wire   [1:0] mm_interconnect_0_hex_5_s1_address;                    // mm_interconnect_0:hex_5_s1_address -> hex_5:address
	wire         mm_interconnect_0_hex_5_s1_write;                      // mm_interconnect_0:hex_5_s1_write -> hex_5:write_n
	wire  [31:0] mm_interconnect_0_hex_5_s1_writedata;                  // mm_interconnect_0:hex_5_s1_writedata -> hex_5:writedata
	wire         rst_controller_reset_out_reset;                        // rst_controller:reset_out -> [hex_0:reset_n, hex_1:reset_n, hex_2:reset_n, hex_3:reset_n, hex_4:reset_n, hex_5:reset_n, mm_interconnect_0:plasma_soc_0_reset_sink_reset_bridge_in_reset_reset, plasma_soc_0:RST, sdram_controller_0:reset_n]
	wire         sys_sdram_pll_0_reset_source_reset;                    // sys_sdram_pll_0:reset_source_reset -> rst_controller:reset_in0

	de1_soc_hex_0 hex_0 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_0_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_0_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_0_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_0_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_0_s1_readdata),   //                    .readdata
		.out_port   (hex_0_external_connection_export)       // external_connection.export
	);

	de1_soc_hex_0 hex_1 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_1_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_1_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_1_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_1_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_1_s1_readdata),   //                    .readdata
		.out_port   (hex_1_external_connection_export)       // external_connection.export
	);

	de1_soc_hex_0 hex_2 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_2_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_2_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_2_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_2_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_2_s1_readdata),   //                    .readdata
		.out_port   (hex_2_external_connection_export)       // external_connection.export
	);

	de1_soc_hex_0 hex_3 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_3_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_3_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_3_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_3_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_3_s1_readdata),   //                    .readdata
		.out_port   (hex_3_external_connection_export)       // external_connection.export
	);

	de1_soc_hex_0 hex_4 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_4_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_4_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_4_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_4_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_4_s1_readdata),   //                    .readdata
		.out_port   (hex_4_external_connection_export)       // external_connection.export
	);

	de1_soc_hex_0 hex_5 (
		.clk        (sys_sdram_pll_0_sys_clk_clk),           //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),       //               reset.reset_n
		.address    (mm_interconnect_0_hex_5_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_hex_5_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_hex_5_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_hex_5_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_hex_5_s1_readdata),   //                    .readdata
		.out_port   (hex_5_external_connection_export)       // external_connection.export
	);

	de1_soc_hps_0 #(
		.F2S_Width (3),
		.S2F_Width (3)
	) hps_0 (
		.mem_a       (hps_0_ddr_mem_a),             //         memory.mem_a
		.mem_ba      (hps_0_ddr_mem_ba),            //               .mem_ba
		.mem_ck      (hps_0_ddr_mem_ck),            //               .mem_ck
		.mem_ck_n    (hps_0_ddr_mem_ck_n),          //               .mem_ck_n
		.mem_cke     (hps_0_ddr_mem_cke),           //               .mem_cke
		.mem_cs_n    (hps_0_ddr_mem_cs_n),          //               .mem_cs_n
		.mem_ras_n   (hps_0_ddr_mem_ras_n),         //               .mem_ras_n
		.mem_cas_n   (hps_0_ddr_mem_cas_n),         //               .mem_cas_n
		.mem_we_n    (hps_0_ddr_mem_we_n),          //               .mem_we_n
		.mem_reset_n (hps_0_ddr_mem_reset_n),       //               .mem_reset_n
		.mem_dq      (hps_0_ddr_mem_dq),            //               .mem_dq
		.mem_dqs     (hps_0_ddr_mem_dqs),           //               .mem_dqs
		.mem_dqs_n   (hps_0_ddr_mem_dqs_n),         //               .mem_dqs_n
		.mem_odt     (hps_0_ddr_mem_odt),           //               .mem_odt
		.mem_dm      (hps_0_ddr_mem_dm),            //               .mem_dm
		.oct_rzqin   (hps_0_ddr_oct_rzqin),         //               .oct_rzqin
		.h2f_rst_n   (hps_0_h2f_reset_reset),       //      h2f_reset.reset_n
		.h2f_axi_clk (sys_sdram_pll_0_sys_clk_clk), //  h2f_axi_clock.clk
		.h2f_AWID    (),                            // h2f_axi_master.awid
		.h2f_AWADDR  (),                            //               .awaddr
		.h2f_AWLEN   (),                            //               .awlen
		.h2f_AWSIZE  (),                            //               .awsize
		.h2f_AWBURST (),                            //               .awburst
		.h2f_AWLOCK  (),                            //               .awlock
		.h2f_AWCACHE (),                            //               .awcache
		.h2f_AWPROT  (),                            //               .awprot
		.h2f_AWVALID (),                            //               .awvalid
		.h2f_AWREADY (),                            //               .awready
		.h2f_WID     (),                            //               .wid
		.h2f_WDATA   (),                            //               .wdata
		.h2f_WSTRB   (),                            //               .wstrb
		.h2f_WLAST   (),                            //               .wlast
		.h2f_WVALID  (),                            //               .wvalid
		.h2f_WREADY  (),                            //               .wready
		.h2f_BID     (),                            //               .bid
		.h2f_BRESP   (),                            //               .bresp
		.h2f_BVALID  (),                            //               .bvalid
		.h2f_BREADY  (),                            //               .bready
		.h2f_ARID    (),                            //               .arid
		.h2f_ARADDR  (),                            //               .araddr
		.h2f_ARLEN   (),                            //               .arlen
		.h2f_ARSIZE  (),                            //               .arsize
		.h2f_ARBURST (),                            //               .arburst
		.h2f_ARLOCK  (),                            //               .arlock
		.h2f_ARCACHE (),                            //               .arcache
		.h2f_ARPROT  (),                            //               .arprot
		.h2f_ARVALID (),                            //               .arvalid
		.h2f_ARREADY (),                            //               .arready
		.h2f_RID     (),                            //               .rid
		.h2f_RDATA   (),                            //               .rdata
		.h2f_RRESP   (),                            //               .rresp
		.h2f_RLAST   (),                            //               .rlast
		.h2f_RVALID  (),                            //               .rvalid
		.h2f_RREADY  (),                            //               .rready
		.f2h_axi_clk (sys_sdram_pll_0_sys_clk_clk), //  f2h_axi_clock.clk
		.f2h_AWID    (),                            //  f2h_axi_slave.awid
		.f2h_AWADDR  (),                            //               .awaddr
		.f2h_AWLEN   (),                            //               .awlen
		.f2h_AWSIZE  (),                            //               .awsize
		.f2h_AWBURST (),                            //               .awburst
		.f2h_AWLOCK  (),                            //               .awlock
		.f2h_AWCACHE (),                            //               .awcache
		.f2h_AWPROT  (),                            //               .awprot
		.f2h_AWVALID (),                            //               .awvalid
		.f2h_AWREADY (),                            //               .awready
		.f2h_AWUSER  (),                            //               .awuser
		.f2h_WID     (),                            //               .wid
		.f2h_WDATA   (),                            //               .wdata
		.f2h_WSTRB   (),                            //               .wstrb
		.f2h_WLAST   (),                            //               .wlast
		.f2h_WVALID  (),                            //               .wvalid
		.f2h_WREADY  (),                            //               .wready
		.f2h_BID     (),                            //               .bid
		.f2h_BRESP   (),                            //               .bresp
		.f2h_BVALID  (),                            //               .bvalid
		.f2h_BREADY  (),                            //               .bready
		.f2h_ARID    (),                            //               .arid
		.f2h_ARADDR  (),                            //               .araddr
		.f2h_ARLEN   (),                            //               .arlen
		.f2h_ARSIZE  (),                            //               .arsize
		.f2h_ARBURST (),                            //               .arburst
		.f2h_ARLOCK  (),                            //               .arlock
		.f2h_ARCACHE (),                            //               .arcache
		.f2h_ARPROT  (),                            //               .arprot
		.f2h_ARVALID (),                            //               .arvalid
		.f2h_ARREADY (),                            //               .arready
		.f2h_ARUSER  (),                            //               .aruser
		.f2h_RID     (),                            //               .rid
		.f2h_RDATA   (),                            //               .rdata
		.f2h_RRESP   (),                            //               .rresp
		.f2h_RLAST   (),                            //               .rlast
		.f2h_RVALID  (),                            //               .rvalid
		.f2h_RREADY  ()                             //               .rready
	);

	plasma_soc_top plasma_soc_0 (
		.RST               (rst_controller_reset_out_reset),            //      reset_sink.reset
		.GCLK              (sys_sdram_pll_0_sys_clk_clk),               //      clock_sink.clk
		.LD                (plasma_soc_0_leds_ld),                      //            leds.ld
		.SD_CD             (plasma_soc_0_sd_card_sd_cd),                //         sd_card.sd_cd
		.SD_SPI_CS         (plasma_soc_0_sd_card_sd_spi_cs),            //                .sd_spi_cs
		.SD_SPI_MISO       (plasma_soc_0_sd_card_sd_spi_miso),          //                .sd_spi_miso
		.SD_SPI_MOSI       (plasma_soc_0_sd_card_sd_spi_mosi),          //                .sd_spi_mosi
		.SD_SPI_SCLK       (plasma_soc_0_sd_card_sd_spi_sclk),          //                .sd_spi_sclk
		.SD_WP             (plasma_soc_0_sd_card_sd_wp),                //                .sd_wp
		.SW                (plasma_soc_0_switches_sw),                  //        switches.sw
		.UART_RX           (plasma_soc_0_uart_uart_rx),                 //            uart.uart_rx
		.UART_TX           (plasma_soc_0_uart_uart_tx),                 //                .uart_tx
		.avs_waitrequest_n (),                                          //  avalon_slave_0.waitrequest_n
		.avs_response      (),                                          //                .response
		.avs_address       (),                                          //                .address
		.avs_byteenable    (),                                          //                .byteenable
		.avs_read          (),                                          //                .read
		.avs_readdata      (),                                          //                .readdata
		.avs_write         (),                                          //                .write
		.avs_writedata     (),                                          //                .writedata
		.avm_waitrequest_n (~plasma_soc_0_avalon_master_0_waitrequest), // avalon_master_0.waitrequest_n
		.avm_response      (plasma_soc_0_avalon_master_0_response),     //                .response
		.avm_address       (plasma_soc_0_avalon_master_0_address),      //                .address
		.avm_byteenable    (plasma_soc_0_avalon_master_0_byteenable),   //                .byteenable
		.avm_read          (plasma_soc_0_avalon_master_0_read),         //                .read
		.avm_readdata      (plasma_soc_0_avalon_master_0_readdata),     //                .readdata
		.avm_write         (plasma_soc_0_avalon_master_0_write),        //                .write
		.avm_writedata     (plasma_soc_0_avalon_master_0_writedata)     //                .writedata
	);

	de1_soc_sdram_controller_0 sdram_controller_0 (
		.clk            (sys_sdram_pll_0_sys_clk_clk),                           //   clk.clk
		.reset_n        (~rst_controller_reset_out_reset),                       // reset.reset_n
		.az_addr        (mm_interconnect_0_sdram_controller_0_s1_address),       //    s1.address
		.az_be_n        (~mm_interconnect_0_sdram_controller_0_s1_byteenable),   //      .byteenable_n
		.az_cs          (mm_interconnect_0_sdram_controller_0_s1_chipselect),    //      .chipselect
		.az_data        (mm_interconnect_0_sdram_controller_0_s1_writedata),     //      .writedata
		.az_rd_n        (~mm_interconnect_0_sdram_controller_0_s1_read),         //      .read_n
		.az_wr_n        (~mm_interconnect_0_sdram_controller_0_s1_write),        //      .write_n
		.za_data        (mm_interconnect_0_sdram_controller_0_s1_readdata),      //      .readdata
		.za_valid       (mm_interconnect_0_sdram_controller_0_s1_readdatavalid), //      .readdatavalid
		.za_waitrequest (mm_interconnect_0_sdram_controller_0_s1_waitrequest),   //      .waitrequest
		.zs_addr        (sdram_controller_0_wire_addr),                          //  wire.export
		.zs_ba          (sdram_controller_0_wire_ba),                            //      .export
		.zs_cas_n       (sdram_controller_0_wire_cas_n),                         //      .export
		.zs_cke         (sdram_controller_0_wire_cke),                           //      .export
		.zs_cs_n        (sdram_controller_0_wire_cs_n),                          //      .export
		.zs_dq          (sdram_controller_0_wire_dq),                            //      .export
		.zs_dqm         (sdram_controller_0_wire_dqm),                           //      .export
		.zs_ras_n       (sdram_controller_0_wire_ras_n),                         //      .export
		.zs_we_n        (sdram_controller_0_wire_we_n)                           //      .export
	);

	de1_soc_sys_sdram_pll_0 sys_sdram_pll_0 (
		.ref_clk_clk        (clk_clk),                            //      ref_clk.clk
		.ref_reset_reset    (~hps_0_h2f_reset_reset),             //    ref_reset.reset
		.sys_clk_clk        (sys_sdram_pll_0_sys_clk_clk),        //      sys_clk.clk
		.sdram_clk_clk      (sys_sdram_pll_0_sdram_clk_clk),      //    sdram_clk.clk
		.reset_source_reset (sys_sdram_pll_0_reset_source_reset)  // reset_source.reset
	);

	de1_soc_mm_interconnect_0 mm_interconnect_0 (
		.sys_sdram_pll_0_sys_clk_clk                         (sys_sdram_pll_0_sys_clk_clk),                           //                       sys_sdram_pll_0_sys_clk.clk
		.plasma_soc_0_reset_sink_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                        // plasma_soc_0_reset_sink_reset_bridge_in_reset.reset
		.plasma_soc_0_avalon_master_0_address                (plasma_soc_0_avalon_master_0_address),                  //                  plasma_soc_0_avalon_master_0.address
		.plasma_soc_0_avalon_master_0_waitrequest            (plasma_soc_0_avalon_master_0_waitrequest),              //                                              .waitrequest
		.plasma_soc_0_avalon_master_0_byteenable             (plasma_soc_0_avalon_master_0_byteenable),               //                                              .byteenable
		.plasma_soc_0_avalon_master_0_read                   (plasma_soc_0_avalon_master_0_read),                     //                                              .read
		.plasma_soc_0_avalon_master_0_readdata               (plasma_soc_0_avalon_master_0_readdata),                 //                                              .readdata
		.plasma_soc_0_avalon_master_0_write                  (plasma_soc_0_avalon_master_0_write),                    //                                              .write
		.plasma_soc_0_avalon_master_0_writedata              (plasma_soc_0_avalon_master_0_writedata),                //                                              .writedata
		.plasma_soc_0_avalon_master_0_response               (plasma_soc_0_avalon_master_0_response),                 //                                              .response
		.hex_0_s1_address                                    (mm_interconnect_0_hex_0_s1_address),                    //                                      hex_0_s1.address
		.hex_0_s1_write                                      (mm_interconnect_0_hex_0_s1_write),                      //                                              .write
		.hex_0_s1_readdata                                   (mm_interconnect_0_hex_0_s1_readdata),                   //                                              .readdata
		.hex_0_s1_writedata                                  (mm_interconnect_0_hex_0_s1_writedata),                  //                                              .writedata
		.hex_0_s1_chipselect                                 (mm_interconnect_0_hex_0_s1_chipselect),                 //                                              .chipselect
		.hex_1_s1_address                                    (mm_interconnect_0_hex_1_s1_address),                    //                                      hex_1_s1.address
		.hex_1_s1_write                                      (mm_interconnect_0_hex_1_s1_write),                      //                                              .write
		.hex_1_s1_readdata                                   (mm_interconnect_0_hex_1_s1_readdata),                   //                                              .readdata
		.hex_1_s1_writedata                                  (mm_interconnect_0_hex_1_s1_writedata),                  //                                              .writedata
		.hex_1_s1_chipselect                                 (mm_interconnect_0_hex_1_s1_chipselect),                 //                                              .chipselect
		.hex_2_s1_address                                    (mm_interconnect_0_hex_2_s1_address),                    //                                      hex_2_s1.address
		.hex_2_s1_write                                      (mm_interconnect_0_hex_2_s1_write),                      //                                              .write
		.hex_2_s1_readdata                                   (mm_interconnect_0_hex_2_s1_readdata),                   //                                              .readdata
		.hex_2_s1_writedata                                  (mm_interconnect_0_hex_2_s1_writedata),                  //                                              .writedata
		.hex_2_s1_chipselect                                 (mm_interconnect_0_hex_2_s1_chipselect),                 //                                              .chipselect
		.hex_3_s1_address                                    (mm_interconnect_0_hex_3_s1_address),                    //                                      hex_3_s1.address
		.hex_3_s1_write                                      (mm_interconnect_0_hex_3_s1_write),                      //                                              .write
		.hex_3_s1_readdata                                   (mm_interconnect_0_hex_3_s1_readdata),                   //                                              .readdata
		.hex_3_s1_writedata                                  (mm_interconnect_0_hex_3_s1_writedata),                  //                                              .writedata
		.hex_3_s1_chipselect                                 (mm_interconnect_0_hex_3_s1_chipselect),                 //                                              .chipselect
		.hex_4_s1_address                                    (mm_interconnect_0_hex_4_s1_address),                    //                                      hex_4_s1.address
		.hex_4_s1_write                                      (mm_interconnect_0_hex_4_s1_write),                      //                                              .write
		.hex_4_s1_readdata                                   (mm_interconnect_0_hex_4_s1_readdata),                   //                                              .readdata
		.hex_4_s1_writedata                                  (mm_interconnect_0_hex_4_s1_writedata),                  //                                              .writedata
		.hex_4_s1_chipselect                                 (mm_interconnect_0_hex_4_s1_chipselect),                 //                                              .chipselect
		.hex_5_s1_address                                    (mm_interconnect_0_hex_5_s1_address),                    //                                      hex_5_s1.address
		.hex_5_s1_write                                      (mm_interconnect_0_hex_5_s1_write),                      //                                              .write
		.hex_5_s1_readdata                                   (mm_interconnect_0_hex_5_s1_readdata),                   //                                              .readdata
		.hex_5_s1_writedata                                  (mm_interconnect_0_hex_5_s1_writedata),                  //                                              .writedata
		.hex_5_s1_chipselect                                 (mm_interconnect_0_hex_5_s1_chipselect),                 //                                              .chipselect
		.sdram_controller_0_s1_address                       (mm_interconnect_0_sdram_controller_0_s1_address),       //                         sdram_controller_0_s1.address
		.sdram_controller_0_s1_write                         (mm_interconnect_0_sdram_controller_0_s1_write),         //                                              .write
		.sdram_controller_0_s1_read                          (mm_interconnect_0_sdram_controller_0_s1_read),          //                                              .read
		.sdram_controller_0_s1_readdata                      (mm_interconnect_0_sdram_controller_0_s1_readdata),      //                                              .readdata
		.sdram_controller_0_s1_writedata                     (mm_interconnect_0_sdram_controller_0_s1_writedata),     //                                              .writedata
		.sdram_controller_0_s1_byteenable                    (mm_interconnect_0_sdram_controller_0_s1_byteenable),    //                                              .byteenable
		.sdram_controller_0_s1_readdatavalid                 (mm_interconnect_0_sdram_controller_0_s1_readdatavalid), //                                              .readdatavalid
		.sdram_controller_0_s1_waitrequest                   (mm_interconnect_0_sdram_controller_0_s1_waitrequest),   //                                              .waitrequest
		.sdram_controller_0_s1_chipselect                    (mm_interconnect_0_sdram_controller_0_s1_chipselect)     //                                              .chipselect
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (sys_sdram_pll_0_reset_source_reset), // reset_in0.reset
		.clk            (sys_sdram_pll_0_sys_clk_clk),        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (),                                   // (terminated)
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
