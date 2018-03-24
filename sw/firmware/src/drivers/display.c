#include "dev/display.h"

void display_reset(display* display)
{
    device_reset(&display->device);
}

void display_enable(display* display)
{
    device_enable(&display->device);
}

void display_disable(display* display)
{
    device_disable(&display->device);
}

void display_set_textmode(display* display)
{
    display->device.control |= DISPLAY_CONTROL_TEXTMODE;
}

void display_set_graphicmode(display* display)
{
    display->device.control &= ~DISPLAY_CONTROL_TEXTMODE;
}

void display_flush(display* display)
{
    display->device.control |= DISPLAY_CONTROL_FLUSH;
    display->device.control &= ~DISPLAY_CONTROL_FLUSH;
}

void display_clear(display* display)
{
    display->device.control |= DISPLAY_CONTROL_CLEAR;
    display->device.control &= ~DISPLAY_CONTROL_CLEAR;
}