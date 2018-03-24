
#include "kernel/interrupt.h"
#include "kernel/devicemap.h"
#include "sys/types.h"

// IR table
ir_handler ir_handlers[33] = { 0 };

// void kregister_ir_handler(ir_handler handler, unsigned ir_flag)
// {
//     if(ir_flag == 0)
//     {
//         ir_handlers[0] = handler;
//     }
//     else 
//     {
//         int flag = 0;

//         while (ir_flag >>= 1) {
//             flag++;
//         }

//         ir_handlers[flag] = handler;
//     }
// }

void kir_handler(int interrupt)
{
    if(ir_handlers[interrupt] != NULL)
        ir_handlers[interrupt]();
    else if(ir_handlers[32] != NULL)
        ir_handlers[32]();
    else 
        gpio0->device.data = 0xDEADBEEF;
}

//extern ir_handler ISR_Table[32];

void kregister_ir_handler(ir_handler handler, unsigned ir_flag)
{
    int index   = (ir_flag & 0x001F);
    int invert  = (ir_flag >> 16) & 1;
    int edge    = (ir_flag >> 17) & 1;
    int clear   = ~(1 << index);

    ir_handlers[index] = handler;

    // implicitly enable interrupt if handler specified
    irc0->mask   |= 1 << index;

    // set invert and edge flags from configuration
    irc0->invert &= clear;
    irc0->invert |= invert;

    irc0->edge &= clear;
    irc0->edge |= edge;
}

// void khandle_interrupt(int interrupt)
// {
//     // if(ISR_Table[interrupt] != NULL)
//     //     ISR_Table[interrupt]();

//     if(interrupt == 2)
//         gpio0->device.data =  ~gpio0->device.data;
// }