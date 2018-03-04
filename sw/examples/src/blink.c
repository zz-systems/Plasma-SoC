#include "plasma.h"
#include "no_os.h"

void wait_for(int msec);

int plasma_main()
{
	while(1)
	{
        //puts("Hello SDCARD\n");

        MemoryWrite(GPIO0_SET, 0x00000000);
        //puts("LED OFF\n");
		//wait_for(500);

		// Does not work
		//MemoryWrite(GPIO0_CLEAR, 0xFFFFFFFF);

        MemoryWrite(GPIO0_SET, 0xFFFFFFFF);
        //puts("LED ON\n");
		//wait_for(500);
	}

while(1)
	;
}

void wait_for(int msec)
{
    long ticks_for_second   = PLASMA_CLOCK / 6.25;
    double scale            = 0.5;//(msec / 1000.0);
    long ticks              = ticks_for_second * scale;

    int wait = 0;

    for(wait = 0; wait < ticks; wait++)
            __asm__ __volatile__("nop");
}
