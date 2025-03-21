/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __LMK04832_DRV_H
#define __LMK04832_DRV_H

#ifdef __cplusplus
extern "C" {
#endif

/* includes ------------------------------------------------------------------*/


/* typedef -------------------------------------------------------------------*/


/* macros --------------------------------------------------------------------*/
#define LMK_SPIx SPI1
#define LMK_GPIOx GPIOA

#define RCC_APB2Periph_LMK_GPIOx RCC_APB2Periph_GPIOA
#define RCC_APB2Periph_LMK_SPIx RCC_APB2Periph_SPI1

#define LMK_SCLK_Pin GPIO_Pin_5
#define LMK_MOSI_Pin GPIO_Pin_7
#define LMK_MISO_Pin GPIO_Pin_6
#define LMK_CSEL_Pin GPIO_Pin_4

#define LMK_CLKinSEL0_Pin GPIO_Pin_0
#define LMK_CLKinSEL1_Pin GPIO_Pin_1
#define LMK_StatusLD1_Pin GPIO_Pin_2
#define LMK_StatusLD2_Pin GPIO_Pin_3
#define LMK_RST_Pin GPIO_Pin_8
#define LMK_SYNC_Pin GPIO_Pin_11

#define LMK_CSEL_SET() GPIO_WriteBit(LMK_GPIOx, LMK_CSEL_Pin, 1)
#define LMK_CSEL_CLR() GPIO_WriteBit(LMK_GPIOx, LMK_CSEL_Pin, 0)

#define LMK_RST_SET() GPIO_WriteBit(LMK_GPIOx, LMK_RST_Pin, 1)
#define LMK_RST_CLR() GPIO_WriteBit(LMK_GPIOx, LMK_RST_Pin, 0)

#define LMK_SYNC_SET() GPIO_WriteBit(LMK_GPIOx, LMK_SYNC_Pin, 1)
#define LMK_SYNC_CLR() GPIO_WriteBit(LMK_GPIOx, LMK_SYNC_Pin, 0)


#define USRKEY_GPIOx GPIOC

#define USRKEY1_Pin GPIO_Pin_13
#define USRKEY2_Pin GPIO_Pin_14
#define USRKEY3_Pin GPIO_Pin_15



/* functions -----------------------------------------------------------------*/
void LMK_Master_Init(void);
void LMK_Master_Send(uint8_t data);
void GPIO_init(void);
void LMK_regmap_init(uint8_t init_regmap[378]);
void LMK_PLL1_PD(void);
void LMK_PLL2_PD(void);



#ifdef __cplusplus
}
#endif

#endif