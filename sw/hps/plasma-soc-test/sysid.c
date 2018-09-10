#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>

#include <socal/socal.h>
#include <socal/hps.h>
#include <plasma_soc.h>
#include <de1_soc.h>

extern int errno;

#define HPS2FPGASLAVES_BASE (0xC0000000)
#define HPS2FPGASLAVES_SPAN (0x40000000)
#define HPS2FPGASLAVES_MASK (HPS2FPGASLAVES_SPAN - 1)

#define LWFPGASLAVES_BASE (0xFF200000)
#define LWFPGASLAVES_SPAN (0x00200000)
#define LWFPGASLAVES_MASK (LWFPGASLAVES_SPAN - 1)

/* This program validates Plasma SoC */
int main(void)
{
    int result = 0;
    volatile uint32_t *sysid_regs = NULL; // virtual address pointer

    int fd = -1;       // used to open /dev/mem for access to physical addresses
    void *vlwfpga_base; // used to map physical addresses for the light-weight bridge
    void *vhps2pga_base; // used to map physical addresses for the light-weight bridge

    // Create virtual memory access to the FPGA light-weight bridge
   if((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
      {

          perror("Error.");
          goto error_0;
      }

   vlwfpga_base = mmap(NULL, LWFPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, LWFPGASLAVES_BASE);
   if(vlwfpga_base == MAP_FAILED)
      {
          perror("Error.");
          goto error_1;
      }


   // Set virtual address pointer to I/O port
   sysid_regs = (volatile uint32_t *) (vlwfpga_base + SYSID_QSYS_0_BASE);

    //Read data
    uint32_t system_id = sysid_regs[0];
    uint32_t timestamp = sysid_regs[1];

    printf("Your system's ID {%lu}\n", system_id);
    printf("Your system's timestamp {%lu}\n", timestamp);

   // Validate
   result = SYSID_QSYS_0_ID != system_id || SYSID_QSYS_0_TIMESTAMP != timestamp;


    vhps2pga_base = mmap(NULL, HPS2FPGASLAVES_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS2FPGASLAVES_BASE);
   if(vhps2pga_base == MAP_FAILED)
      {
          perror("Error.");
          goto error_2;
      }

    volatile uint32_t* plasma_root = (uint32_t *) (vhps2pga_base + PLASMA_SOC_0_BASE);

    volatile uint32_t* sdram = (uint32_t *) (plasma_root + AVALON_BASE + AVALON_SDRAM_BASE);

    //*((uint32_t*)(sdram + 0x800)) = 0xDD;   

    printf("Readingting: @{%p}, {%lu}\n", ((uint32_t*)(plasma_root + 0x530C)), *((uint32_t*)(plasma_root + 0x530C)));

    printf("Something: {%lu}\n", *((uint32_t*)(sdram + 0x800)));

error_2:
    munmap(vhps2pga_base, HPS2FPGASLAVES_SPAN);
error_1:
    munmap(vlwfpga_base, LWFPGASLAVES_SPAN);
error_0:
    close(fd);

    printf("Done.\n");

   return 0;
}