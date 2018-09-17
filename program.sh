#!/bin/sh

# Determine the current FPGA state
cat /sys/class/fpga/fpga0/status

# Determine bridge status
cat /sys/class/fpga-bridge/fpga2hps/enable
cat /sys/class/fpga-bridge/hps2fpga/enable
cat /sys/class/fpga-bridge/lwhps2fpga/enable

# Disable enabled bridges
echo 0 > /sys/class/fpga-bridge/hps2fpga/enable
echo 0 > /sys/class/fpga-bridge/fpga2hps/enable
echo 0 > /sys/class/fpga-bridge/lwhps2fpga/enable

# Program FPGA
dd if=/home/root/plasma_soc.rbf of=/dev/fpga0 bs=1M

# Enable needed bridges
echo 1 > /sys/class/fpga-bridge/hps2fpga/enable
echo 1 > /sys/class/fpga-bridge/fpga2hps/enable
echo 1 > /sys/class/fpga-bridge/lwhps2fpga/enable