#include "kernel/device.h"

void device_await_ready(device_t* device)
{
    while((device->status & DEVICE_READY) == 0);
}

void device_await_data(device_t* device)
{
    while((device->status & DEVICE_DAVAIL) == 0);
}

void device_reset(device_t* device)
{
    device->control |= DEVICE_RESET;
    device->control &= ~DEVICE_RESET;

    //device_await_ready(device);
}

void device_enable(device_t* device)
{
    device->control |= DEVICE_ENABLE;

    //device_await_ready(device);
}

void device_disable(device_t* device)
{
    device->control &= ~DEVICE_ENABLE;
}