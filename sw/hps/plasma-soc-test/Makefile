all: dma2hps

led_pattern_mgr: led_pattern_mgr.c
	${CROSS_COMPILE}gcc -g -I../../../dependencies/KebabOS/include -I${hwlib_inc} -I../include led_pattern_mgr.c -o led_pattern_mgr


mem: mem.c
	${CROSS_COMPILE}gcc -I../../../dependencies/KebabOS/include -I${hwlib_inc} -I../include mem.c -o mem 	


sysid: sysid.c
	${CROSS_COMPILE}gcc -g -I../../../dependencies/KebabOS/include -I${hwlib_inc} -I../include sysid.c -o sysid

