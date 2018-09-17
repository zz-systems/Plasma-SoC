ifneq (${KERNELRELEASE},)
obj-m := plsoc_counter.o
else
KERNEL_SOURCE := /home/szuyev/Desktop/linux-socfpga
PWD := $(shell pwd)

default:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
endif