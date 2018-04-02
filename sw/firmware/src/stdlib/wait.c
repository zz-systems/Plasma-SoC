#include "sys/wait.h"
#include "dev/timer.h"
#include "kernel/devicemap.h"

void wait(int msec)
{
    timer_set_unit(timer0, TIMER_UNIT_MSEC);
    timer_set_autoreset(timer0, TRUE);
    timer_set_reload(timer0, msec);
    device_enable(&timer0->device);

    while(ddread(timer0) > 0);
}