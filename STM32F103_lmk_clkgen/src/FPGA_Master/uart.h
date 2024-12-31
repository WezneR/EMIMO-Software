#ifndef __UART_H
#define __UART_H

#include "stm32f10x.h"

// UART2定义
#define UARTx USART2
#define UART_RCC RCC_APB1Periph_USART2
#define UART_GPIO_RCC RCC_APB2Periph_GPIOA

#define UART_TX_PIN GPIO_Pin_2
#define UART_RX_PIN GPIO_Pin_3

#define UART_GPIO GPIOA

void UART_Init(void);
void UART_SendByte(uint8_t byte);
void USART2_IRQHandler(void);

#endif // __UART_H