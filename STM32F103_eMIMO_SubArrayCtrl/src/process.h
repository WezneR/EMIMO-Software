/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __PROCESS_H
#define __PROCESS_H

#ifdef __cplusplus
extern "C" {
#endif

/* includes ------------------------------------------------------------------*/
#include "master_spi.h"
#include "at24c01.h"
#include "uart.h"


/* typedef -------------------------------------------------------------------*/

/* macros --------------------------------------------------------------------*/

#define MEM_PHA 0
#define MEM_ATT 16
#define MEM_BID 32  
#define BID_BORADCAST   0x8 
#define BID_MODULE_ONLY 0x9

#define CMD_PHASE_ARRAY_CAL 0x0
#define CMD_INIT            0x1
#define CMD_WRITE_PHASE     0x2
#define CMD_WRITE_ATTEN     0x3
#define CMD_SWITCH_TXRX     0x4
#define CMD_UPDATE_PHASE    0x5
#define CMD_POWER_DOWN      0x6
#define CMD_RECV_BOARD_ID   0x7
#define CMD_RECV_PHASE_INIT 0x8
#define CMD_RECV_ATTEN_INIT 0x9
#define CMD_WRITE_IFDSA     0xA

#define SPI_BORADCAST_DF32A 0x0800


#define DEV_MODE_SET() GPIO_WriteBit(GPIOB, GPIO_Pin_1, Bit_SET)
#define DEV_MODE_CLR() GPIO_WriteBit(GPIOB, GPIO_Pin_1, Bit_RESET)

#define MCU_PLUG_GPIOx GPIOA
#define MCU_PLUG_Pin_x GPIO_Pin_6
#define MCU_PLUG_SET()  GPIO_WriteBit(MCU_PLUG_GPIOx, MCU_PLUG_Pin_x, Bit_SET)
#define MCU_PLUG_CLR()  GPIO_WriteBit(MCU_PLUG_GPIOx, MCU_PLUG_Pin_x, Bit_RESET)


#define USE_LED 1
#define LED_GPIOx GPIOA
#define LED_GPIO_Pin_x GPIO_Pin_15
#define LED_ON() GPIO_WriteBit(LED_GPIOx, LED_GPIO_Pin_x, Bit_RESET)
#define LED_OFF() GPIO_WriteBit(LED_GPIOx, LED_GPIO_Pin_x, Bit_SET)



/* functions -----------------------------------------------------------------*/
void GPIO_init(void);
void SubArray_init_info_transmitt(void);
void process(uint8_t uart_data[8], uint8_t * ptr_process_once);

#ifdef __cplusplus
}
#endif

#endif