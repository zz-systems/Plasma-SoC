#include "sys/file.h"
#include "sys/memory.h"
#include "sys/string.h"
#include "kernel/io.h"
#include "kernel/devicemap.h"

FILE* fopen(const char* path, const char* mode)
{
    int parsed_mode = 0;

    // get device descriptor
    device_descriptor_t *device_desc = kdopen(path);
    if(device_desc->type == DEVICE_UNKNOWN)
        return NULL;

    // parse file mode
    if(strcmp(mode, "rw") == 0)
        parsed_mode = FILE_READ_MODE | FILE_WRITE_MODE;
    else if(strcmp(mode, "w") == 0)
        parsed_mode = FILE_WRITE_MODE;
    else if(strcmp(mode, "r") == 0)
        parsed_mode = FILE_READ_MODE;
    else
        return NULL;
    

    return fdopen(device_desc, parsed_mode);
}

FILE* fdopen(device_descriptor_t *device_desc, int mode)
{
    if(device_desc->type == DEVICE_UNKNOWN)
        return NULL;
    
    FILE* file = (FILE*)malloc(sizeof(FILE));

    int create_rb = FALSE, 
        create_wb = FALSE;

    if(file != NULL)
    {
        file->device_desc       = device_desc;
        file->read_buffer       = NULL;
        file->write_buffer      = NULL;
        file->err               = 0;

        if(device_desc->type == DEVICE_DISPLAY)
        {
            file->write_buffer  = (uint8_t*)(&display0->device.data);
            file->write_ptr     = file->write_buffer;
            file->wb_size       = 64;
            file->rb_size       = 0;

            create_rb = FALSE;
            create_wb = FALSE;
        }
        else if(device_desc->type == DEVICE_UART)
        {
            file->read_buffer  = (uint8_t*)(&uart0->device.data);
            file->read_ptr     = file->read_buffer;
            file->rb_size      = 1;

            create_rb = FALSE;
            create_wb = TRUE;
        }
        else
        {
            create_rb = TRUE;
            create_wb = TRUE;
        }

        if ((mode & FILE_READ_MODE) && create_rb)
        {
            file->read_buffer = (uint8_t*)malloc(BUF_SIZE);

            if(file->read_buffer == NULL)
            {
                free(file);
                return NULL;
            }

            file->rb_size  = BUF_SIZE;
            file->read_ptr = file->read_buffer;
        }

        if ((mode & FILE_WRITE_MODE) && create_wb)
        {
            file->write_buffer = (uint8_t*)malloc(BUF_SIZE);

            if(file->write_buffer == NULL)
            {
                free(file);
                return NULL;
            }
                        
            file->wb_size       = BUF_SIZE;
            file->write_ptr = file->write_buffer;
        }        
    }

    return file;
}

void fclose(FILE* file)
{
    fflush(file);

    if(file->device_desc->type != DEVICE_DISPLAY)
    {
        free(file->read_buffer);
        free(file->write_buffer);
    }

    free(file->device_desc);

    free(file);
}

int fwrite(FILE* file, uint8_t data)
{
    if (file->write_buffer != NULL)
    {
        if(file->write_ptr < file->write_buffer + file->wb_size)
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
    if (file->read_buffer != NULL)
    {
        if(file->read_ptr < file->read_buffer + file->rb_size)
        {
            return *(file->read_ptr++);
        } 
    }
    else
    {
        file->err = FILE_ERR_MODE_WRONG;
    }

    return 0;
}

void fflush(FILE* file)
{
    if(file->device_desc->type != DEVICE_DISPLAY)
    { 
        for(uint8_t *buf_ptr = file->write_buffer; buf_ptr < file->write_ptr; buf_ptr++)
        {
            dputc(file->device_desc->device, *buf_ptr);
        }
    }

    // Seek to begin
    fseek(file, 0, SEEK_SET);
}

void fseek(FILE *file, int offset, int seek_origin)
{
    if(seek_origin == SEEK_SET)
    {
        if(file->write_buffer)
            file->write_ptr = file->write_buffer + offset;
        if(file->read_buffer)
            file->read_ptr = file->read_buffer + offset;
    }
    else if(seek_origin == SEEK_CUR)
    {
        if(file->write_buffer)
            file->write_ptr += offset;
        if(file->read_buffer)
            file->read_ptr += offset;
    }
    else if(seek_origin == SEEK_END)
    {
        if(file->write_buffer)
            file->write_ptr = file->write_buffer + file->wb_size + offset;
        if(file->read_buffer)
            file->read_ptr = file->read_buffer + file->rb_size + offset;
    }
}