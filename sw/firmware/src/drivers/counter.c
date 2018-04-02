#include "dev/counter.h"
#include "kernel/io.h"

void counter_set_reload(counter_t* counter, uint32_t value)
{
    counter->reload = value;
}

void counter_reset(counter_t* counter, uint32_t flags)
{
    dcwrite(counter, DEVICE_RESET | flags);
    dcwrite(counter, flags);
}

void counter_enable(counter_t* counter, uint32_t flags)
{
    dcwrite(counter, DEVICE_ENABLE | flags);
}