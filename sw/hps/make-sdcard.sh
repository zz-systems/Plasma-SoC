image="sdcard.img"

echo "label: dos
unit: sectors
start=        2048, size=        2048, type=a2
start=        4096, size=      520192, type=b
start=      524288, size=      524288, type=83" > partitiontable

echo "Creating empty image..."
dd if=/dev/zero of=$image bs=512M count=1

echo "Partitioning..."
sfdisk $image < partitiontable

kpartx -sav $image

echo "Formatting..."
mkfs.vfat -F 32 /dev/mapper/loop0p2
mkfs.ext4 /dev/mapper/loop0p3

echo "Writing data..."
dd if=./spl_bsp/preloader-mkpimage.bin of=/dev/mapper/loop0p1 bs=262144 seek=0
dd if=./spl_bsp/uboot-socfpga/u-boot.img of=/dev/mapper/loop0p1 bs=262144 seek=1

mkdir mntraw

mount /dev/mapper/loop0p2 mntraw

sudo cp u-boot/u-boot.scr mntraw
#sudo cp dts/plasma_soc.dtb mntraw
sudo cp dts/4.9.78-ltsi/socfpga_cyclone5_de1_soc.dtb mntraw/plasma_soc.dtb
sudo cp ../../proj/quartus_13.1/plasma_soc.rbf mntraw
sudo cp zImage mntraw
sync

mkdir mntrootfs

mount /dev/mapper/loop0p3 mntrootfs

sudo tar -xvf rootfs.tar -C mntrootfs
sync

echo "Cleaning up..."
umount mntraw
umount mntrootfs

rmdir mntraw
rmdir mntrootfs

kpartx -dv $image