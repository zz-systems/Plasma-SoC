#ifndef __NO_OS_H__
#define __NO_OS_H__

#include "plasma.h"

void putchar(int value);

int puts(const char *string);

void OS_InterruptServiceRoutine(unsigned int status);

int kbhit(void);

int getch(void);

void wait_for(int msec);

#endif
