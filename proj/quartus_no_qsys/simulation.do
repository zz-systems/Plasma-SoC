transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib zz_systems
vmap zz_systems zz_systems
vlog -vlog01compat -work zz_systems +incdir+Z:/Documents/DEV/plasmax/proj/quartus_no_qsys {Z:/Documents/DEV/plasmax/proj/quartus_no_qsys/PLASMA_DE1_SOC.v}
vlib plasma_lib
vmap plasma_lib plasma_lib
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/mlite_pack.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/util/util_pkg.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/wb_pkg.de1_soc.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/avalon/avalon_pkg.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/irc/ir_channel.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/gpio/gpio.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/counter/counter.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/shifter.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/pc_next.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/mult.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/mlite_cpu.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/mem_ctrl.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/uart.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/control.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/alu.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/reg_bank.altera.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/ram.vhd}
vcom -2008 -work plasma_lib {Z:/Documents/DEV/plasmax/rtl/plasma/bus_mux.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/arbiter.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/shared_bus.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/avalon/wb_to_avalon_bridge.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/avalon/avalon_to_wb_bridge.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/irc/ir_control.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/timer/timer.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/spi/spi_control.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/counter/slave_counter.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/wrapper/master_cpu.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/gpio/slave_gpio.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/wrapper/slave_uart.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/wishbone/wrapper/slave_memory.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/timer/slave_timer.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/irc/slave_irc.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/spi/slave_spi_control.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/plasma_soc.de1_soc.vhd}
vcom -2008 -work zz_systems {Z:/Documents/DEV/plasmax/rtl/plasma_soc_top.de1_soc.vhd}

vcom -2008 -work work {Z:/Documents/DEV/plasmax/proj/quartus_no_qsys/../../tb/tb_plasma.de1_soc.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -L zz_systems -L plasma_lib -voptargs="+acc"  tb_plasma_de1_soc

do wave.do 
view structure
view signals

run 150 us