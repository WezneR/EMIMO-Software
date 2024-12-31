#include "uart.h"

static uint8_t uart_buffer[7];
static uint8_t uart_index = 0;
static uint8_t data_ready = 0;

void UART_Init(void) {
    GPIO_InitTypeDef GPIO_InitStruct;
    USART_InitTypeDef USART_InitStruct;

    // 使能 GPIO 和 USART 时钟
    RCC_APB2PeriphClockCmd(UART_GPIO_RCC, ENABLE);
    RCC_APB1PeriphClockCmd(UART_RCC, ENABLE);

    // 配置 TX 和 RX 引脚
    GPIO_InitStruct.GPIO_Pin = UART_TX_PIN | UART_RX_PIN;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP; // TX
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(UART_GPIO, &GPIO_InitStruct);

    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING; // RX
    GPIO_Init(UART_GPIO, &GPIO_InitStruct);

    // 配置 USART 参数
    USART_InitStruct.USART_BaudRate = 115200;
    USART_InitStruct.USART_WordLength = USART_WordLength_8b;
    USART_InitStruct.USART_StopBits = USART_StopBits_1;
    USART_InitStruct.USART_Parity = USART_Parity_No;
    USART_InitStruct.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_InitStruct.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
    USART_Init(UARTx, &USART_InitStruct);

    // 使能 USART 接收中断
    USART_ITConfig(UARTx, USART_IT_RXNE, ENABLE);
    NVIC_EnableIRQ(USART2_IRQn); // 使能 USART2 中断

    // 启用 USART
    USART_Cmd(UARTx, ENABLE);
}

// USART2 中断服务程序
void USART2_IRQHandler(void) {
    if (USART_GetITStatus(UARTx, USART_IT_RXNE) != RESET) {
        uint8_t byte = USART_ReceiveData(UARTx);

        // 检测指令帧
        if (uart_index < 7) {
            uart_buffer[uart_index++] = byte;

            // 检查完整帧的开始和结束
            if (uart_index == 1 && byte != 0x55) {
                uart_index = 0; // 不是帧头，重置索引
            }
            if (uart_index == 7) {
                if (uart_buffer[0] == 0x55 && uart_buffer[1] == 0x5D && uart_buffer[6] == 0x0D) {
                    // 验证帧头和帧尾，数据准备就绪
                    data_ready = 1;
                }
                uart_index = 0; // 重置索引以接收下一帧
            }
        }
    }
}

uint8_t is_data_ready(void) {
    return data_ready;
}

void clear_data_ready_flag(void) {
    data_ready = 0;
}

uint8_t* get_uart_data(void) {
    return uart_buffer + 2; // 返回host_data
}