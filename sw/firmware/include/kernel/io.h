#pragma once

#include "kernel/device.h"

uint32_t dread(device* device);

void dwrite(device* device, uint32_t data);

int dputc(device* device, int character);

int dgetc(device* device);

int dputs(device* device, const char *string);

#define dcwrite(dev, data) (dev->device.control = (data))
#define dcread(dev) (dev->device.control)

#define dsread(dev) (dev->device.status)

#define ddwrite(dev, data) (dev->device.data = (data))
#define ddread(dev) (dev->device.data)