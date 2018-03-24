#pragma once 

#include "kernel/device.h"
#include "dev/counter.h"
#include "dev/irc.h"
#include "dev/gpio.h"
#include "dev/uart.h"
#include "dev/display.h"

// extern counter *counter0, *counter1, *counter2, *counter3;
// extern irc *irc0;
// extern gpio *gpio0;
// extern uart *uart0;
// extern display *display0;

#define device_at(device_type, address) ((device_type*)(address))

#define counter0    (device_at(counter_t, COUNTER0_BASE))
#define counter1    (device_at(counter_t, COUNTER1_BASE))
#define counter2    (device_at(counter_t, COUNTER2_BASE))
#define counter3    (device_at(counter_t, COUNTER3_BASE))

#define irc0        (device_at(irc, IRC_BASE))
#define gpio0       (device_at(gpio, GPIO0_BASE))
#define uart0       (device_at(uart, UART0_BASE))
#define display0    (device_at(display, DISPLAY0_BASE))