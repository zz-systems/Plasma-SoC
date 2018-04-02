
#include "dev/irc.h"
#include "kernel/io.h"

int irc_is_set(irc_t *irc, int irq_number)
{
    return dcread(irc) & (1 << irq_number);
}

void irc_clear(irc_t *irc, int irq_number)
{
    // set
    irc->clear |=  (1 << irq_number);

    // clear
    irc->clear &= ~(1 << irq_number);
}

void irc_set_mask(irc_t *irc, int irq_number, int value)
{
    // clear
    irc->mask &= ~(1      << irq_number);

    // set
    irc->mask |=  ((value & 1) << irq_number);
}

void irc_set_pol(irc_t *irc, int irq_number, int value)
{
    // clear
    irc->invert &= ~(1      << irq_number);

    // set
    irc->invert |=  ((value & 1) << irq_number);
}

void irc_set_edge(irc_t *irc, int irq_number, int value)
{
    // clear
    irc->edge &= ~(1      << irq_number);

    // set
    irc->edge |=  ((value & 1) << irq_number);
}