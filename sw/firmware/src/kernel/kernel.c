#include "plasma.h"
#include "kernel/devicemap.h"
#include "kernel/memory.h"


// irc     *irc0       = (irc *)       IRC_BASE;
// uart    *uart0      = (uart *)      UART0_BASE;

// counter *counter0   = (counter *)   COUNTER0_BASE;
// counter *counter1   = (counter *)   COUNTER1_BASE;
// counter *counter2   = (counter *)   COUNTER2_BASE;
// counter *counter3   = (counter *)   COUNTER3_BASE;

// gpio    *gpio0      = (gpio *)      GPIO0_BASE;
// display *display0   = (display *)   DISPLAY0_BASE;


device_descriptor_t *kdopen(const char* path)
{
    device_descriptor_t *descriptor = (device_descriptor_t*) kmalloc(sizeof(device_descriptor_t));
    if(descriptor != NULL)
    {    
        descriptor->device = NULL;
        descriptor->type = DEVICE_UNKNOWN;

        if(strcmp(path, "dev/counter0") == 0)
        {
            descriptor->device = &counter0->device;
            descriptor->type = DEVICE_COUNTER; 
        }
        else if(strcmp(path, "dev/counter1") == 0)
        {
            descriptor->device  = &counter1->device;
            descriptor->type    = DEVICE_COUNTER;
        }
        else if(strcmp(path, "dev/counter2") == 0)
        {
            descriptor->device = &counter2->device;
            descriptor->type = DEVICE_COUNTER;
        }
        else if(strcmp(path, "dev/counter3") == 0)
        {
            descriptor->device = &counter3->device;
            descriptor->type = DEVICE_COUNTER; 
        }
        else if(strcmp(path, "dev/irc0") == 0)
        {
            descriptor->device = &irc0->device;
            descriptor->type = DEVICE_IRC; 
        }
        else if(strcmp(path, "dev/gpio0") == 0)
        {
            descriptor->device = &gpio0->device;
            descriptor->type = DEVICE_GPIO; 
        }
        else if(strcmp(path, "dev/uart0") == 0)
        {
            descriptor->device = &uart0->device;
            descriptor->type = DEVICE_UART; 
        }
        else if(strcmp(path, "dev/display0") == 0)
        {
            descriptor->device = &display0->device;
            descriptor->type = DEVICE_DISPLAY;
        }
    }

    return descriptor;
}