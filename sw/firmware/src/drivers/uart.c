#include "dev/uart.h"
#include "kernel/io.h"

void uart_reset(uart* uart)
{
    device_reset(&uart->device);
}

void uart_enable(uart* uart)
{
    device_enable(&uart->device);
}

void uart_disable(uart* uart)
{
    device_disable(&uart->device);
}

uint8_t uart_read(uart* uart)
{
    return dread(&uart->device);
}

void uart_write(uart* uart, uint8_t data)
{
    dwrite(&uart->device, data);
}