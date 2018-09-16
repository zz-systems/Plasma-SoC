#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
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

/* This program prints Plasma SoC's SystemID data */
int main(void)
{
    int result = EXIT_FAILURE;
    volatile uint32_t *sysid_regs = NULL; // virtual address pointer

    int fd = -1;       // used to open /dev/mem for access to physical addresses
    void *vlwfpga_base; // used to map physical addresses for the light-weight bridge

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

    sysid_regs = (volatile uint32_t *) (vlwfpga_base + SYSID_QSYS_0_BASE);

    // Read data
    uint32_t system_id = sysid_regs[0];
    uint32_t timestamp = sysid_regs[1];

    printf("Your system's ID: {%08X}\n", system_id);
    printf("Your system's timestamp: %s\n", ctime(&timestamp));

    result = EXIT_SUCCESS;   

    error_1:
    munmap(vlwfpga_base, LWFPGASLAVES_SPAN);
    error_0:
    close(fd);

    return result;
}