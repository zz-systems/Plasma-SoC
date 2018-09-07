// de1_soc_hps_0.v

// This file was auto-generated from altera_hps_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 13.1 162 at 2018.09.07.06:20:34

`timescale 1 ps / 1 ps
module de1_soc_hps_0 #(
		parameter F2S_Width = 3,
		parameter S2F_Width = 3
	) (
		output wire         h2f_rst_n,                //           h2f_reset.reset_n
		input  wire         f2h_cold_rst_req_n,       //  f2h_cold_reset_req.reset_n
		input  wire         f2h_dbg_rst_req_n,        // f2h_debug_reset_req.reset_n
		input  wire         f2h_warm_rst_req_n,       //  f2h_warm_reset_req.reset_n
		input  wire         f2h_axi_clk,              //       f2h_axi_clock.clk
		input  wire [7:0]   f2h_AWID,                 //       f2h_axi_slave.awid
		input  wire [31:0]  f2h_AWADDR,               //                    .awaddr
		input  wire [3:0]   f2h_AWLEN,                //                    .awlen
		input  wire [2:0]   f2h_AWSIZE,               //                    .awsize
		input  wire [1:0]   f2h_AWBURST,              //                    .awburst
		input  wire [1:0]   f2h_AWLOCK,               //                    .awlock
		input  wire [3:0]   f2h_AWCACHE,              //                    .awcache
		input  wire [2:0]   f2h_AWPROT,               //                    .awprot
		input  wire         f2h_AWVALID,              //                    .awvalid
		output wire         f2h_AWREADY,              //                    .awready
		input  wire [4:0]   f2h_AWUSER,               //                    .awuser
		input  wire [7:0]   f2h_WID,                  //                    .wid
		input  wire [127:0] f2h_WDATA,                //                    .wdata
		input  wire [15:0]  f2h_WSTRB,                //                    .wstrb
		input  wire         f2h_WLAST,                //                    .wlast
		input  wire         f2h_WVALID,               //                    .wvalid
		output wire         f2h_WREADY,               //                    .wready
		output wire [7:0]   f2h_BID,                  //                    .bid
		output wire [1:0]   f2h_BRESP,                //                    .bresp
		output wire         f2h_BVALID,               //                    .bvalid
		input  wire         f2h_BREADY,               //                    .bready
		input  wire [7:0]   f2h_ARID,                 //                    .arid
		input  wire [31:0]  f2h_ARADDR,               //                    .araddr
		input  wire [3:0]   f2h_ARLEN,                //                    .arlen
		input  wire [2:0]   f2h_ARSIZE,               //                    .arsize
		input  wire [1:0]   f2h_ARBURST,              //                    .arburst
		input  wire [1:0]   f2h_ARLOCK,               //                    .arlock
		input  wire [3:0]   f2h_ARCACHE,              //                    .arcache
		input  wire [2:0]   f2h_ARPROT,               //                    .arprot
		input  wire         f2h_ARVALID,              //                    .arvalid
		output wire         f2h_ARREADY,              //                    .arready
		input  wire [4:0]   f2h_ARUSER,               //                    .aruser
		output wire [7:0]   f2h_RID,                  //                    .rid
		output wire [127:0] f2h_RDATA,                //                    .rdata
		output wire [1:0]   f2h_RRESP,                //                    .rresp
		output wire         f2h_RLAST,                //                    .rlast
		output wire         f2h_RVALID,               //                    .rvalid
		input  wire         f2h_RREADY,               //                    .rready
		input  wire         h2f_lw_axi_clk,           //    h2f_lw_axi_clock.clk
		output wire [11:0]  h2f_lw_AWID,              //   h2f_lw_axi_master.awid
		output wire [20:0]  h2f_lw_AWADDR,            //                    .awaddr
		output wire [3:0]   h2f_lw_AWLEN,             //                    .awlen
		output wire [2:0]   h2f_lw_AWSIZE,            //                    .awsize
		output wire [1:0]   h2f_lw_AWBURST,           //                    .awburst
		output wire [1:0]   h2f_lw_AWLOCK,            //                    .awlock
		output wire [3:0]   h2f_lw_AWCACHE,           //                    .awcache
		output wire [2:0]   h2f_lw_AWPROT,            //                    .awprot
		output wire         h2f_lw_AWVALID,           //                    .awvalid
		input  wire         h2f_lw_AWREADY,           //                    .awready
		output wire [11:0]  h2f_lw_WID,               //                    .wid
		output wire [31:0]  h2f_lw_WDATA,             //                    .wdata
		output wire [3:0]   h2f_lw_WSTRB,             //                    .wstrb
		output wire         h2f_lw_WLAST,             //                    .wlast
		output wire         h2f_lw_WVALID,            //                    .wvalid
		input  wire         h2f_lw_WREADY,            //                    .wready
		input  wire [11:0]  h2f_lw_BID,               //                    .bid
		input  wire [1:0]   h2f_lw_BRESP,             //                    .bresp
		input  wire         h2f_lw_BVALID,            //                    .bvalid
		output wire         h2f_lw_BREADY,            //                    .bready
		output wire [11:0]  h2f_lw_ARID,              //                    .arid
		output wire [20:0]  h2f_lw_ARADDR,            //                    .araddr
		output wire [3:0]   h2f_lw_ARLEN,             //                    .arlen
		output wire [2:0]   h2f_lw_ARSIZE,            //                    .arsize
		output wire [1:0]   h2f_lw_ARBURST,           //                    .arburst
		output wire [1:0]   h2f_lw_ARLOCK,            //                    .arlock
		output wire [3:0]   h2f_lw_ARCACHE,           //                    .arcache
		output wire [2:0]   h2f_lw_ARPROT,            //                    .arprot
		output wire         h2f_lw_ARVALID,           //                    .arvalid
		input  wire         h2f_lw_ARREADY,           //                    .arready
		input  wire [11:0]  h2f_lw_RID,               //                    .rid
		input  wire [31:0]  h2f_lw_RDATA,             //                    .rdata
		input  wire [1:0]   h2f_lw_RRESP,             //                    .rresp
		input  wire         h2f_lw_RLAST,             //                    .rlast
		input  wire         h2f_lw_RVALID,            //                    .rvalid
		output wire         h2f_lw_RREADY,            //                    .rready
		input  wire         h2f_axi_clk,              //       h2f_axi_clock.clk
		output wire [11:0]  h2f_AWID,                 //      h2f_axi_master.awid
		output wire [29:0]  h2f_AWADDR,               //                    .awaddr
		output wire [3:0]   h2f_AWLEN,                //                    .awlen
		output wire [2:0]   h2f_AWSIZE,               //                    .awsize
		output wire [1:0]   h2f_AWBURST,              //                    .awburst
		output wire [1:0]   h2f_AWLOCK,               //                    .awlock
		output wire [3:0]   h2f_AWCACHE,              //                    .awcache
		output wire [2:0]   h2f_AWPROT,               //                    .awprot
		output wire         h2f_AWVALID,              //                    .awvalid
		input  wire         h2f_AWREADY,              //                    .awready
		output wire [11:0]  h2f_WID,                  //                    .wid
		output wire [127:0] h2f_WDATA,                //                    .wdata
		output wire [15:0]  h2f_WSTRB,                //                    .wstrb
		output wire         h2f_WLAST,                //                    .wlast
		output wire         h2f_WVALID,               //                    .wvalid
		input  wire         h2f_WREADY,               //                    .wready
		input  wire [11:0]  h2f_BID,                  //                    .bid
		input  wire [1:0]   h2f_BRESP,                //                    .bresp
		input  wire         h2f_BVALID,               //                    .bvalid
		output wire         h2f_BREADY,               //                    .bready
		output wire [11:0]  h2f_ARID,                 //                    .arid
		output wire [29:0]  h2f_ARADDR,               //                    .araddr
		output wire [3:0]   h2f_ARLEN,                //                    .arlen
		output wire [2:0]   h2f_ARSIZE,               //                    .arsize
		output wire [1:0]   h2f_ARBURST,              //                    .arburst
		output wire [1:0]   h2f_ARLOCK,               //                    .arlock
		output wire [3:0]   h2f_ARCACHE,              //                    .arcache
		output wire [2:0]   h2f_ARPROT,               //                    .arprot
		output wire         h2f_ARVALID,              //                    .arvalid
		input  wire         h2f_ARREADY,              //                    .arready
		input  wire [11:0]  h2f_RID,                  //                    .rid
		input  wire [127:0] h2f_RDATA,                //                    .rdata
		input  wire [1:0]   h2f_RRESP,                //                    .rresp
		input  wire         h2f_RLAST,                //                    .rlast
		input  wire         h2f_RVALID,               //                    .rvalid
		output wire         h2f_RREADY,               //                    .rready
		input  wire [31:0]  f2h_irq_p0,               //            f2h_irq0.irq
		input  wire [31:0]  f2h_irq_p1,               //            f2h_irq1.irq
		output wire [14:0]  mem_a,                    //              memory.mem_a
		output wire [2:0]   mem_ba,                   //                    .mem_ba
		output wire         mem_ck,                   //                    .mem_ck
		output wire         mem_ck_n,                 //                    .mem_ck_n
		output wire         mem_cke,                  //                    .mem_cke
		output wire         mem_cs_n,                 //                    .mem_cs_n
		output wire         mem_ras_n,                //                    .mem_ras_n
		output wire         mem_cas_n,                //                    .mem_cas_n
		output wire         mem_we_n,                 //                    .mem_we_n
		output wire         mem_reset_n,              //                    .mem_reset_n
		inout  wire [31:0]  mem_dq,                   //                    .mem_dq
		inout  wire [3:0]   mem_dqs,                  //                    .mem_dqs
		inout  wire [3:0]   mem_dqs_n,                //                    .mem_dqs_n
		output wire         mem_odt,                  //                    .mem_odt
		output wire [3:0]   mem_dm,                   //                    .mem_dm
		input  wire         oct_rzqin,                //                    .oct_rzqin
		output wire         hps_io_emac1_inst_TX_CLK, //              hps_io.hps_io_emac1_inst_TX_CLK
		output wire         hps_io_emac1_inst_TXD0,   //                    .hps_io_emac1_inst_TXD0
		output wire         hps_io_emac1_inst_TXD1,   //                    .hps_io_emac1_inst_TXD1
		output wire         hps_io_emac1_inst_TXD2,   //                    .hps_io_emac1_inst_TXD2
		output wire         hps_io_emac1_inst_TXD3,   //                    .hps_io_emac1_inst_TXD3
		input  wire         hps_io_emac1_inst_RXD0,   //                    .hps_io_emac1_inst_RXD0
		inout  wire         hps_io_emac1_inst_MDIO,   //                    .hps_io_emac1_inst_MDIO
		output wire         hps_io_emac1_inst_MDC,    //                    .hps_io_emac1_inst_MDC
		input  wire         hps_io_emac1_inst_RX_CTL, //                    .hps_io_emac1_inst_RX_CTL
		output wire         hps_io_emac1_inst_TX_CTL, //                    .hps_io_emac1_inst_TX_CTL
		input  wire         hps_io_emac1_inst_RX_CLK, //                    .hps_io_emac1_inst_RX_CLK
		input  wire         hps_io_emac1_inst_RXD1,   //                    .hps_io_emac1_inst_RXD1
		input  wire         hps_io_emac1_inst_RXD2,   //                    .hps_io_emac1_inst_RXD2
		input  wire         hps_io_emac1_inst_RXD3,   //                    .hps_io_emac1_inst_RXD3
		inout  wire         hps_io_qspi_inst_IO0,     //                    .hps_io_qspi_inst_IO0
		inout  wire         hps_io_qspi_inst_IO1,     //                    .hps_io_qspi_inst_IO1
		inout  wire         hps_io_qspi_inst_IO2,     //                    .hps_io_qspi_inst_IO2
		inout  wire         hps_io_qspi_inst_IO3,     //                    .hps_io_qspi_inst_IO3
		output wire         hps_io_qspi_inst_SS0,     //                    .hps_io_qspi_inst_SS0
		output wire         hps_io_qspi_inst_CLK,     //                    .hps_io_qspi_inst_CLK
		inout  wire         hps_io_sdio_inst_CMD,     //                    .hps_io_sdio_inst_CMD
		inout  wire         hps_io_sdio_inst_D0,      //                    .hps_io_sdio_inst_D0
		inout  wire         hps_io_sdio_inst_D1,      //                    .hps_io_sdio_inst_D1
		output wire         hps_io_sdio_inst_CLK,     //                    .hps_io_sdio_inst_CLK
		inout  wire         hps_io_sdio_inst_D2,      //                    .hps_io_sdio_inst_D2
		inout  wire         hps_io_sdio_inst_D3,      //                    .hps_io_sdio_inst_D3
		inout  wire         hps_io_usb1_inst_D0,      //                    .hps_io_usb1_inst_D0
		inout  wire         hps_io_usb1_inst_D1,      //                    .hps_io_usb1_inst_D1
		inout  wire         hps_io_usb1_inst_D2,      //                    .hps_io_usb1_inst_D2
		inout  wire         hps_io_usb1_inst_D3,      //                    .hps_io_usb1_inst_D3
		inout  wire         hps_io_usb1_inst_D4,      //                    .hps_io_usb1_inst_D4
		inout  wire         hps_io_usb1_inst_D5,      //                    .hps_io_usb1_inst_D5
		inout  wire         hps_io_usb1_inst_D6,      //                    .hps_io_usb1_inst_D6
		inout  wire         hps_io_usb1_inst_D7,      //                    .hps_io_usb1_inst_D7
		input  wire         hps_io_usb1_inst_CLK,     //                    .hps_io_usb1_inst_CLK
		output wire         hps_io_usb1_inst_STP,     //                    .hps_io_usb1_inst_STP
		input  wire         hps_io_usb1_inst_DIR,     //                    .hps_io_usb1_inst_DIR
		input  wire         hps_io_usb1_inst_NXT,     //                    .hps_io_usb1_inst_NXT
		output wire         hps_io_spim1_inst_CLK,    //                    .hps_io_spim1_inst_CLK
		output wire         hps_io_spim1_inst_MOSI,   //                    .hps_io_spim1_inst_MOSI
		input  wire         hps_io_spim1_inst_MISO,   //                    .hps_io_spim1_inst_MISO
		output wire         hps_io_spim1_inst_SS0,    //                    .hps_io_spim1_inst_SS0
		input  wire         hps_io_uart0_inst_RX,     //                    .hps_io_uart0_inst_RX
		output wire         hps_io_uart0_inst_TX,     //                    .hps_io_uart0_inst_TX
		inout  wire         hps_io_i2c0_inst_SDA,     //                    .hps_io_i2c0_inst_SDA
		inout  wire         hps_io_i2c0_inst_SCL,     //                    .hps_io_i2c0_inst_SCL
		inout  wire         hps_io_i2c1_inst_SDA,     //                    .hps_io_i2c1_inst_SDA
		inout  wire         hps_io_i2c1_inst_SCL      //                    .hps_io_i2c1_inst_SCL
	);

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (F2S_Width != 3)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					f2s_width_check ( .error(1'b1) );
		end
		if (S2F_Width != 3)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					s2f_width_check ( .error(1'b1) );
		end
	endgenerate

	de1_soc_hps_0_fpga_interfaces fpga_interfaces (
		.h2f_rst_n          (h2f_rst_n),          //           h2f_reset.reset_n
		.f2h_cold_rst_req_n (f2h_cold_rst_req_n), //  f2h_cold_reset_req.reset_n
		.f2h_dbg_rst_req_n  (f2h_dbg_rst_req_n),  // f2h_debug_reset_req.reset_n
		.f2h_warm_rst_req_n (f2h_warm_rst_req_n), //  f2h_warm_reset_req.reset_n
		.f2h_axi_clk        (f2h_axi_clk),        //       f2h_axi_clock.clk
		.f2h_AWID           (f2h_AWID),           //       f2h_axi_slave.awid
		.f2h_AWADDR         (f2h_AWADDR),         //                    .awaddr
		.f2h_AWLEN          (f2h_AWLEN),          //                    .awlen
		.f2h_AWSIZE         (f2h_AWSIZE),         //                    .awsize
		.f2h_AWBURST        (f2h_AWBURST),        //                    .awburst
		.f2h_AWLOCK         (f2h_AWLOCK),         //                    .awlock
		.f2h_AWCACHE        (f2h_AWCACHE),        //                    .awcache
		.f2h_AWPROT         (f2h_AWPROT),         //                    .awprot
		.f2h_AWVALID        (f2h_AWVALID),        //                    .awvalid
		.f2h_AWREADY        (f2h_AWREADY),        //                    .awready
		.f2h_AWUSER         (f2h_AWUSER),         //                    .awuser
		.f2h_WID            (f2h_WID),            //                    .wid
		.f2h_WDATA          (f2h_WDATA),          //                    .wdata
		.f2h_WSTRB          (f2h_WSTRB),          //                    .wstrb
		.f2h_WLAST          (f2h_WLAST),          //                    .wlast
		.f2h_WVALID         (f2h_WVALID),         //                    .wvalid
		.f2h_WREADY         (f2h_WREADY),         //                    .wready
		.f2h_BID            (f2h_BID),            //                    .bid
		.f2h_BRESP          (f2h_BRESP),          //                    .bresp
		.f2h_BVALID         (f2h_BVALID),         //                    .bvalid
		.f2h_BREADY         (f2h_BREADY),         //                    .bready
		.f2h_ARID           (f2h_ARID),           //                    .arid
		.f2h_ARADDR         (f2h_ARADDR),         //                    .araddr
		.f2h_ARLEN          (f2h_ARLEN),          //                    .arlen
		.f2h_ARSIZE         (f2h_ARSIZE),         //                    .arsize
		.f2h_ARBURST        (f2h_ARBURST),        //                    .arburst
		.f2h_ARLOCK         (f2h_ARLOCK),         //                    .arlock
		.f2h_ARCACHE        (f2h_ARCACHE),        //                    .arcache
		.f2h_ARPROT         (f2h_ARPROT),         //                    .arprot
		.f2h_ARVALID        (f2h_ARVALID),        //                    .arvalid
		.f2h_ARREADY        (f2h_ARREADY),        //                    .arready
		.f2h_ARUSER         (f2h_ARUSER),         //                    .aruser
		.f2h_RID            (f2h_RID),            //                    .rid
		.f2h_RDATA          (f2h_RDATA),          //                    .rdata
		.f2h_RRESP          (f2h_RRESP),          //                    .rresp
		.f2h_RLAST          (f2h_RLAST),          //                    .rlast
		.f2h_RVALID         (f2h_RVALID),         //                    .rvalid
		.f2h_RREADY         (f2h_RREADY),         //                    .rready
		.h2f_lw_axi_clk     (h2f_lw_axi_clk),     //    h2f_lw_axi_clock.clk
		.h2f_lw_AWID        (h2f_lw_AWID),        //   h2f_lw_axi_master.awid
		.h2f_lw_AWADDR      (h2f_lw_AWADDR),      //                    .awaddr
		.h2f_lw_AWLEN       (h2f_lw_AWLEN),       //                    .awlen
		.h2f_lw_AWSIZE      (h2f_lw_AWSIZE),      //                    .awsize
		.h2f_lw_AWBURST     (h2f_lw_AWBURST),     //                    .awburst
		.h2f_lw_AWLOCK      (h2f_lw_AWLOCK),      //                    .awlock
		.h2f_lw_AWCACHE     (h2f_lw_AWCACHE),     //                    .awcache
		.h2f_lw_AWPROT      (h2f_lw_AWPROT),      //                    .awprot
		.h2f_lw_AWVALID     (h2f_lw_AWVALID),     //                    .awvalid
		.h2f_lw_AWREADY     (h2f_lw_AWREADY),     //                    .awready
		.h2f_lw_WID         (h2f_lw_WID),         //                    .wid
		.h2f_lw_WDATA       (h2f_lw_WDATA),       //                    .wdata
		.h2f_lw_WSTRB       (h2f_lw_WSTRB),       //                    .wstrb
		.h2f_lw_WLAST       (h2f_lw_WLAST),       //                    .wlast
		.h2f_lw_WVALID      (h2f_lw_WVALID),      //                    .wvalid
		.h2f_lw_WREADY      (h2f_lw_WREADY),      //                    .wready
		.h2f_lw_BID         (h2f_lw_BID),         //                    .bid
		.h2f_lw_BRESP       (h2f_lw_BRESP),       //                    .bresp
		.h2f_lw_BVALID      (h2f_lw_BVALID),      //                    .bvalid
		.h2f_lw_BREADY      (h2f_lw_BREADY),      //                    .bready
		.h2f_lw_ARID        (h2f_lw_ARID),        //                    .arid
		.h2f_lw_ARADDR      (h2f_lw_ARADDR),      //                    .araddr
		.h2f_lw_ARLEN       (h2f_lw_ARLEN),       //                    .arlen
		.h2f_lw_ARSIZE      (h2f_lw_ARSIZE),      //                    .arsize
		.h2f_lw_ARBURST     (h2f_lw_ARBURST),     //                    .arburst
		.h2f_lw_ARLOCK      (h2f_lw_ARLOCK),      //                    .arlock
		.h2f_lw_ARCACHE     (h2f_lw_ARCACHE),     //                    .arcache
		.h2f_lw_ARPROT      (h2f_lw_ARPROT),      //                    .arprot
		.h2f_lw_ARVALID     (h2f_lw_ARVALID),     //                    .arvalid
		.h2f_lw_ARREADY     (h2f_lw_ARREADY),     //                    .arready
		.h2f_lw_RID         (h2f_lw_RID),         //                    .rid
		.h2f_lw_RDATA       (h2f_lw_RDATA),       //                    .rdata
		.h2f_lw_RRESP       (h2f_lw_RRESP),       //                    .rresp
		.h2f_lw_RLAST       (h2f_lw_RLAST),       //                    .rlast
		.h2f_lw_RVALID      (h2f_lw_RVALID),      //                    .rvalid
		.h2f_lw_RREADY      (h2f_lw_RREADY),      //                    .rready
		.h2f_axi_clk        (h2f_axi_clk),        //       h2f_axi_clock.clk
		.h2f_AWID           (h2f_AWID),           //      h2f_axi_master.awid
		.h2f_AWADDR         (h2f_AWADDR),         //                    .awaddr
		.h2f_AWLEN          (h2f_AWLEN),          //                    .awlen
		.h2f_AWSIZE         (h2f_AWSIZE),         //                    .awsize
		.h2f_AWBURST        (h2f_AWBURST),        //                    .awburst
		.h2f_AWLOCK         (h2f_AWLOCK),         //                    .awlock
		.h2f_AWCACHE        (h2f_AWCACHE),        //                    .awcache
		.h2f_AWPROT         (h2f_AWPROT),         //                    .awprot
		.h2f_AWVALID        (h2f_AWVALID),        //                    .awvalid
		.h2f_AWREADY        (h2f_AWREADY),        //                    .awready
		.h2f_WID            (h2f_WID),            //                    .wid
		.h2f_WDATA          (h2f_WDATA),          //                    .wdata
		.h2f_WSTRB          (h2f_WSTRB),          //                    .wstrb
		.h2f_WLAST          (h2f_WLAST),          //                    .wlast
		.h2f_WVALID         (h2f_WVALID),         //                    .wvalid
		.h2f_WREADY         (h2f_WREADY),         //                    .wready
		.h2f_BID            (h2f_BID),            //                    .bid
		.h2f_BRESP          (h2f_BRESP),          //                    .bresp
		.h2f_BVALID         (h2f_BVALID),         //                    .bvalid
		.h2f_BREADY         (h2f_BREADY),         //                    .bready
		.h2f_ARID           (h2f_ARID),           //                    .arid
		.h2f_ARADDR         (h2f_ARADDR),         //                    .araddr
		.h2f_ARLEN          (h2f_ARLEN),          //                    .arlen
		.h2f_ARSIZE         (h2f_ARSIZE),         //                    .arsize
		.h2f_ARBURST        (h2f_ARBURST),        //                    .arburst
		.h2f_ARLOCK         (h2f_ARLOCK),         //                    .arlock
		.h2f_ARCACHE        (h2f_ARCACHE),        //                    .arcache
		.h2f_ARPROT         (h2f_ARPROT),         //                    .arprot
		.h2f_ARVALID        (h2f_ARVALID),        //                    .arvalid
		.h2f_ARREADY        (h2f_ARREADY),        //                    .arready
		.h2f_RID            (h2f_RID),            //                    .rid
		.h2f_RDATA          (h2f_RDATA),          //                    .rdata
		.h2f_RRESP          (h2f_RRESP),          //                    .rresp
		.h2f_RLAST          (h2f_RLAST),          //                    .rlast
		.h2f_RVALID         (h2f_RVALID),         //                    .rvalid
		.h2f_RREADY         (h2f_RREADY),         //                    .rready
		.f2h_irq_p0         (f2h_irq_p0),         //            f2h_irq0.irq
		.f2h_irq_p1         (f2h_irq_p1)          //            f2h_irq1.irq
	);

	de1_soc_hps_0_hps_io hps_io (
		.mem_a                    (mem_a),                    // memory.mem_a
		.mem_ba                   (mem_ba),                   //       .mem_ba
		.mem_ck                   (mem_ck),                   //       .mem_ck
		.mem_ck_n                 (mem_ck_n),                 //       .mem_ck_n
		.mem_cke                  (mem_cke),                  //       .mem_cke
		.mem_cs_n                 (mem_cs_n),                 //       .mem_cs_n
		.mem_ras_n                (mem_ras_n),                //       .mem_ras_n
		.mem_cas_n                (mem_cas_n),                //       .mem_cas_n
		.mem_we_n                 (mem_we_n),                 //       .mem_we_n
		.mem_reset_n              (mem_reset_n),              //       .mem_reset_n
		.mem_dq                   (mem_dq),                   //       .mem_dq
		.mem_dqs                  (mem_dqs),                  //       .mem_dqs
		.mem_dqs_n                (mem_dqs_n),                //       .mem_dqs_n
		.mem_odt                  (mem_odt),                  //       .mem_odt
		.mem_dm                   (mem_dm),                   //       .mem_dm
		.oct_rzqin                (oct_rzqin),                //       .oct_rzqin
		.hps_io_emac1_inst_TX_CLK (hps_io_emac1_inst_TX_CLK), // hps_io.hps_io_emac1_inst_TX_CLK
		.hps_io_emac1_inst_TXD0   (hps_io_emac1_inst_TXD0),   //       .hps_io_emac1_inst_TXD0
		.hps_io_emac1_inst_TXD1   (hps_io_emac1_inst_TXD1),   //       .hps_io_emac1_inst_TXD1
		.hps_io_emac1_inst_TXD2   (hps_io_emac1_inst_TXD2),   //       .hps_io_emac1_inst_TXD2
		.hps_io_emac1_inst_TXD3   (hps_io_emac1_inst_TXD3),   //       .hps_io_emac1_inst_TXD3
		.hps_io_emac1_inst_RXD0   (hps_io_emac1_inst_RXD0),   //       .hps_io_emac1_inst_RXD0
		.hps_io_emac1_inst_MDIO   (hps_io_emac1_inst_MDIO),   //       .hps_io_emac1_inst_MDIO
		.hps_io_emac1_inst_MDC    (hps_io_emac1_inst_MDC),    //       .hps_io_emac1_inst_MDC
		.hps_io_emac1_inst_RX_CTL (hps_io_emac1_inst_RX_CTL), //       .hps_io_emac1_inst_RX_CTL
		.hps_io_emac1_inst_TX_CTL (hps_io_emac1_inst_TX_CTL), //       .hps_io_emac1_inst_TX_CTL
		.hps_io_emac1_inst_RX_CLK (hps_io_emac1_inst_RX_CLK), //       .hps_io_emac1_inst_RX_CLK
		.hps_io_emac1_inst_RXD1   (hps_io_emac1_inst_RXD1),   //       .hps_io_emac1_inst_RXD1
		.hps_io_emac1_inst_RXD2   (hps_io_emac1_inst_RXD2),   //       .hps_io_emac1_inst_RXD2
		.hps_io_emac1_inst_RXD3   (hps_io_emac1_inst_RXD3),   //       .hps_io_emac1_inst_RXD3
		.hps_io_qspi_inst_IO0     (hps_io_qspi_inst_IO0),     //       .hps_io_qspi_inst_IO0
		.hps_io_qspi_inst_IO1     (hps_io_qspi_inst_IO1),     //       .hps_io_qspi_inst_IO1
		.hps_io_qspi_inst_IO2     (hps_io_qspi_inst_IO2),     //       .hps_io_qspi_inst_IO2
		.hps_io_qspi_inst_IO3     (hps_io_qspi_inst_IO3),     //       .hps_io_qspi_inst_IO3
		.hps_io_qspi_inst_SS0     (hps_io_qspi_inst_SS0),     //       .hps_io_qspi_inst_SS0
		.hps_io_qspi_inst_CLK     (hps_io_qspi_inst_CLK),     //       .hps_io_qspi_inst_CLK
		.hps_io_sdio_inst_CMD     (hps_io_sdio_inst_CMD),     //       .hps_io_sdio_inst_CMD
		.hps_io_sdio_inst_D0      (hps_io_sdio_inst_D0),      //       .hps_io_sdio_inst_D0
		.hps_io_sdio_inst_D1      (hps_io_sdio_inst_D1),      //       .hps_io_sdio_inst_D1
		.hps_io_sdio_inst_CLK     (hps_io_sdio_inst_CLK),     //       .hps_io_sdio_inst_CLK
		.hps_io_sdio_inst_D2      (hps_io_sdio_inst_D2),      //       .hps_io_sdio_inst_D2
		.hps_io_sdio_inst_D3      (hps_io_sdio_inst_D3),      //       .hps_io_sdio_inst_D3
		.hps_io_usb1_inst_D0      (hps_io_usb1_inst_D0),      //       .hps_io_usb1_inst_D0
		.hps_io_usb1_inst_D1      (hps_io_usb1_inst_D1),      //       .hps_io_usb1_inst_D1
		.hps_io_usb1_inst_D2      (hps_io_usb1_inst_D2),      //       .hps_io_usb1_inst_D2
		.hps_io_usb1_inst_D3      (hps_io_usb1_inst_D3),      //       .hps_io_usb1_inst_D3
		.hps_io_usb1_inst_D4      (hps_io_usb1_inst_D4),      //       .hps_io_usb1_inst_D4
		.hps_io_usb1_inst_D5      (hps_io_usb1_inst_D5),      //       .hps_io_usb1_inst_D5
		.hps_io_usb1_inst_D6      (hps_io_usb1_inst_D6),      //       .hps_io_usb1_inst_D6
		.hps_io_usb1_inst_D7      (hps_io_usb1_inst_D7),      //       .hps_io_usb1_inst_D7
		.hps_io_usb1_inst_CLK     (hps_io_usb1_inst_CLK),     //       .hps_io_usb1_inst_CLK
		.hps_io_usb1_inst_STP     (hps_io_usb1_inst_STP),     //       .hps_io_usb1_inst_STP
		.hps_io_usb1_inst_DIR     (hps_io_usb1_inst_DIR),     //       .hps_io_usb1_inst_DIR
		.hps_io_usb1_inst_NXT     (hps_io_usb1_inst_NXT),     //       .hps_io_usb1_inst_NXT
		.hps_io_spim1_inst_CLK    (hps_io_spim1_inst_CLK),    //       .hps_io_spim1_inst_CLK
		.hps_io_spim1_inst_MOSI   (hps_io_spim1_inst_MOSI),   //       .hps_io_spim1_inst_MOSI
		.hps_io_spim1_inst_MISO   (hps_io_spim1_inst_MISO),   //       .hps_io_spim1_inst_MISO
		.hps_io_spim1_inst_SS0    (hps_io_spim1_inst_SS0),    //       .hps_io_spim1_inst_SS0
		.hps_io_uart0_inst_RX     (hps_io_uart0_inst_RX),     //       .hps_io_uart0_inst_RX
		.hps_io_uart0_inst_TX     (hps_io_uart0_inst_TX),     //       .hps_io_uart0_inst_TX
		.hps_io_i2c0_inst_SDA     (hps_io_i2c0_inst_SDA),     //       .hps_io_i2c0_inst_SDA
		.hps_io_i2c0_inst_SCL     (hps_io_i2c0_inst_SCL),     //       .hps_io_i2c0_inst_SCL
		.hps_io_i2c1_inst_SDA     (hps_io_i2c1_inst_SDA),     //       .hps_io_i2c1_inst_SDA
		.hps_io_i2c1_inst_SCL     (hps_io_i2c1_inst_SCL)      //       .hps_io_i2c1_inst_SCL
	);

endmodule
