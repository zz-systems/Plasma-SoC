// -- TITLE:  GPIO device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- GPIO
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x0       | r/w   | control register
// -- status       | 0x4       | r     | status register
// -- data         | 0x8       | r/w   | GPIO data
// -- mask         | 0xC       | r/w   | GPIO irq mask
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | user reset
// -- irq mask en  | 1         | r/w   | use irq mask
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | gpio ready
// -- davail       | 1         | r     | data available
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

// control register bits
#define COUNTER_CONTROL_RESET               0x01 
#define COUNTER_CONTROL_ENABLE              0x02

// interrupt bits
// TODO

// status register bits
#define COUNTER_STATUS_READY                0x00

typedef struct gpio_device
{
    device  device;
    reg32_t mask;
} gpio;