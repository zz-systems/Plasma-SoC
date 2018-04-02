#include "dev/timer.h"
#include "kernel/io.h"

void timer_set_unit(timer_t* timer, uint32_t unit)
{
    // clear unit bits
    timer->device.control &= ~(0x7 << 3);
    // set unit
    timer->device.control |= (unit & 0x7) << 3;
}

void timer_set_autoreset(timer_t* timer, int value)
{
    if(value) // set
        timer->device.control |= TIMER_CONTROL_AUTORESET;
    else // clear
        timer->device.control &= ~TIMER_CONTROL_AUTORESET;
}

void timer_set_reload(timer_t* timer, uint32_t value)
{
    timer->reload = value;
}