#include "kernel/memory.h"

#define MIN_ALLOC_SIZE          (4)
#define ALLOC_HEADER_SIZE       (3)

typedef struct node {
    struct node *next;
    struct node *prev;
} node_t;

static node_t list = { &list, &list };

typedef struct
{
    node_t node;
    uint32_t size;
    char *block;
} block_t;


#define align(address, alignment) (((address) + ((alignment) - 1)) & ~((alignment) - 1))


void* kmalloc(uint32_t size)
{
    // void *ptr = NULL;
    // block_t *block = NULL;

    // if(size > 0)
    // {
    //     size = align(size, sizeof(void*));

    //     for(block = (block_t*)list.next; 
    //         block != (block_t*)(&list); 
    //         block = (block_t*)block->node.next)
    //     {
    //         if(block->size >= size)
    //         {
    //             ptr = &block->block;
    //             break;
    //         }
    //     }

    //     if(ptr != NULL)
    //     {
    //         if((block-> size - size) >= MIN_ALLOC_SIZE)
    //         {
    //             block_t *new_block = (block_t *)((uint32_t*)(&block->block) + size);
	// 			new_block->size = block->size - size - ALLOC_HEADER_SIZE;
	// 			block->size = size;

    //             next->prev = n;
    //             n->next = next;
    //             n->prev = prev;
    //             prev->next = n;
    //         }
    //     }
    // }

    return NULL;
}

void kfree(void* ptr)
{
    ptr = NULL;
    // if(ptr != NULL)
    // {

    // }
}