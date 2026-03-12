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

#define CMD_PHASE_ARRAY_CAL     0x0
#define CMD_INIT                0x1
#define CMD_WRITE_PHASE         0x2
#define CMD_WRITE_ATTEN         0x3
#define CMD_SWITCH_TXRX         0x4
#define CMD_UPDATE_PHASE        0x5
#define CMD_POWER_DOWN          0x6
#define CMD_RECV_BOARD_ID       0x7
#define CMD_RECV_PHASE_INIT     0x8
#define CMD_RECV_ATTEN_INIT     0x9
#define CMD_WRITE_IFDSA         0xA
#define CMD_BEAM_SCAN_CONFIG    0xB
#define CMD_BEAM_SCAN_ADD_DIR   0xC
#define CMD_BEAM_SCAN_ARM       0xD
#define CMD_BEAM_SCAN_DISARM    0xE

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

/**
 * @brief  Read board ID and calibration data from EEPROM, transmit to FPGA
 * @param  None
 * @retval None
 */
void SubArray_init_info_transmitt(void);

void process(uint8_t uart_data[8], uint8_t * ptr_process_once);

/**
 * @brief  Configure beam scan parameters
 * @param  num_dirs: Number of scan directions (1-16)
 * @param  scan_mode: Scan mode (0=TX only, 1=RX only, 2=TX+RX)
 * @retval None
 */
void FPGA_BeamScan_Config(uint8_t num_dirs, uint8_t scan_mode);

/**
 * @brief  Add a scan direction to the beam scan controller
 * @param  dir_index: Direction index (0-15)
 * @param  azimuth: Azimuth angle (signed, -128 to 127 degrees)
 * @param  pitch: Pitch/elevation angle (signed, -128 to 127 degrees)
 * @retval None
 */
void FPGA_BeamScan_AddDirection(uint8_t dir_index, int8_t azimuth, int8_t pitch);

/**
 * @brief  Arm the beam scan controller with timeout
 * @param  timeout_us: Timeout in microseconds (0 = no timeout)
 * @retval None
 */
void FPGA_BeamScan_Arm(uint16_t timeout_us);

/**
 * @brief  Disarm the beam scan controller
 * @param  None
 * @retval None
 */
void FPGA_BeamScan_Disarm(void);

#ifdef __cplusplus
}
#endif

#endif