/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DELAY_H
#define __DELAY_H

#ifdef __cplusplus
extern "C" {
#endif

/* includes ------------------------------------------------------------------*/
#include "stm32f10x.h"



/* typedef -------------------------------------------------------------------*/

/* macros --------------------------------------------------------------------*/

/* functions -----------------------------------------------------------------*/
void SysTick_Init(void); // SysTick 初始化
void delay_ms(uint32_t ms); // ms 延时函数
void delay_decrement(void); // 延时计数递减，由 SysTick_Handler 调用

#ifdef __cplusplus
}
#endif

#endif