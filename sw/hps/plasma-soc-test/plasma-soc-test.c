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

#include <socal/socal.h>
#include <socal/hps.h>
#include <plasma_soc.h>
#include <de1_soc.h>
#include <kdev/alt_dmac.h>

#define HPS2FPGASLAVES_BASE (0xC0000000)
#define HPS2FPGASLAVES_SPAN (0x40000000)
#define HPS2FPGASLAVES_MASK (HPS2FPGASLAVES_SPAN - 1)

#define LWFPGASLAVES_BASE (0xFF200000)
#define LWFPGASLAVES_SPAN (0x00200000)
#define LWFPGASLAVES_MASK (LWFPGASLAVES_SPAN - 1)

int main(void)
{
	int fd;

	// the h2f light weight bus base
	void *h2p_lw_virtual_base;

	volatile uint32_t* switches_data;

	struct alt_dmac_t* dmac0 = NULL;

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
	h2p_lw_virtual_base = mmap( NULL, LWFPGASLAVES_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, LWFPGASLAVES_BASE );
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
	
	printf("Initialized...\n");
	printf("h2p_lw_virtual_base: %p\n", (void*)h2p_lw_virtual_base);

	dmac0 = (struct alt_dmac_t*)(h2p_lw_virtual_base);// + 0x40);	
	switches_data = (uint32_t *)(0x20);


	//printf("Press any key to continue...\n");
	//getchar();

	//while(1)
	{
		alt_dmac_reset(dmac0);
		dmac0->readaddress = (uintptr_t) switches_data;
		dmac0->writeaddress = (uintptr_t)(AVALON_SDRAM_BASE + 0x800);
		dmac0->length = 4;
		dmac0->control = ALT_DMAC_CTL_WORD | ALT_DMAC_CTL_GO | ALT_DMAC_CTL_LEEN;

		alt_dmac_await(dmac0);
		alt_dmac_stop(dmac0);

		// struct timespec s;
		// s.tv_sec = 1;//0;//1;
		// s.tv_nsec = 0;//2e7; // 50Hz
		// nanosleep(&s, NULL);
	}

	return EXIT_SUCCESS;
}
