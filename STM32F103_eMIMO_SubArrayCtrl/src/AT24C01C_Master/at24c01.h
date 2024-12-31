/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __AT24C01_H
#define __AT24C01_H

#ifdef __cplusplus
extern "C" {
#endif

/* includes ------------------------------------------------------------------*/
#include "stm32f10x.h"
#include "stm32f10x_i2c.h"

/* macros --------------------------------------------------------------------*/
#define EEPROM_I2Cx I2C1
#define EEPROM_GPIOx GPIOB

#define RCC_APB2Periph_EEPROM_GPIOx RCC_APB2Periph_GPIOB
#define RCC_APB1Periph_EEPROM_I2Cx RCC_APB1Periph_I2C1

#define EEPROM_SCL_Pin GPIO_Pin_6
#define EEPROM_SDA_Pin GPIO_Pin_7

/* functions -----------------------------------------------------------------*/
void EEPROM_Init(void);
void EEPROM_WriteByte(uint8_t MemAddress, uint8_t Data);
uint8_t EEPROM_ReadByte(uint8_t MemAddress);
void EEPROM_ReadSequenBytes(uint8_t MemAddress, uint8_t *ByteArray, uint8_t n_Bytes);

#ifdef __cplusplus
}
#endif

#endif /* __AT24C01_H */
