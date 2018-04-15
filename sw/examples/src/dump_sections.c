#include <plasma.h>
#include <no_os.h>
#include <kernel/device.h>
#include <dev/counter.h>
#include <dev/irc.h>
#include <dev/gpio.h>
#include <dev/display.h>
#include <kernel/devicemap.h>
#include <kernel/interrupt.h>


extern char __bss_start, __bss_size;
extern char __sbss_start, __sbss_size;

extern char __rom_data_start, __rom_sdata_start;
extern char __data_start, __data_size;
extern char __sdata_start, __sdata_size;

extern kir_handler ir_handlers[32];

int main()
{

    // Setup interrupt controller
    irc0->mask = 0x00000000; // ignore all
    kir_enable(0);

    // enable gpio
    device_enable(&gpio0->device);

    // dump rom data start
    gpio0->device.data = __rom_data_start;
    gpio0->device.data = __rom_sdata_start;

    // dump bss / sbss start
    gpio0->device.data = __bss_start;
    gpio0->device.data = __sbss_start;

    // dump data / sdata start
    gpio0->device.data = __data_start;
    gpio0->device.data = __sdata_start;

    // dump isr_table start
    gpio0->device.data =  ir_handlers;

    // dump isr_table content
    for(int i = 0; i < 32; i++)
        gpio0->device.data =  ir_handlers[i];
}