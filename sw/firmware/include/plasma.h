/*--------------------------------------------------------------------
 * TITLE: Plasma Hardware Defines
 * AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
 * DATE CREATED: 12/17/05
 * FILENAME: plasma.h
 * PROJECT: Plasma CPU core
 * COPYRIGHT: Software placed into the public domain by the author.
 *    Software 'as is' without warranty.  Author liable for nothing.
 * DESCRIPTION:
 *    Plasma Hardware Defines
 *--------------------------------------------------------------------*/
#ifndef __PLASMA_H__
#define __PLASMA_H__

// 50 MHz
#define PLASMA_CLOCK      (50 * 1000 * 1000)
#define TICKS_PER_S       (PLASMA_CLOCK)
#define TICKS_PER_MS      (TICKS_PER_S / 1000)
#define TICKS_PER_US      (TICKS_PER_MS / 1000)
#define TICKS_PER_NS      (TICKS_PER_NS / 1000)
#define TICKS_PER_TICK    (1)

/*********** Hardware addresses ***********/
#define RAM_INTERNAL_BASE 0x00000000 //8KB
#define RAM_EXTERNAL_BASE 0x10000000 //1MB or 64MB
#define RAM_EXTERNAL_SIZE 0x00100000
#define ETHERNET_RECEIVE  0x13ff0000
#define ETHERNET_TRANSMIT 0x13fe0000
#define UART_WRITE        0x20000100
#define UART_READ         0x20000100
#define MISC_BASE         0x20000100
#define ETHERNET_REG      0x20000270
#define FLASH_BASE        0x30000000

#define IRC_BASE          0x20000000
#define IRC_CONTROL         (IRC_BASE + 0x00)
#define IRC_STATUS          (IRC_BASE + 0x10)
#define IRC_FLAGS_RAW       (IRC_BASE + 0x20)
#define IRC_FLAGS           (IRC_BASE + 0x30)
#define IRC_CLEAR           (IRC_BASE + 0x40)
#define IRC_INVERT          (IRC_BASE + 0x50)
#define IRC_ENABLE          (IRC_BASE + 0x60)
#define IRC_EDGE            (IRC_BASE + 0x70)

#define COUNTER_BASE      0x20000200
#define COUNTER_CONTROL   (COUNTER_BASE + 0x00)
#define COUNTER_STATUS    (COUNTER_BASE + 0x10)
#define COUNTER_DATA      (COUNTER_BASE + 0x20)
#define COUNTER_RELOAD    (COUNTER_BASE + 0x30)

#define GPIO0_BASE          0x20000300
#define GPIO0_CONTROL       (GPIO0_BASE + 0x00)
#define GPIO0_STATUS        (GPIO0_BASE + 0x10)
#define GPIO0_DATA          (GPIO0_BASE + 0x20)
#define GPIO0_MASK          (GPIO0_BASE + 0x30)

#define SPI_BASE          0x20000400
#define SPI_DATA          (SPI_BASE + 0x00)
#define SPI_CONTROL       (SPI_BASE + 0x10)

#define DISPLAY_BASE	  0x40000000
#define DISPLAY_CONTROL	  (DISPLAY_BASE + 0x00)
#define DISPLAY_STATUS	  (DISPLAY_BASE + 0x10)
#define DISPLAY_DATA	  (DISPLAY_BASE + 0x20)

/*********** GPIO out bits ***************/
#define ETHERNET_MDIO     0x00200000
#define ETHERNET_MDIO_WE  0x00400000
#define ETHERNET_MDC      0x00800000
#define ETHERNET_ENABLE   0x01000000

/*********** Interrupt bits **************/
#define IRQ_UART_READ_AVAILABLE  0x01
#define IRQ_UART_WRITE_AVAILABLE 0x02
#define IRQ_COUNTER0             0x04
#define IRQ_GPIO0                0x08

#define IRQ_ETHERNET_RECEIVE     0x10
#define IRQ_ETHERNET_TRANSMIT    0x20
#define IRQ_GPIO31_NOT           0x40
#define IRQ_GPIO31               0x80

/************** SPI bits *****************/
#define SPI_ENABLE               0x01 // control reg
#define SPI_BUSY                 0x01 // status reg
#define SPI_HAS_DATA             0x02 // status reg

/************ COUNTER bits ***************/
#define COUNTER_RESET            0x01 // control reg
#define COUNTER_ENABLE           0x02 // control reg
#define COUNTER_AUTORESET        0x04 // control reg
#define COUNTER_DIRECTION        0x08 // control reg

#define DISPLAY_READY            0x01 // status reg

/************ DISPLAY bits ***************/
#define DISPLAY_RESET            0x01 // control reg
#define DISPLAY_IMMEDIATE        0x02 // control reg
#define DISPLAY_TEXTMODE         0x04 // control reg
#define DISPLAY_FLUSH            0x08 // control reg

#define DISPLAY_READY            0x01 // status reg


#define MemoryRead(A) (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) (*(volatile unsigned int*)(A)=(V))

extern void OS_AsmInterruptEnable(unsigned enable);

#endif //__PLASMA_H__