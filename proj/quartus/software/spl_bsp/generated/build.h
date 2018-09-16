
#ifndef	_PRELOADER_BUILD_H_
#define	_PRELOADER_BUILD_H_

/*
 * Boot option. 1 mean that particular boot mode is selected.
 * Only 1 boot option to be enabled at any time
 */
#define CONFIG_PRELOADER_BOOT_FROM_QSPI		(0)
#define CONFIG_PRELOADER_BOOT_FROM_SDMMC	(1)
/*#define CONFIG_PRELOADER_BOOT_FROM_NAND	(0)*/
#define CONFIG_PRELOADER_BOOT_FROM_RAM		(0)

/*
 * Handoff files must provide image location of subsequent
 * bootloader inside the boot devices / flashes
 */
#if (CONFIG_PRELOADER_BOOT_FROM_QSPI == 1)
#define CONFIG_PRELOADER_QSPI_NEXT_BOOT_IMAGE	(0x60000)
#endif
#if (CONFIG_PRELOADER_BOOT_FROM_SDMMC == 1)
#define CONFIG_PRELOADER_SDMMC_NEXT_BOOT_IMAGE	(0x40000)
#endif
/*#if (CONFIG_PRELOADER_BOOT_FROM_NAND == 1)
#define CONFIG_PRELOADER_NAND_NEXT_BOOT_IMAGE	(0x40000)
#endif*/

/*
 * Handoff files must provide user option whether to
 * enable watchdog during preloader execution phase
 */
#define CONFIG_PRELOADER_WATCHDOG_ENABLE	(0)

/*
 * Handoff files must provide user option whether to enable
 * debug memory write support
 */
#define CONFIG_PRELOADER_DEBUG_MEMORY_WRITE	(0)
/* the base address of debug memory */
#if (CONFIG_PRELOADER_DEBUG_MEMORY_WRITE == 1)
#define CONFIG_PRELOADER_DEBUG_MEMORY_ADDR	(0xfffffd00)
#define CONFIG_PRELOADER_DEBUG_MEMORY_SIZE	(0x200)
#endif

/* Semihosting support in Preloader */
#define CONFIG_PRELOADER_SEMIHOSTING		(0)

/* Option to check checksum of subsequent boot software image */
#define CONFIG_PRELOADER_CHECKSUM_NEXT_IMAGE	(1)

/*
 * Handoff files must provide user option whether to enable
 * debug serial printout support
 */
#define CONFIG_PRELOADER_SERIAL_SUPPORT		(1)

/*
 * Handoff files must provide user option whether to enable
 * hardware diagnostic support
 */
#define CONFIG_PRELOADER_HARDWARE_DIAGNOSTIC	(0)

/*
 * Preloader execute on FPGA. This is normally selected
 * for BootROM FPGA boot where Preloader located on FPGA
 */
#define CONFIG_PRELOADER_EXE_ON_FPGA		(0)
#if (CONFIG_PRELOADER_EXE_ON_FPGA == 1)
#define CONFIG_FPGA_MAX_SIZE			(0x10000)
#define CONFIG_FPGA_DATA_BASE			0xffff0000
#define CONFIG_FPGA_DATA_MAX_SIZE		(0x10000)
#endif

/*
 * Enabled write STATE_VALID value to STATE_REG register to
 * tell BootROM that Preloader run successfully.
 */
#define CONFIG_PRELOADER_STATE_REG_ENABLE	(1)

/*
 * Enabled the handshake with BootROM when confiuring the IOCSR and pin mux.
 * If enabled and warm reset happen in middle of Preloader configuring IOCSR
 * and pin mux, BootROM will reconfigure the IOCSR and pin mux again.
 */
#define CONFIG_PRELOADER_BOOTROM_HANDSHAKE_CFGIO	(1)

/*
 * If enabled, when warm reset happen and BootROM skipped configuring IOCSR
 * and pin mux, Preloader will skip configuring the IOCSR and pin mux too.
 */
#define CONFIG_PRELOADER_WARMRST_SKIP_CFGIO	(1)

/*
 * If enabled, Preloader will skip SDRAM initialization and calibration.
 */
#define CONFIG_PRELOADER_SKIP_SDRAM		(0)


#endif /* _PRELOADER_BUILD_H_ */


