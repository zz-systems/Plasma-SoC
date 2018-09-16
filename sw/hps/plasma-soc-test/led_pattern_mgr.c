#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <sys/mman.h>

#include <socal/socal.h>
#include <socal/hps.h>
#include <plasma_soc.h>
#include <de1_soc.h>

#define HPS2FPGASLAVES_BASE (0xC0000000)
#define HPS2FPGASLAVES_SPAN (0x40000000)
#define HPS2FPGASLAVES_MASK (HPS2FPGASLAVES_SPAN - 1)

#define LWFPGASLAVES_BASE (0xFF200000)
#define LWFPGASLAVES_SPAN (0x00200000)
#define LWFPGASLAVES_MASK (LWFPGASLAVES_SPAN - 1)

int fd = -1;       // used to open /dev/mem for access to physical addresses
void *vlwfpga_base; // used to map physical addresses for the light-weight bridge
void *vhps2pga_base; // used to map physical addresses for the hps2fpga bridge

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

	signal(SIGINT, on_close);

    // Create virtual memory access to the FPGA bridges
    if((fd = open("/dev/mem", (O_RDWR | O_SYNC))) < 0)
    {
        perror("Error opening /dev/mem");
        goto error_open_mem_failed;
    }

    vlwfpga_base = mmap(NULL, LWFPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, LWFPGASLAVES_BASE);
    if(vlwfpga_base == MAP_FAILED)
    {
        perror("Error mapping LWFPGASLAVES");
        goto error_map_lwfpga_failed;
    }

    sysid_regs = (volatile uint32_t *) (vlwfpga_base + SYSID_QSYS_0_BASE);

    //Read data
    uint32_t system_id = sysid_regs[0];
    uint32_t timestamp = sysid_regs[1];

    printf("Your system's ID: {%08X}\n", system_id);
    printf("Your system's timestamp: %s\n", ctime(&timestamp));

	vhps2pga_base = mmap(NULL, HPS2FPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS2FPGASLAVES_BASE);    
    if(vhps2pga_base == MAP_FAILED)
    {
        perror("Error mapping HPS2FPGASLAVES");
        goto error_map_hps2fpga_failed;
    } 	
	
	while(1)
	{
        // write switches value to LED pattern memory location
		*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x800)) = *((volatile uint32_t *)(vhps2pga_base + AVALON_SWITCHES));

        // get button PIO value (Active low)
		int buttons = 0xF & ~(*((volatile uint32_t *)(vhps2pga_base + AVALON_BUTTONS)));        
        
        // KEY3 pressed: pattern moves left
        if(buttons & 0x8)
			*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x804)) = 1;

        // KEY2 pressed: pattern moves right
		if(buttons & 0x4)
			*((volatile uint32_t *)(vhps2pga_base + AVALON_SDRAM_BASE + 0x804)) = -1;		

        // KEY1 pressed: pattern moves faster
		if(buttons & 0x2)
			*((volatile uint32_t *)(vhps2pga_base + 0x530C)) /= 2;

        // KEY0 pressed: pattern moves slower
		if(buttons & 0x1)
			*((volatile uint32_t *)(vhps2pga_base + 0x530C)) *= 2;

		struct timespec delay =
        {
             .tv_sec = 0, 
             .tv_nsec = 500000000 // 500ms 
        };

		nanosleep(&delay, NULL);
	}

    result = EXIT_SUCCESS;

// Cleanup
    munmap(vhps2pga_base, HPS2FPGASLAVES_SPAN);
error_map_hps2fpga_failed:
    munmap(vlwfpga_base, LWFPGASLAVES_SPAN);
error_map_lwfpga_failed:    
    close(fd);
error_open_mem_failed:
    return result;
}