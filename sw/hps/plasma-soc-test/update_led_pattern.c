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
#include <signal.h>

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


int fd = -1;       // used to open /dev/mem for access to physical addresses
void *vlwfpga_base; // used to map physical addresses for the light-weight bridge
void *vhps2pga_base; // used to map physical addresses for the light-weight bridge

static void on_close(int signal)
{
    puts("Cleaning up...");

    munmap(vhps2pga_base, HPS2FPGASLAVES_SPAN);
    munmap(vlwfpga_base, LWFPGASLAVES_SPAN);
    close(fd);

    exit(EXIT_SUCCESS);
}

int main(void)
{
	int result = EXIT_FAILURE;
    volatile uint32_t *sysid_regs = NULL; // virtual address pointer    

	struct itimerval tval;

	signal(SIGINT, on_close);

    // Create virtual memory access to the FPGA light-weight bridge
    if((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        perror("Error opening /dev/mem");
        goto error_0;
    }

    vlwfpga_base = mmap(NULL, LWFPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, LWFPGASLAVES_BASE);
    if(vlwfpga_base == MAP_FAILED)
    {
        perror("Error mapping LWFPGASLAVES");
        goto error_1;
    }

    // Set virtual address pointer to I/O port
    sysid_regs = (volatile uint32_t *) (vlwfpga_base + SYSID_QSYS_0_BASE);

    //Read data
    uint32_t system_id = sysid_regs[0];
    uint32_t timestamp = sysid_regs[1];

    printf("Your system's ID {%08X}\n", system_id);
    printf("Your system's timestamp {%lu}\n", timestamp);

	vhps2pga_base = mmap(NULL, HPS2FPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS2FPGASLAVES_BASE);
    //vhps2pga_base = mmap(NULL, 0x04000010, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS2FPGASLAVES_BASE + AVALON_SDRAM_BASE);
    if(vhps2pga_base == MAP_FAILED)
    {
        perror("Error mapping HPS2FPGASLAVES");
        goto error_2;
    } 
	
	
	while(1)
	{
		*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x800)) = *((volatile uint32_t *)(vhps2pga_base + AVALON_SWITCHES));

		int buttons = *((volatile uint32_t *)(vhps2pga_base + AVALON_BUTTONS));

		if(buttons & 0x4)
			*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x804)) = 1;
		if(buttons & 0x8)
			*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x804)) = -1;

		if(buttons & 0x2)
			*((volatile uint32_t *)(vhps2pga_base + 0x530C)) *= 2;
		if(buttons & 0x1)
			*((volatile uint32_t *)(vhps2pga_base + 0x530C)) /= 2;

		struct timespec s;
		s.tv_sec = 0;//1;//0;//1;
		s.tv_nsec = 500000000;//2e7; // 50Hz
		nanosleep(&s, NULL);
	}

    result = EXIT_SUCCESS;

    error_2:
    munmap(vhps2pga_base, HPS2FPGASLAVES_SPAN);
    error_1:
    munmap(vlwfpga_base, LWFPGASLAVES_SPAN);
    error_0:
    close(fd);

    printf("Done.\n");

    return result;
}
