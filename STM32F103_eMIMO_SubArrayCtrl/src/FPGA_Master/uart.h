#ifndef __UART_H
#define __UART_H

#include "stm32f10x.h"
#include "stm32f10x_usart.h"
#include "stdio.h"

// UART2定义
#define UARTx USART2
#define UART_RCC RCC_APB1Periph_USART2
#define UART_GPIO_RCC RCC_APB2Periph_GPIOA

#define UART_TX_PIN GPIO_Pin_2
#define UART_RX_PIN GPIO_Pin_3

#define UART_GPIO GPIOA

#define UART_Head0 0x55
#define UART_Head1 0x5D
#define UART_Tail0 0x0D
#define UART_Tail1 0x0A

#define UART_Head   (UART_Head0<<8)|UART_Head1
#define UART_Tail_F (UART_Tail0<<8)|UART_Tail1
#define UART_Tail_P (UART_Tail1<<8)|UART_Tail0



void UART_Init(void);
void USART2_IRQHandler(void);

#endif // __UART_H