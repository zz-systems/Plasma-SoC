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
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>

#include "../plasma_de1_soc_system.h"

#include <soc_cv_av/socal/socal.h>

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

volatile uint32_t* h2f_SWITCH_data_ptr = NULL;
volatile uint32_t* SWITCH_data_ptr = NULL;

// /dev/mem file id
int fd;

int test_value = 0xFFFFFFFF;


//Register Map

#define _DMA_REG_STATUS(BASE_ADDR) *((uint32_t *)BASE_ADDR+0)
#define _DMA_REG_READ_ADDR(BASE_ADDR) *((uint32_t *)BASE_ADDR+1)
#define _DMA_REG_WRITE_ADDR(BASE_ADDR) *((uint32_t *)BASE_ADDR+2)
#define _DMA_REG_LENGTH(BASE_ADDR) *((uint32_t *)BASE_ADDR+3)
#define _DMA_REG_CONTROL(BASE_ADDR) *((uint32_t *)BASE_ADDR+6)

//status register map

#define _DMA_STAT_DONE				0x1
#define _DMA_STAT_BUSY				0x2
#define _DMA_STAT_REOP				0x4
#define _DMA_STAT_WEOP				0x8
#define _DMA_STAT_LEN				0x10

//control register
#define _DMA_CTR_BYTE				0x1
#define _DMA_CTR_HW					0x2
#define _DMA_CTR_WORD				0x4
#define _DMA_CTR_GO					0x8
#define _DMA_CTR_I_EN				0x10
#define _DMA_CTR_REEN				0x20
#define _DMA_CTR_WEEN				0x40
#define _DMA_CTR_LEEN				0x80
#define _DMA_CTR_RCON				0x100
#define _DMA_CTR_WCON				0x200
#define _DMA_CTR_DOUBLEWORD			0x400
#define _DMA_CTR_QUADWORD			0x800
#define _DMA_CTR_SOFTWARERESET		0x1000



#define DEBUG



void debugPrintDMARegister(){
#ifdef DEBUG
	printf("DMA Registers:\n");
	printf( "status: %x\n", _DMA_REG_STATUS(DMA_status_ptr) );
	printf( "read: %x\n", _DMA_REG_READ_ADDR(DMA_status_ptr) );
	printf( "write: %x\n", _DMA_REG_WRITE_ADDR(DMA_status_ptr) );
	printf( "length: %x\n", _DMA_REG_LENGTH(DMA_status_ptr) );
	printf( "control: %x\n", _DMA_REG_CONTROL(DMA_status_ptr) );

#endif
}

void debugPrintDMAStatus(){
#ifdef DEBUG
	printf("DMA Status Registers:\n");
	if(*((uint32_t *)DMA_status_ptr) & _DMA_STAT_DONE) printf( "Status: DONE\n");
	if(*((uint32_t *)DMA_status_ptr) & _DMA_STAT_BUSY) printf( "Status: BUSY\n");
	if(*((uint32_t *)DMA_status_ptr) & _DMA_STAT_REOP) printf( "Status: REOP\n");
	if(*((uint32_t *)DMA_status_ptr) & _DMA_STAT_WEOP) printf( "Status: WEOP\n");
	if(*((uint32_t *)DMA_status_ptr) & _DMA_STAT_LEN) printf( "Status: LEN\n");

#endif
}

void waitDMAFinish(){
	if((_DMA_REG_STATUS(DMA_status_ptr)&_DMA_STAT_BUSY))
		printf("wait...");
	while( (_DMA_REG_STATUS(DMA_status_ptr)&_DMA_STAT_BUSY)){
		struct timespec s;
		s.tv_sec = 0;
		s.tv_nsec = 1000000L;
		nanosleep(&s, NULL);
		//usleep(1000);//usleep is obsolete
		printf(".");
	}
	printf("\n");
}

void stopDMA(){
	*((uint32_t *)DMA_status_ptr+6)=0;
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
	DMA_status_ptr = (unsigned int *)(h2p_lw_virtual_base);
	DMA_read_ptr = (unsigned int *)(h2p_lw_virtual_base + DMA_READ_ADD_OFFSET);
	DMA_write_ptr = (unsigned int *)(h2p_lw_virtual_base + DMA_WRT_ADD_OFFSET);
	DMA_length_ptr = (unsigned int *)(h2p_lw_virtual_base + DMA_LENGTH_OFFSET);
	DMA_cntl_ptr = (unsigned int *)(h2p_lw_virtual_base + DMA_CNTL_OFFSET);

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
		if(sw_data != *h2f_SWITCH_data_ptr)
		{
			printf("switch changed: %03X\n", *h2f_SWITCH_data_ptr);
			sw_data = *h2f_SWITCH_data_ptr;
		}


		// === DMA transfer HPS->FPGA
		// set up DMA
		// from https://www.altera.com/en_US/pdfs/literature/ug/ug_embedded_ip.pdf
		// section 25.4.3 Tables 224 and 225
		//*(DMA_status_ptr) = 0;
		// read bus-master gets data from HPS addr=0xffff0000
		//*(DMA_status_ptr+1) = SWITCH_data_ptr;
		// write bus_master for fpga sram is mapped to 0x08000000
		//*(DMA_status_ptr+2) = GPIO_data_ptr;
		// copy 4 bytes for 1 int
		//*(DMA_status_ptr+3) = 4;
		// set bit 2 for WORD transfer
		// set bit 3 to start DMA
		// set bit 7 to stop on byte-count

		//*(DMA_status_ptr+6) = 0b10001100;

		_DMA_REG_STATUS(DMA_status_ptr) = 0;
		_DMA_REG_READ_ADDR(DMA_status_ptr) = (uintptr_t) SWITCH_data_ptr;
		_DMA_REG_WRITE_ADDR(DMA_status_ptr) =  (uintptr_t) GPIO_data_ptr; // ((unsigned volatile int*)(ERAM_BASE + 0x800));//
		_DMA_REG_LENGTH(DMA_status_ptr) = 4;
		_DMA_REG_CONTROL(DMA_status_ptr)=_DMA_CTR_WORD | _DMA_CTR_GO | _DMA_CTR_LEEN;

		//debugPrintDMARegister();
		//debugPrintDMAStatus();
		waitDMAFinish();
		stopDMA();//stop the DMA controller


		//while ((*(DMA_status_ptr) & 0x010) == 0) {};
		struct timespec s;
		s.tv_sec = 0;//1;
		s.tv_nsec = 1000;
		nanosleep(&s, NULL);
	}

	return EXIT_SUCCESS;
}
