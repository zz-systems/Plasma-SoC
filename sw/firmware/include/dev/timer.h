// --------------------------------------------------------------------------------
// -- TITLE:  Timer device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- TIMER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x0       | r/w   | control register
// -- status       | 0x4       | r     | status register
// -- data         | 0x8       | r     | current timer value
// -- reload       | 0xC       | r/w   | reload value on overflow
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | user reset
// -- enable       | 1         | r/w   | enable timer
// -- autoreload   | 2         | r/w   | reload on overflow
// -- unit         | 3:5       | r/w   | timer measurement unit
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | timer ready
// -- overflow     | 1         | r     | timer overflow, reloaded
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

// control register bits
#define TIMER_CONTROL_AUTORESET             (0x04)

// count modes

#define TIMER_UNIT_TICKS                    0x0
#define TIMER_UNIT_NSEC                     0x1
#define TIMER_UNIT_USEC                     0x2
#define TIMER_UNIT_MSEC                     0x3
#define TIMER_UNIT_SEC                      0x4

// status register bits
#define COUNTER_STATUS_OVERFLOW             0x02

typedef struct
{
    device_t    device;
    reg32_t     reload;
} timer_t;


void timer_set_unit(timer_t* timer, uint32_t unit);
void timer_set_autoreset(timer_t* timer, int value);
void timer_set_reload(timer_t* timer, uint32_t value);