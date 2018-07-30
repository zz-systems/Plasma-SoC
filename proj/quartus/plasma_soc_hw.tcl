# TCL File Generated by Component Editor 18.0
# Mon Jul 30 10:42:29 CEST 2018
# DO NOT MODIFY


# 
# plasma_soc "Plasma SoC" v1.0
# Sergej Zuyev 2018.07.30.10:42:28
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module plasma_soc
# 
set_module_property DESCRIPTION ""
set_module_property NAME plasma_soc
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Sergej Zuyev"
set_module_property DISPLAY_NAME "Plasma SoC"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL plasma_soc_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file plasma_de1_soc.includes.qip OTHER PATH plasma_de1_soc.includes.qip
add_fileset_file wb_pkg.de1_soc.vhd VHDL PATH ../../rtl/wishbone/wb_pkg.de1_soc.vhd
add_fileset_file avalon_pkg.vhd VHDL PATH ../../rtl/avalon/avalon_pkg.vhd
add_fileset_file avalon_slave2wb_master.vhd VHDL PATH ../../rtl/avalon/avalon_slave2wb_master.vhd
add_fileset_file avalon_master2wb_slave.vhd VHDL PATH ../../rtl/avalon/avalon_master2wb_slave.vhd
add_fileset_file counter.vhd VHDL PATH ../../rtl/counter/counter.vhd
add_fileset_file gpio.vhd VHDL PATH ../../rtl/gpio/gpio.vhd
add_fileset_file slave_gpio.vhd VHDL PATH ../../rtl/gpio/slave_gpio.vhd
add_fileset_file ir_channel.vhd VHDL PATH ../../rtl/irc/ir_channel.vhd
add_fileset_file ir_control.vhd VHDL PATH ../../rtl/irc/ir_control.vhd
add_fileset_file alu.vhd VHDL PATH ../../rtl/plasma/alu.vhd
add_fileset_file bus_mux.vhd VHDL PATH ../../rtl/plasma/bus_mux.vhd
add_fileset_file control.vhd VHDL PATH ../../rtl/plasma/control.vhd
add_fileset_file mem_ctrl.vhd VHDL PATH ../../rtl/plasma/mem_ctrl.vhd
add_fileset_file mlite_cpu.vhd VHDL PATH ../../rtl/plasma/mlite_cpu.vhd
add_fileset_file mlite_pack.vhd VHDL PATH ../../rtl/plasma/mlite_pack.vhd
add_fileset_file mult.vhd VHDL PATH ../../rtl/plasma/mult.vhd
add_fileset_file pc_next.vhd VHDL PATH ../../rtl/plasma/pc_next.vhd
add_fileset_file pipeline.vhd VHDL PATH ../../rtl/plasma/pipeline.vhd
add_fileset_file shared_bus.vhd VHDL PATH ../../rtl/wishbone/shared_bus.vhd
add_fileset_file plasma_if.vhd VHDL PATH ../../rtl/plasma/plasma_if.vhd
add_fileset_file ram.vhd VHDL PATH ../../rtl/plasma/ram.vhd
add_fileset_file shifter.vhd VHDL PATH ../../rtl/plasma/shifter.vhd
add_fileset_file uart.vhdw VHDL PATH ../../rtl/plasma/uart.vhd
add_fileset_file slave_spi_control.vhd VHDL PATH ../../rtl/spi/slave_spi_control.vhd
add_fileset_file spi_control.vhd VHDL PATH ../../rtl/spi/spi_control.vhd
add_fileset_file slave_timer.vhd VHDL PATH ../../rtl/timer/slave_timer.vhd
add_fileset_file timer.vhd VHDL PATH ../../rtl/timer/timer.vhd
add_fileset_file util_pkg.vhd VHDL PATH ../../rtl/util/util_pkg.vhd
add_fileset_file reg_bank.altera.vhd VHDL PATH ../../rtl/plasma/reg_bank.altera.vhd
add_fileset_file plasma.vhd VHDL PATH ../../rtl/plasma/plasma.vhd
add_fileset_file arbiter.vhd VHDL PATH ../../rtl/wishbone/arbiter.vhd
add_fileset_file master_cpu.vhd VHDL PATH ../../rtl/wishbone/wrapper/master_cpu.vhd
add_fileset_file slave_irc.vhd VHDL PATH ../../rtl/irc/slave_irc.vhd
add_fileset_file slave_counter.vhd VHDL PATH ../../rtl/counter/slave_counter.vhd
add_fileset_file slave_memory.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_memory.vhd
add_fileset_file slave_uart.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_uart.vhd
add_fileset_file slave_ext_memory.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_ext_memory.vhd
add_fileset_file plasma_soc.de1_soc.vhd VHDL PATH ../../rtl/plasma_soc.de1_soc.vhd
add_fileset_file plasma_soc_top.de1_soc.vhd VHDL PATH ../../rtl/plasma_soc_top.de1_soc.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL plasma_soc_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file plasma_de1_soc.includes.qip OTHER PATH plasma_de1_soc.includes.qip
add_fileset_file wb_pkg.de1_soc.vhd VHDL PATH ../../rtl/wishbone/wb_pkg.de1_soc.vhd
add_fileset_file avalon_pkg.vhd VHDL PATH ../../rtl/avalon/avalon_pkg.vhd
add_fileset_file avalon_slave2wb_master.vhd VHDL PATH ../../rtl/avalon/avalon_slave2wb_master.vhd
add_fileset_file counter.vhd VHDL PATH ../../rtl/counter/counter.vhd
add_fileset_file gpio.vhd VHDL PATH ../../rtl/gpio/gpio.vhd
add_fileset_file slave_gpio.vhd VHDL PATH ../../rtl/gpio/slave_gpio.vhd
add_fileset_file ir_channel.vhd VHDL PATH ../../rtl/irc/ir_channel.vhd
add_fileset_file ir_control.vhd VHDL PATH ../../rtl/irc/ir_control.vhd
add_fileset_file alu.vhd VHDL PATH ../../rtl/plasma/alu.vhd
add_fileset_file bus_mux.vhd VHDL PATH ../../rtl/plasma/bus_mux.vhd
add_fileset_file control.vhd VHDL PATH ../../rtl/plasma/control.vhd
add_fileset_file mem_ctrl.vhd VHDL PATH ../../rtl/plasma/mem_ctrl.vhd
add_fileset_file mlite_cpu.vhd VHDL PATH ../../rtl/plasma/mlite_cpu.vhd
add_fileset_file mlite_pack.vhd VHDL PATH ../../rtl/plasma/mlite_pack.vhd
add_fileset_file mult.vhd VHDL PATH ../../rtl/plasma/mult.vhd
add_fileset_file pc_next.vhd VHDL PATH ../../rtl/plasma/pc_next.vhd
add_fileset_file pipeline.vhd VHDL PATH ../../rtl/plasma/pipeline.vhd
add_fileset_file shared_bus.vhd VHDL PATH ../../rtl/wishbone/shared_bus.vhd
add_fileset_file plasma_if.vhd VHDL PATH ../../rtl/plasma/plasma_if.vhd
add_fileset_file ram.vhd VHDL PATH ../../rtl/plasma/ram.vhd
add_fileset_file shifter.vhd VHDL PATH ../../rtl/plasma/shifter.vhd
add_fileset_file uart.vhdw VHDL PATH ../../rtl/plasma/uart.vhd
add_fileset_file slave_spi_control.vhd VHDL PATH ../../rtl/spi/slave_spi_control.vhd
add_fileset_file spi_control.vhd VHDL PATH ../../rtl/spi/spi_control.vhd
add_fileset_file slave_timer.vhd VHDL PATH ../../rtl/timer/slave_timer.vhd
add_fileset_file timer.vhd VHDL PATH ../../rtl/timer/timer.vhd
add_fileset_file util_pkg.vhd VHDL PATH ../../rtl/util/util_pkg.vhd
add_fileset_file reg_bank.altera.vhd VHDL PATH ../../rtl/plasma/reg_bank.altera.vhd
add_fileset_file plasma.vhd VHDL PATH ../../rtl/plasma/plasma.vhd
add_fileset_file arbiter.vhd VHDL PATH ../../rtl/wishbone/arbiter.vhd
add_fileset_file master_cpu.vhd VHDL PATH ../../rtl/wishbone/wrapper/master_cpu.vhd
add_fileset_file slave_irc.vhd VHDL PATH ../../rtl/irc/slave_irc.vhd
add_fileset_file slave_counter.vhd VHDL PATH ../../rtl/counter/slave_counter.vhd
add_fileset_file slave_memory.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_memory.vhd
add_fileset_file slave_uart.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_uart.vhd
add_fileset_file slave_ext_memory.vhd VHDL PATH ../../rtl/wishbone/wrapper/slave_ext_memory.vhd
add_fileset_file plasma_soc.de1_soc.vhd VHDL PATH ../../rtl/plasma_soc.de1_soc.vhd
add_fileset_file plasma_soc_top.de1_soc.vhd VHDL PATH ../../rtl/plasma_soc_top.de1_soc.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock_sink
set_interface_property avalon_slave_0 associatedReset reset_sink
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 21776
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avs_address address Input 32
add_interface_port avalon_slave_0 avs_byteenable byteenable Input 4
add_interface_port avalon_slave_0 avs_write_n write_n Input 1
add_interface_port avalon_slave_0 avs_read_n read_n Input 1
add_interface_port avalon_slave_0 avs_readdata readdata Output 32
add_interface_port avalon_slave_0 avs_writedata writedata Input 32
add_interface_port avalon_slave_0 avs_waitrequest waitrequest Output 1
add_interface_port avalon_slave_0 avs_response response Output 2
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink RST reset Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink GCLK clk Input 1


