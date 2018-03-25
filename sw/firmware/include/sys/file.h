#pragma once

#include "kernel/device.h"

#define BUF_SIZE 64
#define FILE_READ_MODE  0x1
#define FILE_WRITE_MODE 0x2

#define FILE_ERR_BUFFER_FULL 0x1
#define FILE_ERR_MODE_WRONG 0x2

typedef struct
{
    device_descriptor_t *device_desc;
    uint8_t *read_buffer;
    uint8_t *write_buffer;

    uint8_t *read_ptr;
    uint8_t *write_ptr;
    int err;
} FILE;



typedef enum
{
    SEEK_SET,
    SEEK_CUR,
    SEEK_END
} seek_origin_t;


FILE* fopen(const char* path, const char* mode);
FILE* fdopen(device_descriptor_t *device_desc, int mode);

void fclose(FILE* file);
int fwrite(FILE* file, uint8_t data);
int fprint(FILE* file, const char* data);
uint8_t fread(FILE* file);
void fflush(FILE* file);
void fseek(FILE *file, int offset, int seek_origin);