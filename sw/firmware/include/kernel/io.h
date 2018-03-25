#pragma once

#include "kernel/device.h"

uint32_t dread(device_t* device);

void dwrite(device_t* device, uint32_t data);

int dputc(device_t* device, int character);

int dgetc(device_t* device);

int dputs(device_t* device, const char *string);

#define dcwrite(dev, data) (dev->device.control = (data))
#define dcread(dev) (dev->device.control)

#define dsread(dev) (dev->device.status)

#define ddwrite(dev, data) (dev->device.data = (data))
#define ddread(dev) (dev->device.data)