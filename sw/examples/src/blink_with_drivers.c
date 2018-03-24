#include "plasma.h"
#include "no_os.h"
#include "kernel/device.h"
#include "dev/counter.h"
#include "dev/irc.h"
#include "dev/gpio.h"
#include "dev/display.h"
#include "kernel/devicemap.h"
#include "kernel/interrupt.h"

#include "sys/file.h"




int current_pos     = 0;
int led_on          = 0;
FILE *uart_file     = NULL;

void wait(int msec);
void irc_flush_io();
void irc_blink();
void irc_reset_display();

void access_violation_irc();

int main()
{
    // Setup interrupt controller
    //irc0->mask = 0x0000000C; // COUNTER1, COUNTER0, UART R/W
    //OS_AsmInterruptEnable(1);

    //OS_RegisterInterrupt(blink_irc, 4);
    //OS_RegisterInterrupt(access_violation_irc, 31);

    kregister_ir_handler(irc_flush_io, 4);
    kregister_ir_handler(irc_blink, 3);
    kregister_ir_handler(irc_reset_display, 2);

    kregister_ir_handler(access_violation_irc, 31);

    OS_AsmInterruptEnable(1);

    // Configure UART

    // Fake fopen. dirty. But we have no memory allocation yet
    buffer_t write_buffer;
    buffer_t read_buffer;

    write_buffer.buf_ptr = write_buffer.buffer;
    read_buffer.buf_ptr = read_buffer.buffer;

    FILE uart_file_init =
    {
        .device         = &uart0->device,
        .read_buffer    = &read_buffer,
        .write_buffer   = &write_buffer
    };
    
    uart_file = &uart_file_init;

    // enable uart
    device_enable(&uart0->device);

    counter_set_reload(counter0, TICKS_PER_S * 8);
    counter_reset(counter0, COUNTER_COUNT_DOWN);
    counter_enable(counter0, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter1, TICKS_PER_MS * 100);
    counter_reset(counter1, COUNTER_COUNT_DOWN);
    counter_enable(counter1, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter2, TICKS_PER_MS * 10);
    counter_reset(counter2, COUNTER_COUNT_DOWN);
    counter_enable(counter2, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    //counter *counter0   = (counter *)   COUNTER0_BASE;
    // counter0->reload = TICKS_PER_S * 8;
    // counter0->device.control = COUNTER_RESET | COUNTER_COUNT_DOWN;
    // counter0->device.control = COUNTER_ENABLE | COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN;


    //counter *counter1   = (counter *)   COUNTER1_BASE;
    // counter1->reload = TICKS_PER_MS * 100;
    // counter1->device.control = COUNTER_RESET | COUNTER_COUNT_DOWN;
    // counter1->device.control = COUNTER_ENABLE | COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN;

    //puts("Hello MAIN\n");
    // int current_value   = 0;

	while(1);
}

void irc_reset_display()
{
    display_reset(display0);
}

void irc_flush_io()
{
    fflush(uart_file);
}


void irc_blink()
{
    led_on = !led_on;

    if(led_on)
    {
        if(current_pos < 7)
            current_pos++;
        else 
            current_pos = 0;

        gpio0->device.data = 1 << current_pos;
        fprint(uart_file, "IRC LED ON\r\n");
        //puts("IRC LED ON\n");
    }
    else
    {
        gpio0->device.data = 0x00000000;
        fprint(uart_file, "IRC LED OFF\r\n");
        //puts("IRC LED OFF\n");
    }
}

void access_violation_irc()
{
    puts("ACCESS VIOLATION!\n");
}

void wait(int msec)
{
    int ticks = TICKS_PER_MS * msec; // 1s?
    
    counter0->reload = ticks;
    counter0->device.control = COUNTER_RESET | COUNTER_COUNT_DOWN;
    counter0->device.control = COUNTER_ENABLE | COUNTER_COUNT_DOWN;

    while(counter0->device.data > 0);
}