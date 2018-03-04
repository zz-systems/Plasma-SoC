#include "plasma.h"
#include "no_os.h"


int plasma_main()
{
	while(1)
	{
		MemoryWrite(GPIO0_SET, 0xFFFFFFFF);

		wait_for(500);

		// Does not work
		//MemoryWrite(GPIO0_CLEAR, 0xFFFFFFFF);
		MemoryWrite(GPIO0_SET, 0x00000000);

		wait_for(500);
	}

while(1)
	;
}
