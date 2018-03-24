// --------------------------------------------------------------------------------
// -- TITLE:  Display controller device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- DISPLAY CONTROLLER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x0       | r/w   | control register
// -- status       | 0x4       | r     | status register
// -- data         | 0x8       | w     | vram data window (64 byte)
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | reset device
// -- enable       | 1         | r/w   | enable device
// -- immediate    | 2         | r/w   | immediate mode (immediate SPI commands)
// -- textmode     | 3         | r/w   | text mode (interpret vram as ASCII)
// -- flush        | 4         | r/w   | flush vram to screen
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | display ready
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

// control register bits
#define DISPLAY_CONTROL_IMMEDIATE_ON        0x04
#define DISPLAY_CONTROL_TEXTMODE            0x08
#define DISPLAY_CONTROL_FLUSH               0x0C

// interrupt bits
// TODO


typedef struct display_device
{
    device device;
} display;


void display_reset          (display* display);
void display_enable         (display* display);
void display_disable        (display* display);
void display_set_textmode   (display* display);
void display_set_graphicmode(display* display);
void display_flush          (display* display);