#include <plasma_soc.h>

#include <kernel/device.h>
#include <dev/counter.h>
#include <dev/irc.h>
#include <dev/gpio.h>
#include <dev/display.h>
#include <dev/timer.h>

#include <kernel/kernel.h>
#include <kernel/interrupt.h>
#include <kernel/io.h>
#include <kernel/clock.h>

#include <sys/file.h>
#include <sys/string.h>

int current_pos     = 0;
int led_on          = 0;
int total_sec       = 0;

FILE *uart_file     = NULL;
FILE *display_file  = NULL;

char* clock_str = "00:00:00";
char led_state_str[16] = "";
char uart_in_str[32] = "",  *uart_in_str_ptr = uart_in_str;


void irc_uart_input();
void irc_flush_io();
void irc_blink();
void irc_display();

void access_violation_irc();

void irc_clock();

void ito2chars(char* dst, int num);

int main()
{
    // SETUP interrupts
    kir_register_handler(irc_uart_input,        IRQ_UART_READ_AVAILABLE);
    kir_register_handler(irc_clock,             IRQ_TIMER0);

    kir_register_handler(irc_display,           IRQ_COUNTER0);
    kir_register_handler(irc_blink,             IRQ_COUNTER1);
    kir_register_handler(irc_flush_io,          IRQ_COUNTER2);

    kir_register_handler(access_violation_irc,  IRQ_BUS_ERR);

    kir_enable(1);

    // SETUP UART
    uart_file = fopen("dev/uart0", "rw");

    // enable uart
    kd_enable(&uart0->device);

    // SETUP display
    display_file    = fopen("dev/display0", "w");

    // enable display
    kd_enable(&display0->device);
    display_set_textmode(display0);
    display_clear(display0);
    kd_await_ready(&display0->device);

    // SETUP counters
    counter_set_reload(counter0, TICKS_PER_MS * 25);
    counter_reset(counter0, COUNTER_COUNT_DOWN);
    counter_enable(counter0, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter1, TICKS_PER_MS * 125);
    counter_reset(counter1, COUNTER_COUNT_DOWN);
    counter_enable(counter1, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    counter_set_reload(counter2, TICKS_PER_MS * 10);
    counter_reset(counter2, COUNTER_COUNT_DOWN);
    counter_enable(counter2, COUNTER_CONTROL_AUTORESET | COUNTER_COUNT_DOWN);

    // SETUP timer
    timer_set_unit(timer0, TIMER_UNIT_SEC);
    timer_set_autoreset(timer0, TRUE);
    timer_set_reload(timer0, 1);
    kd_enable(&timer0->device);

    fprint(uart_file, "\r\nHello MAIN\r\n");

    strcpy(clock_str, "00:00:00");
    strcpy(uart_in_str, "");

    return 0;
}

void irc_uart_input()
{
    char c = (char) kdd_read(uart0);

    if(uart_in_str_ptr < uart_in_str)
        return;
    if(uart_in_str_ptr > uart_in_str + 32)
        return;

    //if(uart_in_str_ptr >= uart_in_str && uart_in_str_ptr <= uart_in_str + 32)
    {
        fwrite(uart_file, c);

        switch(c)
        {
            case 0x08:  // BS
            case 0x7F:  // DEL
                if(uart_in_str_ptr > uart_in_str)
                    *(--uart_in_str_ptr) = ' ';
                break;
            default:
                if(uart_in_str_ptr < uart_in_str + 32)
                    *(uart_in_str_ptr++) = c;
                break;
        }
    }
}

void irc_clock()
{  
    int sec = total_sec % 60;
    int min = (total_sec / 60) % 60;
    int hr  = total_sec / 3600;
    
    total_sec++;

    ito2chars(&clock_str[6], sec);
    ito2chars(&clock_str[3], min);
    ito2chars(&clock_str[0], hr);
}

void ito2chars(char* dst, int num)
{
    char buf[2]; 

    itoa(num, buf);
    
    if(num < 10)
    {
        dst[1] = buf[0];
        dst[0] = '0';
    } 
    else 
    {
        dst[1] = buf[1];
        dst[0] = buf[0];
    }
}

void irc_display()
{
    if(kds_test(display0, DEVICE_READY))
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
        kdd_write(gpio0, 1 << current_pos++);
        strcpy(led_state_str, "IRC LED ON ");

        if(current_pos > 7)
            current_pos = 0;
    }
    else
    {
        kdd_write(gpio0, 0);
        strcpy(led_state_str, "IRC LED OFF");
    }
}

void access_violation_irc()
{
    fprint(uart_file, "ACCESS VIOLATION!\r\n");
}