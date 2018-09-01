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

#include "../plasma_de1_soc_system.h"

#include <soc_cv_av/socal/socal.h>

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
// HPS_to_FPGA DMA address = 0
volatile unsigned int * DMA_status_ptr = NULL ;
volatile unsigned int * DMA_read_ptr = NULL ;
volatile unsigned int * DMA_write_ptr = NULL ;
volatile unsigned int * DMA_length_ptr = NULL ;
volatile unsigned int * DMA_cntl_ptr = NULL ;


#define PLASMA_GPIO0_BASE          0x00005400
#define PLASMA_GPIO1_BASE          (PLASMA_GPIO0_BASE + 0x10)
#define PLASMA_GPIO2_BASE          (PLASMA_GPIO0_BASE + 0x20)
#define PLASMA_GPIO3_BASE          (PLASMA_GPIO0_BASE + 0x30)

#define PLASMA_GPIO_DATA_OFFSET		0x08
volatile uint32_t* GPIO_data_ptr = NULL;


#define SWITCH_DATA_OFFSET		0x20

struct alt_dmac_t* dmac0 = NULL;

volatile uint32_t* h2f_SWITCH_data_ptr = NULL;
volatile uint32_t* SWITCH_data_ptr = NULL;

// /dev/mem file id
int fd;

int test_value = 0xFFFFFFFF;

#define DEBUG



void debugPrintDMARegister(alt_dmac_t* dmac){
#ifdef DEBUG
	printf("DMA Registers:\n");
	printf( "status: %x\n", dmac->status);
	printf( "read: %x\n", dmac->readaddress);
	printf( "write: %x\n", dmac->writeaddress);
	printf( "length: %x\n", dmac->length);
	printf( "control: %x\n", dmac->control);

#endif
}

void debugPrintDMAStatus(alt_dmac_t* dmac){
#ifdef DEBUG
	printf("DMA Status Registers:\n");
	if(dmac->status & ALT_DMAC_STAT_DONE) printf( "Status: DONE\n");
	if(dmac->status & ALT_DMAC_STAT_BUSY) printf( "Status: BUSY\n");
	if(dmac->status & ALT_DMAC_STAT_REOP) printf( "Status: REOP\n");
	if(dmac->status & ALT_DMAC_STAT_WEOP) printf( "Status: WEOP\n");
	if(dmac->status & ALT_DMAC_STAT_LEN) printf( "Status: LEN\n");

#endif
}

#define ERAM_BASE 0x10000000

int main(void)
{
	// Declare volatile pointers to I/O registers (volatile
	// means that IO load and store instructions will be used
	// to access these pointer locations,
	// instead of regular memory loads and stores)

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
	// the DMA registers
	dmac0 = (struct alt_dmac_t*)(h2p_lw_virtual_base);


	DMA_status_ptr = (unsigned int *)(h2p_lw_virtual_base);
	GPIO_data_ptr =  (uint32_t *)(PLASMA_GPIO0_BASE + PLASMA_GPIO_DATA_OFFSET);

	h2f_SWITCH_data_ptr = (uint32_t *)(h2p_lw_virtual_base + SWITCH_DATA_OFFSET);
	SWITCH_data_ptr = (uint32_t *)(/*h2p_lw_virtual_base + */SWITCH_DATA_OFFSET);

	int sw_data = 0;


	printf("Initialized...\n");
	printf("h2p_lw_virtual_base at physical address: %p\n", (void*)h2p_lw_virtual_base);

	printf("Press any key to continue...\n");
	getchar();

	while(1)
	{
		alt_dmac_reset(dmac0);
		dmac0->readaddress = (uintptr_t) SWITCH_data_ptr;
		dmac0->writeaddress = (uintptr_t)(ERAM_BASE + 0x800);
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
