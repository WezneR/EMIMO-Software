#ifndef __UART_H
#define __UART_H

#include "stm32f10x.h"

// UART2定义
#define UARTx USART1
#define UART_RCC RCC_APB2Periph_USART1
#define UART_GPIO_RCC RCC_APB2Periph_GPIOA

#define UART_TX_PIN GPIO_Pin_9
#define UART_RX_PIN GPIO_Pin_10

#define UART_GPIO GPIOA


#define UART_Head0 0x55
#define UART_Head1 0x5D
#define UART_Tail0 0x0D
#define UART_Tail1 0x0A

#define UART_Head   (UART_Head0<<8)|UART_Head1
#define UART_Tail   (UART_Tail0<<8)|UART_Tail1

void UART_Init(void);
void USART1_IRQHandler(void);

#endif // __UART_H