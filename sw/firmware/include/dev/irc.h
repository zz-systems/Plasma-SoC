// --------------------------------------------------------------------------------
// -- TITLE:  Interrupt controller device
// -- AUTHOR: Sergej Zuyev (sergej.zuyev - at - zz-systems.net)
// --------------------------------------------------------------------------------
// -- INTERRUPT CONTROLLER
// ----------------|-----------|-------|-------------------------------------------
// -- REGISTER     | address   | mode  | description
// ----------------|-----------|-------|-------------------------------------------
// -- control      | 0x00      | r/w   | control register
// -- status       | 0x04      | r     | status register
// -- data         | 0x08      | r     | interrupt flag state
// -- imm flags    | 0x0C      | r     | immediate interrupt flag state (input passthrough)
// -- clear        | 0x10      | r/w   | clear interrupt flag
// -- invert       | 0x14      | r/w   | invert flag
// -- mask         | 0x18      | r/w   | interrupt flag enable/disable mask     
// -- edge         | 0x1C      | r/w   | interrupt edge detection
// ----------------|-----------|-------|-------------------------------------------
// -- CONTROL      |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- reset        | 0         | r/w   | reset device
// -- enable       | 1         | r/w   | enable device
// ----------------|-----------|-------|-------------------------------------------
// -- STATUS       |           |       | 
// ----------------|-----------|-------|-------------------------------------------
// -- ready        | 0         | r     | device ready
// ----------------|-----------|-------|-------------------------------------------

#pragma once

#include "plasma.h"
#include "kernel/device.h"
#include "sys/types.h"

// interrupt bits
#define IRQ_UART_READ_AVAILABLE     0
#define IRQ_UART_WRITE_AVAILABLE    1

#define IRQ_TIMER0                  2
#define IRQ_TIMER1                  3
#define IRQ_TIMER2                  4
#define IRQ_TIMER3                  5

#define IRQ_COUNTER0                6
#define IRQ_COUNTER1                7
#define IRQ_COUNTER2                8
#define IRQ_COUNTER3                9

#define IRQ_GPIO0                   10
#define IRQ_GPIO1                   11
#define IRQ_GPIO2                   12
#define IRQ_GPIO3                   13

#define IRQ_OLEDC                   14

#define IRQ_BUS_ERR                 31

typedef struct
{
    device_t  device;
    reg32_t imm_flags;
    reg32_t clear;
    reg32_t invert;
    reg32_t mask;
    reg32_t edge;
} irc_t;


int irc_is_set      (irc_t *irc, int irq_number);
void irc_clear      (irc_t *irc, int irq_number);
void irc_set_mask   (irc_t *irc, int irq_number, int value);
void irc_set_pol    (irc_t *irc, int irq_number, int value);
void irc_set_edge   (irc_t *irc, int irq_number, int value);