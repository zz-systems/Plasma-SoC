// --------------------------------------------------------------------------------
// -- TITLE:  Interrupt controller device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- INTERRUPT CONTROLLER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x00      | r/w   | control register
// -- status       | 0x04      | r     | status register
// -- data         | 0x08      | r     | interrupt flag state
// -- imm flags    | 0x0C      | r     | immediate interrupt flag state (input passthrough)
// -- clear        | 0x10      | r/w   | clear interrupt flag
// -- invert       | 0x14      | r/w   | invert flag
// -- mask         | 0x18      | r/w   | interrupt flag enable/disable mask     
// -- edge         | 0x1C      | r/w   | interrupt edge detection
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | reset device
// -- enable       | 1         | r/w   | enable device
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | device ready
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

typedef struct irc_device
{
    device  device;
    reg32_t imm_flags;
    reg32_t clear;
    reg32_t invert;
    reg32_t mask;
    reg32_t edge;
} irc;