#include "plasma.h"
#include "no_os.h"
#include "kernel/device.h"
#include "dev/counter.h"
#include "dev/irc.h"
#include "dev/gpio.h"
#include "dev/display.h"
#include "dev/timer.h"

#include "kernel/devicemap.h"
#include "kernel/interrupt.h"
#include "kernel/io.h"

#include "sys/file.h"
#include "sys/string.h"

int current_pos     = 0;
int led_on          = 0;
int total_sec       = 0;

FILE *uart_file     = NULL;
FILE *display_file  = NULL;

void irc_uart_input();
void irc_flush_io();
void irc_blink();
void irc_display();

void access_violation_irc();

void irc_clock();

char* clock_str = "00:00:00";
char led_state_str[16] = "";
char uart_in_str[32] = "",  *uart_in_str_ptr = uart_in_str;
int main()
{
    // Setup interrupts

    kregister_ir_handler(irc_uart_input,        IRQ_UART_READ_AVAILABLE);
    kregister_ir_handler(irc_clock,             IRQ_TIMER0);

    kregister_ir_handler(irc_display,           IRQ_COUNTER0);
    kregister_ir_handler(irc_blink,             IRQ_COUNTER1);
    kregister_ir_handler(irc_flush_io,          IRQ_COUNTER2);

    kregister_ir_handler(access_violation_irc,  IRQ_BUS_ERR);

    OS_AsmInterruptEnable(1);

    uart_file = fopen("dev/uart0", "rw");

    // enable uart
    device_enable(&uart0->device);

    display_file    = fopen("dev/display0", "w");

    // enable display
    device_enable(&display0->device);
    display_set_textmode(display0);
    display_clear(display0);
    device_await_ready(&display0->device);

    counter_set_reload(counter0, TICKS_PER_MS * 25);
    counter_reset(counter0, COUNTER_COUNT_DOWN);
    counter_enable(counter0, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter1, TICKS_PER_MS * 125);
    counter_reset(counter1, COUNTER_COUNT_DOWN);
    counter_enable(counter1, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter2, TICKS_PER_MS * 10);
    counter_reset(counter2, COUNTER_COUNT_DOWN);
    counter_enable(counter2, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    timer_set_unit(timer0, TIMER_UNIT_SEC);
    timer_set_autoreset(timer0, TRUE);
    timer_set_reload(timer0, 1);
    device_enable(&timer0->device);


    fprint(uart_file, "Hello MAIN\r\n");

	while(1);
}

void irc_uart_input()
{
    char c = (char) ddread(uart0);
    fwrite(uart_file, c);
    
    if(uart_in_str_ptr >= uart_in_str && uart_in_str_ptr < uart_in_str + 32)
    {
        switch(c)
        {
            case 0x08:  // BS
            case 0x7F:  // DEL
                *(uart_in_str_ptr--) = ' ';
                break;
            default:
                *(uart_in_str_ptr++) = c;
                break;
        }
    }
    //fprint(uart_file, "UART HAS DATA\r\n");
}

void irc_clock()
{  
    total_sec++;
    int sec = total_sec % 60;
    int min = (total_sec / 60) % 60;
    int hr  = total_sec / 3600;

    char buf[8];

    itoa(sec, buf);
    
    if(sec < 10)
    {
        clock_str[7] = buf[0];
        clock_str[6] = '0';
    } 
    else 
    {
        clock_str[7] = buf[1];
        clock_str[6] = buf[0];
    }

    itoa(min, buf);

    if(min < 10)
    {
        clock_str[4] = buf[0];
        clock_str[3] = '0';
    } 
    else 
    {
        clock_str[4] = buf[1];
        clock_str[3] = buf[0];
    }

    itoa(hr,  buf);    

    if(hr < 10)
    {
        clock_str[1] = buf[0];
        clock_str[0] = '0';
    } 
    else 
    {
        clock_str[1] = buf[1];
        clock_str[0] = buf[0];
    }
}

void irc_display()
{
    //display_reset(display0);    

    if(dsread(display0) & DEVICE_READY)
    {
        fprint(display_file, "Time: ");
        fprint(display_file, clock_str);

        fseek (display_file, 16, SEEK_SET);
        fprint(display_file, led_state_str);

        fseek (display_file, 32, SEEK_SET);
        fprint(display_file, uart_in_str);

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
        strcpy(led_state_str, "IRC LED ON ");

        if(current_pos > 7)
            current_pos = 0;
    }
    else
    {
        gpio0->device.data = 0x00000000;
        strcpy(led_state_str, "IRC LED OFF");
    }
}

void access_violation_irc()
{
    fprint(uart_file, "ACCESS VIOLATION!\r\n");
}