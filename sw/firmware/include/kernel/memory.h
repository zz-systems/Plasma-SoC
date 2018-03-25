#pragma once

#include "sys/types.h"

#define MEMORY_SIZE             (8 * 1024 * 1024)

#define align(address, alignment) (((address) + ((alignment) - 1)) & ~((alignment) - 1))

void* kmalloc(uint32_t size);
void kfree(void* ptr);