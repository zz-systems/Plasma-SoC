// extern char __bss_start, __bss_size;
// extern char __sbss_start, __sbss_size;

// extern char __rom_data_start, __rom_sdata_start;
// extern char __data_start, __data_size;
// extern char __sdata_start, __sdata_size;

// void kinit_sections()
// {
//     char *__bss = &__bss_start;
//     char *__sbss = &__sbss_start;

//     char *__rom_data = &__rom_data_start;
//     char *__rom_sdata = &__rom_sdata_start;

//     char *__data = &__data_start;
//     char *__sdata = &__sdata_start;

    
//     // clear bss 
//     for(int i = 0; i < __bss_size; i++)
//         __bss[i] = 0;

//     // clear sbss 
//     for(int i = 0; i < __sbss_size; i++)
//         __sbss[i] = 0;

//     // copy data
//     for(int i = 0; i < __data_size; i++)
//         __data[i] = __rom_data[i];

//     // copy sdata
//     for(int i = 0; i < __sdata_size; i++)
//         __sdata[i] = __rom_sdata[i];
// }


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