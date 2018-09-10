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
#include <errno.h>

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
	int ret = EXIT_FAILURE;
	int fd;

	// the h2f light weight bus base
	void *h2p_lw_virtual_base;

	volatile uint32_t* switches_data;

	struct alt_dmac_t* dmac0 = NULL;
	
	printf("Opening /dev/mem/...\n");
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 
	{
		perror("ERROR");
		goto error_0;
	}

	printf("Mapping LWHPS2FPGA address...\n");
	h2p_lw_virtual_base = mmap( NULL, LWFPGASLAVES_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, LWFPGASLAVES_BASE );
	if( h2p_lw_virtual_base == MAP_FAILED ) 
	{
		perror("ERROR");
		goto error_1;
	}	
	
	printf("LWHPS2FPGA: %p\n", (void*)h2p_lw_virtual_base);

	dmac0 = (struct alt_dmac_t*)(h2p_lw_virtual_base);// + 0x40);	
	switches_data = (uint32_t *)(0x20);


	printf("Transferring data...\n");
	alt_dmac_reset(dmac0);
	dmac0->readaddress = (uintptr_t) switches_data;
	dmac0->writeaddress = (uintptr_t)(AVALON_SDRAM_BASE + 0x800);
	dmac0->length = 4;
	dmac0->control = ALT_DMAC_CTL_WORD | ALT_DMAC_CTL_GO | ALT_DMAC_CTL_LEEN;

	alt_dmac_await(dmac0);
	alt_dmac_stop(dmac0);

	ret = EXIT_SUCCESS;
error_2:
	munmap(h2p_lw_virtual_base, LWFPGASLAVES_SPAN);
error_1:
	close(fd);
error_0:
	return ret;
}
