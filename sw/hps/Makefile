cc_none=arm-none-eabi-
cc_linux=arm-linux-gnueabihf-

preload_dir = spl_bsp
uboot_dir = spl_bsp/uboot-socfpga

eds_dir=/home/szuyev/altera/13.1
export hwlib_inc=${eds_dir}/embedded/ip/altera/hps/altera_hps/hwlib/include/

sopcinfo=../../proj/quartus/de1_soc.sopcinfo

preload: 
	make -C ${preload_dir} CROSS_COMPILE=${cc_none} -j 4

uboot: 
	make -C ${uboot_dir} CROSS_COMPILE=${cc_linux} -j 4

bootscript:
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Default" -d boot.script u-boot/u-boot.scr

socfpga_cyclone5_de1_soc.dtb: #de1_soc.dts
	make -C dts/ socfpga_cyclone5_de1_soc

plasma_headers:
	sopc-create-header-files ${sopcinfo} \
		--single "./include/plasma_de1_soc_system.h" \
		--module hps_0

sdcard:
	sudo ./make-sdcard.sh

#patch-uboot-env:
#	sudo dd if=${uboot_dir}/u-boot-env.img of="$${of:?}1" bs=1 seek=512

patch-preload:
	sudo dd if=${preload_dir}/preloader-mkpimage.bin of="$${of:?}" bs=64k count=4
	sync

patch-boot:	
	sudo dd if=${uboot_dir}/u-boot.img of="$${of:?}" bs=64k seek=4
	sync

#export DEP=../../dependencies/
#export L_INC=-I../../dependencies/KebabOS/include -I${hwlib_inc}

led_pattern_mgr:
	make -C plasma-soc-test CROSS_COMPILE=${cc_linux} led_pattern_mgr

mem:
	make -C plasma-soc-test CROSS_COMPILE=${cc_linux} mem

sysid:
	make -C plasma-soc-test CROSS_COMPILE=${cc_linux} sysid