#include "plasma.h"
#include "no_os.h"


void wait(int msec);

typedef void (*IR_HANDLER)(void);
extern void OS_RegisterInterrupt(IR_HANDLER handler, unsigned config);

int main()
{
    //MemoryWrite(IRC_EDGE, 0x00000088);      // TMO & GPIO0
    MemoryWrite(IRC_ENABLE, 0x00000003);    // TMO, UART, GPIO0
    OS_AsmInterruptEnable(0);

    puts("Hello MAIN\n");

	while(1)
	{
        MemoryWrite(GPIO0_DATA, 0x00000000);
        puts("LED OFF\n");
        wait(500);

        MemoryWrite(GPIO0_DATA, 0xFFFFFFFF);
        puts("LED ON\n");
        wait(500);
	}

while(1)
	;
}

void wait(int msec)
{
    int ticks = 12500 * msec; // 1s?

    MemoryWrite(COUNTER_RELOAD, ticks); 
    MemoryWrite(COUNTER_CONTROL, 0x4); // disable, reset, reload
    MemoryWrite(COUNTER_CONTROL, 0x3); // enable, count down

    while(MemoryRead(COUNTER_DATA) > 0);
}