#include "kernel/memory.h"

extern unsigned __bss_start, __bss_end;
extern unsigned __sbss_start, __sbss_end;

extern unsigned __rom_data_start, __rom_sdata_start;
extern unsigned __data_start, __data_end;
extern unsigned __sdata_start, __sdata_end;

void kinit_sections()
{    
    // clear bss 
    for(unsigned* __bss = &__bss_start; __bss < &__bss_end;)
        *(__bss++) = 0;

    // clear sbss 
    for(unsigned* __sbss = &__sbss_start; __sbss < &__sbss_end;)
        *(__sbss++ )= 0;

    // copy data
    for(unsigned* __data = &__data_start, *__rom_data = &__rom_data_start; __data < &__data_end;)
        *(__data++) = *(__rom_data++);

    // copy sdata
    for(unsigned* __sdata = &__data_start, *__rom_sdata = &__rom_sdata_start; __sdata < &__sdata_end;)
        *(__sdata++) = *(__rom_sdata++);
}