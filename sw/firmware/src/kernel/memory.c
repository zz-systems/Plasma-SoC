// Taken from https://github.com/embeddedartistry/embedded-resources/
// Adapted by Sergej Zuyev

#include "kernel/memory.h"
#include "kernel/linked_list.h"
#include "sys/types.h"

#define MIN_ALLOC_SIZE          (4)
#define ALLOC_HEADER_SIZE       offsetof(kalloc_block_t, block)


extern addr_t __heap_start;


typedef struct
{
    kll_node_t node;
    uint32_t size;
    char *block;
} kalloc_block_t;

static kll_node_t heap_list = { &heap_list, &heap_list };

#define align(address, alignment) (((address) + ((alignment) - 1)) & ~((alignment) - 1))
//#define heap ((kll_node_t*) (&__heap_start))
//#define heap_size (MEMORY_SIZE - ((uint32_t)&__heap_start))
static void kdefrag();
void kinit_heap();
static void kadd_block(void *addr, size_t size);
void* kmalloc(uint32_t size);
void kfree(void* ptr);

static void kdefrag()
{
    kalloc_block_t *b, *lb = NULL, *t;

	kll_foreach_elem_safe(b, t, &heap_list, node)
	{
        if(lb && (((uintptr_t)&lb->block) + lb->size) == (uintptr_t)b)
        {
            lb->size += sizeof(*b) + b->size;
            kll_remove(&b->node);

            continue;
        }

		lb = b;
	}
}

void kinit_heap()
{
	heap_list.prev = &heap_list;
	heap_list.next = &heap_list;
	
	kadd_block(&__heap_start, MEMORY_SIZE - ((uint32_t)&__heap_start));
}

static void kadd_block(void *addr, size_t size)
{
    kalloc_block_t *blk;

	// let's align the start address of our block to the next pointer aligned number
	blk = (void *) align((uintptr_t)addr, sizeof(void*));

	// calculate actual size - remove our alignment and our header space from the availability
	blk->size = (uintptr_t) addr + size - (uintptr_t) blk - ALLOC_HEADER_SIZE;

	//and now our giant block of memory is added to the list!
	kll_append(&blk->node, &heap_list);
}


void* kmalloc(uint32_t size)
{
    void * ptr = NULL;
	kalloc_block_t *blk = NULL;

	if(size > 0)
	{
		//Align the pointer
		size = align(size, sizeof(void *));

		// try to find a big enough block to alloc
		kll_foreach_elem(blk, &heap_list, node)
		{
			if(blk->size >= size)
			{
				ptr = &blk->block;
				break;
			}
		}

		// we found something
		if(ptr)
		{
			// Can we split the block?
			if((blk->size - size) >= MIN_ALLOC_SIZE)
			{
				kalloc_block_t *new_blk;
				new_blk = (kalloc_block_t *)((uintptr_t)(&blk->block) + size);
				new_blk->size = blk->size - size - ALLOC_HEADER_SIZE;
				blk->size = size;
				kll_insert(&new_blk->node, &blk->node, blk->node.next);
			}

			kll_remove(&blk->node);
		}

	} //else NULL

	return ptr;
}

void kfree(void* ptr)
{
    kalloc_block_t *blk, *free_blk;

	//Don't free a NULL pointer..
	if(ptr)
	{

		// we take the pointer and use container_of to get the corresponding alloc block
		blk = container_of(ptr, kalloc_block_t, block);

		//Let's put it back in the proper spot
		kll_foreach_elem(free_blk, &heap_list, node)
		{
			if(free_blk > blk)
			{
				kll_insert(&blk->node, free_blk->node.prev, &free_blk->node);
				goto blockadded;
			}
		}
		kll_insert_last(&blk->node, &heap_list);

blockadded:
		// Let's see if we can combine any memory
		kdefrag();
	}
}