# 
# connection point leds
# 
add_interface leds conduit end
set_interface_property leds associatedClock clock_sink
set_interface_property leds associatedReset ""
set_interface_property leds ENABLED true
set_interface_property leds EXPORT_OF ""
set_interface_property leds PORT_NAME_MAP ""
set_interface_property leds CMSIS_SVD_VARIABLES ""
set_interface_property leds SVD_ADDRESS_GROUP ""

add_interface_port leds LD ld Output 10


# 
# connection point sd_card
# 
add_interface sd_card conduit end
set_interface_property sd_card associatedClock clock_sink
set_interface_property sd_card associatedReset ""
set_interface_property sd_card ENABLED true
set_interface_property sd_card EXPORT_OF ""
set_interface_property sd_card PORT_NAME_MAP ""
set_interface_property sd_card CMSIS_SVD_VARIABLES ""
set_interface_property sd_card SVD_ADDRESS_GROUP ""

add_interface_port sd_card SD_CD sd_cd Input 1
add_interface_port sd_card SD_SPI_CS sd_spi_cs Output 1
add_interface_port sd_card SD_SPI_MISO sd_spi_miso Input 1
add_interface_port sd_card SD_SPI_MOSI sd_spi_mosi Output 1
add_interface_port sd_card SD_SPI_SCLK sd_spi_sclk Output 1
add_interface_port sd_card SD_WP sd_wp Input 1


