
#ifndef _PRELOADER_RESET_CONFIG_H_
#define _PRELOADER_RESET_CONFIG_H_

/* 1 mean that particular IP need to be kept under reset state */
#define CONFIG_HPS_RESET_ASSERT_EMAC0		(1)
#define CONFIG_HPS_RESET_ASSERT_EMAC1		(0)
#define CONFIG_HPS_RESET_ASSERT_USB0		(1)
#define CONFIG_HPS_RESET_ASSERT_USB1		(0)
#define CONFIG_HPS_RESET_ASSERT_NAND		(1)
#define CONFIG_HPS_RESET_ASSERT_SDMMC		(0)
#define CONFIG_HPS_RESET_ASSERT_QSPI		(0)
#define CONFIG_HPS_RESET_ASSERT_UART0		(0)
#define CONFIG_HPS_RESET_ASSERT_UART1		(1)
#define CONFIG_HPS_RESET_ASSERT_I2C0		(0)
#define CONFIG_HPS_RESET_ASSERT_I2C1		(0)
#define CONFIG_HPS_RESET_ASSERT_I2C2		(1)
#define CONFIG_HPS_RESET_ASSERT_I2C3		(1)
#define CONFIG_HPS_RESET_ASSERT_SPIM0		(1)
#define CONFIG_HPS_RESET_ASSERT_SPIM1		(0)
#define CONFIG_HPS_RESET_ASSERT_SPIS0		(1)
#define CONFIG_HPS_RESET_ASSERT_SPIS1		(1)
#define CONFIG_HPS_RESET_ASSERT_CAN0		(1)
#define CONFIG_HPS_RESET_ASSERT_CAN1		(1)
#define CONFIG_HPS_RESET_ASSERT_L4WD1		(0)
#define CONFIG_HPS_RESET_ASSERT_OSC1TIMER1	(0)
#define CONFIG_HPS_RESET_ASSERT_SPTIMER0	(0)
#define CONFIG_HPS_RESET_ASSERT_SPTIMER1	(0)
#define CONFIG_HPS_RESET_ASSERT_GPIO0		(0)
#define CONFIG_HPS_RESET_ASSERT_GPIO1		(0)
#define CONFIG_HPS_RESET_ASSERT_GPIO2		(0)
#define CONFIG_HPS_RESET_ASSERT_DMA		(0)
#define CONFIG_HPS_RESET_ASSERT_SDR		(0)

#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA0	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA1	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA2	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA3	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA4	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA5	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA6	(1)
#define CONFIG_HPS_RESET_ASSERT_FPGA_DMA7	(1)

#define CONFIG_HPS_RESET_ASSERT_HPS2FPGA	(0)
#define CONFIG_HPS_RESET_ASSERT_LWHPS2FPGA	(0)
#define CONFIG_HPS_RESET_ASSERT_FPGA2HPS	(0)

#define CONFIG_HPS_RESET_WARMRST_HANDSHAKE_FPGA		(1)
#define CONFIG_HPS_RESET_WARMRST_HANDSHAKE_ETR		(1)
#define CONFIG_HPS_RESET_WARMRST_HANDSHAKE_SDRAM	(0)

#endif /* _PRELOADER_RESET_CONFIG_H_ */

