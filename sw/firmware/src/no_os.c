#include "plasma.h"
#include "no_os.h"
#include "kernel/devicemap.h"
#include "kernel/io.h"


void putchar(int value)
{
    while((irc0->device.data & IRQ_UART_WRITE_AVAILABLE) == 0);
    uart0->device.data = value;
}

int puts(const char *string)
{
   while(*string)
   {
      if(*string == '\n')
         putchar('\r');
      putchar(*string++);
   }
   return 0;
    //return dputs(&uart0->device, string);
}

void OS_InterruptServiceRoutine(unsigned int status)
{
//    (void)status;
//    putchar('I');
}

int kbhit(void)
{
    return irc0->device.data & IRQ_UART_READ_AVAILABLE;
}

int getch(void)
{
   while(!kbhit());

   //return dread(&uart0->device);
   return MemoryRead(UART_READ);
}

//void wait_for(int msec)
//{
//	long ticks = PLASMA_CLOCK * (msec / 10000);
//	for(int wait = 0; wait < ticks; wait++)
//		__asm__ __volatile__("nop");
//}
