#pragma once 

#include "kernel/device.h"
#include "dev/counter.h"
#include "dev/irc.h"
#include "dev/gpio.h"
#include "dev/uart.h"
#include "dev/display.h"
#include "dev/timer.h"


#define IRC_BASE            0x20000000
#define UART0_BASE          0x20000100

#define TIMER0_BASE         0x20000200
#define TIMER1_BASE         (TIMER1_BASE + 0x10)
#define TIMER2_BASE         (TIMER2_BASE + 0x20)
#define TIMER3_BASE         (TIMER3_BASE + 0x30)

#define COUNTER0_BASE       0x20000300
#define COUNTER1_BASE       (COUNTER0_BASE + 0x10)
#define COUNTER2_BASE       (COUNTER0_BASE + 0x20)
#define COUNTER3_BASE       (COUNTER0_BASE + 0x30)

#define GPIO0_BASE          0x20000400
#define GPIO1_BASE          (GPIO0_BASE + 0x10)
#define GPIO2_BASE          (GPIO0_BASE + 0x20)
#define GPIO3_BASE          (GPIO0_BASE + 0x30)

#define SPI_BASE            0x20000500
#define DISPLAY0_BASE	    0x40000000


#define bind_device(device_type, address) ((device_type*)(address))



#define irc0        (bind_device(irc_t, IRC_BASE))
#define uart0       (bind_device(uart,  UART0_BASE))

#define timer0      (bind_device(timer_t, TIMER0_BASE))
#define timer1      (bind_device(timer_t, TIMER1_BASE))
#define timer2      (bind_device(timer_t, TIMER2_BASE))
#define timer3      (bind_device(timer_t, TIMER3_BASE))

#define counter0    (bind_device(counter_t, COUNTER0_BASE))
#define counter1    (bind_device(counter_t, COUNTER1_BASE))
#define counter2    (bind_device(counter_t, COUNTER2_BASE))
#define counter3    (bind_device(counter_t, COUNTER3_BASE))

#define gpio0       (bind_device(gpio_t, GPIO0_BASE))
#define gpio1       (bind_device(gpio_t, GPIO1_BASE))
#define gpio2       (bind_device(gpio_t, GPIO2_BASE))
#define gpio3       (bind_device(gpio_t, GPIO3_BASE))

#define display0    (bind_device(display, DISPLAY0_BASE))

typedef enum 
{
    DEVICE_UNKNOWN,
    DEVICE_COUNTER,
    DEVICE_TIMER,
    DEVICE_IRC,
    DEVICE_GPIO,
    DEVICE_UART,
    DEVICE_DISPLAY,
    DEVICE_FS
} devices_t;

device_descriptor_t *kdopen(const char* path);