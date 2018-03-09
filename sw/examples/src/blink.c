#include "plasma.h"
#include "no_os.h"

void wait_for(int msec);

int main()
{
    MemoryWrite(IRC_EDGE, 0x00000088);      // TMO & GPIO0
    MemoryWrite(IRC_ENABLE, 0x00000089);    // TMO, UART, GPIO0
    OS_AsmInterruptEnable(1);

	//MemoryWrite(IRQ_MASK, 0x02);
	puts("Hello MAIN\n");
	//while((MemoryRead(IRQ_STATUS) & IRQ_UART_WRITE_AVAILABLE) == 0)
      	//    MemoryWrite(GPIO0_SET, 0xFFFFFFFF);

	while(1)
	{
        //puts("Hello SDCARD\n");
        puts("Hello UART\n");

        MemoryWrite(GPIO0_SET, 0x00000000);
        puts("LED OFF\n");
		wait_for(500);

		// Does not work
		//MemoryWrite(GPIO0_CLEAR, 0xFFFFFFFF);

        MemoryWrite(GPIO0_SET, 0xFFFFFFFF);
        puts("LED ON\n");
		wait_for(500);
	}

while(1)
	;
}

void wait_for(int msec)
{
    // TODO: Implement configurable counter (Interrupts?)
    // Simulation yielded 4 clocks per loop iteration
    // 8 clocks for WB with ACK
    long clocks_per_tick    = 8; //4;

    long ticks_per_second   = PLASMA_CLOCK / clocks_per_tick;
    //double scale            = 0.5;//msec / 1000.0;
    //long ticks              = ticks_per_second * scale;

    //// plasma does not support fp-division - invert scale
    //double rscale = 1000.0 / msec;
    //long ticks = ticks_per_second / rscale;

    // plasma division seems not to work. Use constant evaluation...
    long ticks = ticks_per_second / 2;

    int wait = 0;

    for(wait = 0; wait < ticks; wait++)
            __asm__ __volatile__("nop");
}