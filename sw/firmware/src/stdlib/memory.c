#include "sys/memory.h"
#include "kernel/memory.h"

void* malloc(uint32_t size)
{
    return kmalloc(size);
}

void free(void* ptr)
{
    kfree(ptr);
}