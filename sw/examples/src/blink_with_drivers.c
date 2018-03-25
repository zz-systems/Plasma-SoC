#include "plasma.h"
#include "no_os.h"
#include "kernel/device.h"
#include "dev/counter.h"
#include "dev/irc.h"
#include "dev/gpio.h"
#include "dev/display.h"
#include "kernel/devicemap.h"
#include "kernel/interrupt.h"
#include "kernel/io.h"

#include "sys/file.h"




int current_pos     = 0;
int led_on          = 0;

FILE *uart_file     = NULL;
FILE *display_file  = NULL;

void wait(int msec);

void irc_uart_input();
void irc_flush_io();
void irc_blink();
void irc_display();

void access_violation_irc();

int main()
{
    // Setup interrupts

    //kregister_ir_handler(irc_uart_input,    0);
    kregister_ir_handler(irc_display,       2);
    kregister_ir_handler(irc_blink,         3);
    kregister_ir_handler(irc_flush_io,      4);

    kregister_ir_handler(access_violation_irc, 31);

    OS_AsmInterruptEnable(1);

    // enable display
    // device_enable(&display0->device);
    // display_set_textmode(display0);

    // device_await_ready(&display0->device);
    // for(int i = 0; i < 64; i++)
    // {
    //     *(((char*)&display0->device.data) + i) = 'A';
    // }

    // device_descriptor_t display_descriptor = 
    // {
    //      .device = &display0->device, 
    //      .type = DEVICE_DISPLAY 
    // };

    //display_file = fdopen(display_descriptor, FILE_WRITE_MODE);
    //display_file = fopen("dev/display0", "w");
    // fprint(display_file, "Test!");
    // fflush(display_file);
    // display_flush(display0);

    //display_flush(display0);
    // Configure UART

    // Fake fopen. dirty. But we have no memory allocation yet
    // uint8_t uart_write_buffer[BUF_SIZE];
    // uint8_t uart_read_buffer[BUF_SIZE];

    //device_descriptor_t uart_descriptor = { .device = &uart0->device, .type = DEVICE_UART };

    // device_descriptor_t uart_descriptor = kdopen("dev/uart0");
    // FILE uart_file_init =
    // {
    //     .device_desc    = &uart_descriptor,
    //     .read_buffer    = uart_read_buffer,
    //     .write_buffer   = uart_write_buffer,

    //     .read_ptr    = uart_read_buffer,
    //     .write_ptr   = uart_write_buffer
    // };
    
    // uart_file = &uart_file_init;

    //uart_file = fdopen(uart_descriptor, FILE_WRITE_MODE | FILE_READ_MODE);
    uart_file = fopen("dev/uart0", "rw");

    // enable uart
    device_enable(&uart0->device);

    // Configure DISPLAY

    // Fake fopen. dirty. But we have no memory allocation yet

    // device_descriptor_t display_descriptor = { .device = &display0->device, .type = DEVICE_DISPLAY };
    // device_descriptor_t display_descriptor = kdopen("dev/display0");
    // FILE display_file_init =
    // {
    //     .device_desc    = &display_descriptor,
    //     .read_buffer    = NULL,
    //     .write_buffer   = (uint8_t*)(&display0->device.data),
    //     .write_ptr      = (uint8_t*)(&display0->device.data)
    // };
    
    // display_file = &display_file_init;

    display_file = fopen("dev/display0", "w");

    // enable display
    device_enable(&display0->device);
    display_set_textmode(display0);

    counter_set_reload(counter0, TICKS_PER_S * 10);
    counter_reset(counter0, COUNTER_COUNT_DOWN);
    counter_enable(counter0, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter1, TICKS_PER_MS * 100);
    counter_reset(counter1, COUNTER_COUNT_DOWN);
    counter_enable(counter1, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter2, TICKS_PER_MS * 10);
    counter_reset(counter2, COUNTER_COUNT_DOWN);
    counter_enable(counter2, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    fprint(uart_file, "Hello MAIN\r\n");

	while(1);
}

void irc_uart_input()
{
    //fprint(uart_file, "UART HAS DATA\r\n");
}

void irc_display()
{
    //display_reset(display0);    

    if(dsread(display0) & DEVICE_READY)
    {
        display_clear(display0);

        device_await_ready(&display0->device);

        fprint(display_file, "Test!");

        // for(int i = 0; i < 64; i++)
        // {
        //     *(((char*)&display0->device.data) + i) = 'A';
        // }

        fflush(display_file);
        display_flush(display0);
    }
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
        gpio0->device.data = 1 << current_pos++;
        fprint(uart_file, "IRC LED ON\r\n");

        if(current_pos > 7)
            current_pos = 0;
    }
    else
    {
        gpio0->device.data = 0x00000000;
        fprint(uart_file, "IRC LED OFF\r\n");
    }
}

void access_violation_irc()
{
    fprint(uart_file, "ACCESS VIOLATION!\r\n");
}

void wait(int msec)
{
    int ticks = TICKS_PER_MS * msec; // 1s?
    
    counter0->reload = ticks;
    counter0->device.control = COUNTER_RESET | COUNTER_COUNT_DOWN;
    counter0->device.control = COUNTER_ENABLE | COUNTER_COUNT_DOWN;

    while(counter0->device.data > 0);
}