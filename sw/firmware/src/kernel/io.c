#include "kernel/io.h"

uint32_t dread(device* device)
{
    device_await_data(device);

    return device->data;
}

void dwrite(device* device, uint32_t data)
{
    device_await_ready(device);

    device->data = data;
}

int dputc(device* device, int character)
{
    dwrite(device, character);
    return 0;
}

int dgetc(device* device)
{
    return dread(device);
}

int dputs(device* device, const char *string)
{
    while(*string)
    {
        if(*string == '\n')
            dputc(device, '\r');
        dputc(device, *string++);
    }
    return 0;
}