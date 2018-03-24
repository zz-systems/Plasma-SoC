#include "kernel/device.h"

void device_await_ready(device* device)
{
    while((device->status & DEVICE_READY) == 0);
}

void device_await_data(device* device)
{
    while((device->status & DEVICE_DAVAIL) == 0);
}

void device_reset(device* device)
{
    device->control |= DEVICE_RESET;
    device->control &= ~DEVICE_RESET;

    //device_await_ready(device);
}

void device_enable(device* device)
{
    device->control |= DEVICE_ENABLE;

    //device_await_ready(device);
}

void device_disable(device* device)
{
    device->control &= ~DEVICE_ENABLE;
}