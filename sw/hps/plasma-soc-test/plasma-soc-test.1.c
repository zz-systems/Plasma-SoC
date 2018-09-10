/*
 ============================================================================
 Name        : dma2hps.c
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>

#include "de1_soc.h"

//#include <soc_cv_av/socal/socal.h>
#include <socal/socal.h>

#define PLATFORM de1_soc
#include <kdev/alt_dmac.h>

#define H2F_AXI_MASTER_BASE   (0xC0000000)

// ======================================
// lw_bus; DMA  addresses
#define HW_REGS_BASE        	0xff200000
#define HW_REGS_SPAN        	0x00005000

#define DMA0_BASE				0xff200000
// https://www.altera.com/en_US/pdfs/literature/ug/ug_embedded_ip.pdf
#define DMA_STATUS_OFFSET		0x00
#define DMA_READ_ADD_OFFSET		0x01
#define DMA_WRT_ADD_OFFSET		0x02
#define DMA_LENGTH_OFFSET		0x03
#define DMA_CNTL_OFFSET			0x06

// the h2f light weight bus base
void *h2p_lw_virtual_base;

#define PLASMA_GPIO_DATA_OFFSET		0x08
volatile uint32_t* GPIO_data_ptr = NULL;


//#define SWITCH_DATA_OFFSET		0x20
#define SWITCH_DATA_OFFSET		0x50

struct alt_dmac_t* dmac0 = NULL;

volatile uint32_t* h2f_SWITCH_data_ptr = NULL;
volatile uint32_t* SWITCH_data_ptr = NULL;

// /dev/mem file id
int fd;

int test_value = 0xFFFFFFFF;


int main(void)
{
	// === get FPGA addresses ==================
	// Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	//============================================
	// get virtual addr that maps to physical
	// for light weight bus
	// DMA status register
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}


	dmac0 = (struct alt_dmac_t*)(h2p_lw_virtual_base + HPS_TO_PLASMA_DMA_BASE);
	h2f_SWITCH_data_ptr = (uint32_t *)(h2p_lw_virtual_base + SWITCH_DATA_OFFSET);
	SWITCH_data_ptr = (uint32_t *)(/*h2p_lw_virtual_base + */SWITCH_DATA_OFFSET);

	printf("Initialized...\n");
	printf("h2p_lw_virtual_base at physical address: %p\n", (void*)h2p_lw_virtual_base);

	printf("Press any key to continue...\n");
	getchar();

	while(1)
	{
		alt_dmac_reset(dmac0);
		dmac0->readaddress = (uintptr_t) SWITCH_data_ptr;
		dmac0->writeaddress = (uintptr_t)(AVALON_SDRAM_BASE + 0x800);
		dmac0->length = 4;
		dmac0->control = ALT_DMAC_CTL_WORD | ALT_DMAC_CTL_GO | ALT_DMAC_CTL_LEEN;

		alt_dmac_await(dmac0);
		alt_dmac_stop(dmac0);

		struct timespec s;
		s.tv_sec = 1;//0;//1;
		s.tv_nsec = 0;//2e7; // 50Hz
		nanosleep(&s, NULL);
	}

	return EXIT_SUCCESS;
}