# 
# connection point switches
# 
add_interface switches conduit end
set_interface_property switches associatedClock clock_sink
set_interface_property switches associatedReset ""
set_interface_property switches ENABLED true
set_interface_property switches EXPORT_OF ""
set_interface_property switches PORT_NAME_MAP ""
set_interface_property switches CMSIS_SVD_VARIABLES ""
set_interface_property switches SVD_ADDRESS_GROUP ""

add_interface_port switches SW sw Input 10


# 
# connection point uart
# 
add_interface uart conduit end
set_interface_property uart associatedClock clock_sink
set_interface_property uart associatedReset ""
set_interface_property uart ENABLED true
set_interface_property uart EXPORT_OF ""
set_interface_property uart PORT_NAME_MAP ""
set_interface_property uart CMSIS_SVD_VARIABLES ""
set_interface_property uart SVD_ADDRESS_GROUP ""

add_interface_port uart UART_RX uart_rx Input 1
add_interface_port uart UART_TX uart_tx Output 1


# 
# connection point avalon_master_0
# 
add_interface avalon_master_0 avalon start
set_interface_property avalon_master_0 addressUnits SYMBOLS
set_interface_property avalon_master_0 associatedClock clock_sink
set_interface_property avalon_master_0 associatedReset reset_sink
set_interface_property avalon_master_0 bitsPerSymbol 8
set_interface_property avalon_master_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_master_0 burstcountUnits WORDS
set_interface_property avalon_master_0 doStreamReads false
set_interface_property avalon_master_0 doStreamWrites false
set_interface_property avalon_master_0 holdTime 0
set_interface_property avalon_master_0 linewrapBursts false
set_interface_property avalon_master_0 maximumPendingReadTransactions 0
set_interface_property avalon_master_0 maximumPendingWriteTransactions 0
set_interface_property avalon_master_0 readLatency 0
set_interface_property avalon_master_0 readWaitTime 1
set_interface_property avalon_master_0 setupTime 0
set_interface_property avalon_master_0 timingUnits Cycles
set_interface_property avalon_master_0 writeWaitTime 0
set_interface_property avalon_master_0 ENABLED true
set_interface_property avalon_master_0 EXPORT_OF ""
set_interface_property avalon_master_0 PORT_NAME_MAP ""
set_interface_property avalon_master_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_0 avm_address address Output 32
add_interface_port avalon_master_0 avm_byteenable byteenable Output 4
add_interface_port avalon_master_0 avm_write_n write_n Output 1
add_interface_port avalon_master_0 avm_read_n read_n Output 1
add_interface_port avalon_master_0 avm_readdata readdata Input 32
add_interface_port avalon_master_0 avm_writedata writedata Output 32
add_interface_port avalon_master_0 avm_waitrequest waitrequest Input 1
add_interface_port avalon_master_0 avm_response response Input 2

