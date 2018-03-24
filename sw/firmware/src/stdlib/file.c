#include "sys/file.h"
#include "sys/memory.h"
#include "kernel/io.h"

FILE* fopen(device* device, char mode)
{
    if ((mode & FILE_READ_MODE) == 0 && (mode & FILE_WRITE_MODE) == 0)
        return NULL;
    
    FILE* file = (FILE*)malloc(sizeof(FILE));

    if(file != NULL)
    {
        file->device        = device;
        file->read_buffer   = NULL;
        file->write_buffer  = NULL;
        file->err           = 0;

        if (mode & FILE_READ_MODE)
        {
            file->read_buffer = (uint8_t*)malloc(BUF_SIZE);

            if(file->read_buffer == NULL)
            {
                free(file);
                return NULL;
            }

            file->read_ptr = file->read_buffer;
        }

        if (mode & FILE_WRITE_MODE)
        {
            file->write_buffer = (uint8_t*)malloc(BUF_SIZE);

            if(file->write_buffer == NULL)
            {
                free(file);
                return NULL;
            }

            file->write_ptr = file->write_buffer;
        }
    }

    return file;
}

void fclose(FILE* file)
{
    fflush(file);

    free(file);
}

int fwrite(FILE* file, uint8_t data)
{
    if (file->write_buffer != NULL)
    {
        if(file->write_ptr < file->write_buffer + BUF_SIZE)
        {
            *(file->write_ptr++) = data;
            return 1;
        }
    }
    else
    {
        file->err = FILE_ERR_MODE_WRONG;
    }

    return 0;
}

int fprint(FILE* file, const char* string)
{
    int written = 0;
    while(*string)
    {
        written += fwrite(file, *string++);
        if(file->err)
            return written;
    }

    return 0;
}

uint8_t fread(FILE* file)
{
    if (file->write_buffer != NULL)
    {
    }
    else
    {
        file->err = FILE_ERR_MODE_WRONG;
    }

    return 0;
}

void fflush(FILE* file)
{
    for(uint8_t *buf_ptr = file->write_buffer; buf_ptr < file->write_ptr; buf_ptr++)
    {
        dputc(file->device, *buf_ptr);
    }

    // Seek to begin
    file->write_ptr = file->write_buffer;
}