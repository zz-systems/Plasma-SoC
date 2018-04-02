#include "plasma.h"
#include "kernel/devicemap.h"
#include "kernel/memory.h"
#include "sys/string.h"


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