#pragma once

#include <linux/miscdevice.h>
#include <linux/mutex.h>
#include <linux/spinlock.h>
#include <linux/fpga.h>

#include <kdev/alt_dmac.h>


struct fpga_dev
{
	struct platform_device *pdev;
	struct miscdevice ctrl_dev;
	struct miscdevice data_dev;
};
