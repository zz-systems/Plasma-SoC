// --------------------------------------------------------------------------------
// -- TITLE:  Plasma UART controller device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- INTERRUPT CONTROLLER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x00      | r/w   | control register
// -- status       | 0x04      | r     | status register
// -- data         | 0x0C      | r/w   | UART RX/TX
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | reset device
// -- enable       | 1         | r/w   | enable device
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | device ready
// -- davail       | 1         | r     | data available
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

typedef struct uart_device
{
    device device;
} uart;


void uart_reset     (uart* uart);
void uart_enable    (uart* uart);
void uart_disable   (uart* uart);
uint8_t uart_read   (uart* uart);
void uart_write     (uart* uart, uint8_t data);