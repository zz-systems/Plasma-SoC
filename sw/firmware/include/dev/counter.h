// --------------------------------------------------------------------------------
// -- TITLE:  Counter device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- COUNTER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x0       | r/w   | control register
// -- status       | 0x4       | r     | status register
// -- data         | 0x8       | r     | current counter value
// -- reload       | 0xC       | r/w   | reload value on overflow
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | user reset
// -- enable       | 1         | r/w   | enable counter
// -- autoreload   | 2         | r/w   | reload on overflow
// -- direction    | 3         | r/w   | direction (0 = count up, 1 = count down)
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | counter ready
// -- overflow     | 1         | r     | counter overflow, reloaded
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

// control register bits
#define COUNTER_CONTROL_AUTORESET           0x04 

// count modes
#define COUNTER_COUNT_UP                    0x00
#define COUNTER_COUNT_DOWN                  0x08 

// status register bits
#define COUNTER_STATUS_OVERFLOW             0x01

typedef struct
{
    device_t    device;
    reg32_t     reload;
} counter_t;


void counter_set_reload(counter_t* counter, uint32_t value);
void counter_reset(counter_t* counter, uint32_t flags);
void counter_enable(counter_t* counter, uint32_t flags);