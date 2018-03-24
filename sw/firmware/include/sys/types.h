#pragma once

typedef unsigned int    uint32_t;
typedef unsigned short  uint16_t;
typedef unsigned char   uint8_t;

typedef uint32_t volatile reg32_t;
typedef uint16_t volatile reg16_t;
typedef uint8_t  volatile reg8_t;

typedef uint32_t addr_t;

#define NULL    (0)
#define TRUE    (1)
#define FALSE   (0)

#define set(value, bit) (value | (1 << bit))
#define unset(value, bit) (value & (0 << bit))