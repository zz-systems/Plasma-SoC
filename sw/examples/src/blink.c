#include "plasma.h"
#include "no_os.h"


void wait(int msec);

typedef void (*IR_HANDLER)(void);
extern void OS_RegisterInterrupt(IR_HANDLER handler, unsigned config);

int main()
{
    MemoryWrite(IRC_ENABLE, 0x00000003);    // UART R/W
    OS_AsmInterruptEnable(0);

    puts("Hello MAIN\n");

	while(1)
	{
        MemoryWrite(GPIO0_DATA, 0xFFFFFFFF);
        puts("LED ON\n");
        wait(500);

        MemoryWrite(GPIO0_DATA, 0x00000000);
        puts("LED OFF\n");
        wait(500);
	}

while(1)
	;
}

void wait(int msec)
{
    int ticks = TICKS_PER_MS * msec; // 1s?

    MemoryWrite(COUNTER_RELOAD, ticks); 
    MemoryWrite(COUNTER_CONTROL, COUNTER_RESET | COUNTER_DIRECTION); 
    MemoryWrite(COUNTER_CONTROL, COUNTER_ENABLE | COUNTER_DIRECTION); // enable, count down

    while(MemoryRead(COUNTER_DATA) > 0);
}