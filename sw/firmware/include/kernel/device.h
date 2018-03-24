// --------------------------------------------------------------------------------
// -- TITLE:  device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------

#pragma once
#include "sys/types.h"

// common control register bits
#define DEVICE_RESET                        0x01 
#define DEVICE_ENABLE                       0x02

// common status register bits
#define DEVICE_READY                        0x01
#define DEVICE_DAVAIL                       0x02

typedef struct
{
    reg32_t control;
    reg32_t status;
    reg32_t data;
} volatile device;


void device_await_ready     (device* device);
void device_await_data      (device* device);
void device_reset           (device* device);
void device_enable          (device* device);
void device_disable         (device* device);