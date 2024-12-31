/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MASTER_SPI_H
#define __MASTER_SPI_H

#ifdef __cplusplus
extern "C" {
#endif

/* includes ------------------------------------------------------------------*/
#include "stm32f10x.h"


/* typedef -------------------------------------------------------------------*/




/* macros --------------------------------------------------------------------*/
#define FPGA_SPIx SPI1
#define FPGA_GPIOx GPIOA

#define RCC_APB2Periph_FPGA_GPIOx RCC_APB2Periph_GPIOA
#define RCC_APB2Periph_FPGA_SPIx RCC_APB2Periph_SPI1

#define FPGA_SCLK_Pin GPIO_Pin_5
#define FPGA_MOSI_Pin GPIO_Pin_7
#define FPGA_CSEL_Pin GPIO_Pin_11


#define FPGA_CSEL_SET() GPIO_WriteBit(FPGA_GPIOx, FPGA_CSEL_Pin, 1)
#define FPGA_CSEL_CLR() GPIO_WriteBit(FPGA_GPIOx, FPGA_CSEL_Pin, 0)


/* functions -----------------------------------------------------------------*/
void FPGA_SPI_Init(void);
void FPGA_Master_Send(uint8_t data);

#ifdef __cplusplus
}
#endif

#endif