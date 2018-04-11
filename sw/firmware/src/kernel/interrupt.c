#include "kernel/interrupt.h"
#include "kernel/devicemap.h"
#include "kernel/io.h"
#include "sys/types.h"

// IR table
ir_handler ir_handlers[32] = { 0 };

void kir_handler()
{  
    int handled = 0;

    for(int i = 0; i < 32; i++)
    {
        int state   = ddread(irc0);
        int flag    = state & (1 << i);

        if(state == 0)
            return;

        if((flag & handled) != 0)
            continue;

        if(flag && ir_handlers[i] != NULL)
        {
            ir_handlers[i]();

            handled |= flag;

            irc_clear(irc0, i);
        }
    }
}

//extern ir_handler ISR_Table[32];

void kregister_ir_handler(ir_handler handler, unsigned ir_flag)
{
    int interrupt   = (ir_flag & 0x001F);
    int polarity    = (ir_flag >> 16) & 1;
    int edge        = (ir_flag >> 17) & 1;

    ir_handlers[interrupt] = handler;

    // implicitly enable interrupt if handler specified
    irc_set_mask(irc0, interrupt, TRUE);

    // set invert and edge flags from configuration
    irc_set_pol(irc0, interrupt, polarity);
    irc_set_edge(irc0, interrupt, edge);
}