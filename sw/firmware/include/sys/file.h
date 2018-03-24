#pragma once

#include "kernel/device.h"

#define BUF_SIZE 64
#define FILE_READ_MODE  0x1
#define FILE_WRITE_MODE 0x2

#define FILE_ERR_BUFFER_FULL 0x1
#define FILE_ERR_MODE_WRONG 0x2

typedef struct
{
    uint8_t buffer[BUF_SIZE];
    uint8_t *buf_ptr;
} buffer_t;

typedef struct
{
    device *device;
    buffer_t *read_buffer;
    buffer_t *write_buffer;
    int err;
} FILE;

FILE* fopen(device* device, char mode);
void fclose(FILE* file);
int fwrite(FILE* file, uint8_t data);
int fprint(FILE* file, const char* data);
uint8_t fread(FILE* file);
void fflush(FILE* file);