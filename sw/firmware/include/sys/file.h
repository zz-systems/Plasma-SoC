#pragma once

#include "kernel/device.h"

#define BUF_SIZE 64
#define FILE_READ_MODE  0x1
#define FILE_WRITE_MODE 0x2

#define FILE_ERR_BUFFER_FULL 0x1
#define FILE_ERR_MODE_WRONG 0x2

typedef struct
{
    device *device;
    uint8_t *read_buffer;
    uint8_t *write_buffer;

    uint8_t *read_ptr;
    uint8_t *write_ptr;
    int err;
} FILE;

FILE* fopen(device* device, char mode);
void fclose(FILE* file);
int fwrite(FILE* file, uint8_t data);
int fprint(FILE* file, const char* data);
uint8_t fread(FILE* file);
void fflush(FILE* file);