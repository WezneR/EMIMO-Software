#include "uart.h"

uint8_t uart_index = 0;
// 确认帧头：0表示没有收到，1表示已经收到UART_Head0，2表示收到了完整的帧头
static uint8_t head_confirm = 0;

uint8_t uart_rx_buffer[8];
// 是否收到完整有效的指令数据：0表示没有收到，1表示已经收到。
uint8_t host_instruction_valid = 0;
// 是否需要处理指令数据（避免重复处理）：0表示尚未处理；1表示已经处理。该变量必须在处理指令数据的程序处理完成后置1；在UART中断收到一个新的、完整有效的指令数据后置0。
uint8_t process_once = 0;

/* support printf function, usemicrolib is unnecessary */
#if (__ARMCC_VERSION > 6000000)
    __asm(".global __use_no_semihosting\n\t");
    void _sys_exit(int x)
    {
        x = x;
    }
    /* __use_no_semihosting was requested, but _ttywrch was */
    void _ttywrch(int ch)
    {
        ch = ch;
    }
    FILE __stdout;
#else
    #ifdef __CC_ARM
    #pragma import(__use_no_semihosting)
    struct __FILE
    {
        int handle;
    };
    FILE __stdout;
    void _sys_exit(int x)
    {
        x = x;
    }
    /* __use_no_semihosting was requested, but _ttywrch was */
    void _ttywrch(int ch)
    {
        ch = ch;
    }
    #endif
#endif
 
#if defined(__GNUC__) && !defined(__clang__)
    #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
    #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif
 
/**
 * @brief  retargets the c library printf function to the usart.
 * @param  none
 * @retval none
 */
PUTCHAR_PROTOTYPE
{
    while (USART_GetFlagStatus(UARTx, USART_FLAG_TXE) == RESET);
    USART_SendData(UARTx, ch);
    return ch;
}
// 重写 _write()
int _write(int fd, char *pBuffer, int size)
{
    for (int i = 0; i < size; i++)
    {
        __io_putchar(*pBuffer++);
    }
    return size;
}


void UART_Init(void) {
    GPIO_InitTypeDef GPIO_InitStruct;
    USART_InitTypeDef USART_InitStruct;

    // 使能 GPIO 和 USART 时钟
    RCC_APB2PeriphClockCmd(UART_GPIO_RCC, ENABLE);
    RCC_APB1PeriphClockCmd(UART_RCC, ENABLE);

    // 配置 TX 和 RX 引脚
    GPIO_InitStruct.GPIO_Pin = UART_TX_PIN;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP; // TX
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(UART_GPIO, &GPIO_InitStruct);

    GPIO_InitStruct.GPIO_Pin = UART_RX_PIN;
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

/* 
UART会收到来自主机的8字节指令数据包。当然，也有可能收到错误的信息。
每当UART产生接收中断，先判断：
    - 如果之前没有收到过UART_Head，且当前收到的是UART_Head0或者UART_Head1
        说明可能是主机正在发送帧头。因此保存到缓存区。
    - 如果之前没有收到过UART_Head，且当前收到的不是UART_Head0或者UART_Head1
        说明收到的数据格式不正确，直接丢弃。
    - 如果已经收到过UART_Head，且还没有收到第8个字节
        说明可能正在接收主机发送的数据部分，因此保存到缓存区。
    - 如果已经收到过UART_Head，且收满了8个字节
        判断后两个字节是否与帧尾一致，决定是否收到有效数据以及如何处理

 */
// USART2 中断服务程序
void USART2_IRQHandler(void) {
    if (USART_GetITStatus(UARTx, USART_IT_RXNE) != RESET)
    {
        USART_ClearITPendingBit(UARTx, USART_IT_RXNE); //清除中断标志
        uint8_t byte = USART_ReceiveData(UARTx);

        if(head_confirm == 0)
        {
            if(byte == UART_Head0)
            {
                uart_rx_buffer[uart_index++] = byte;
                head_confirm = 1;
            }
            else
            {
                // 丢弃
            }
            host_instruction_valid = 0;
        }
        else if (head_confirm == 1)
        {
            if(byte == UART_Head1)
            {
                uart_rx_buffer[uart_index++] = byte;
                head_confirm = 2;
            }
            else
            {
                // 收到 UART_HEAD0 但下一个字节不是 UART_HEAD1
                uart_index = 0;
                head_confirm = 0;
            }
        }
        else
        {
            // 已经收到完整帧头
            uart_rx_buffer[uart_index++] = byte;
            if (uart_index == 8)
            {
                // 已经收到8个字节
                if ((uart_rx_buffer[6]==0x0D || uart_rx_buffer[6]==0x0A) && (uart_rx_buffer[7]==0x0D || uart_rx_buffer[7]==0x0A))
                {
                    // 帧尾验证有效
                    host_instruction_valid = 1;
                    process_once = 0;
                    
                }
                else
                {
                    printf("Error!\r\n");
                }
                uart_index = 0;
                head_confirm = 0;
            }
        }
    }

    if(USART_GetFlagStatus(UARTx, USART_FLAG_ORE) == SET) //溢出 
    { 
        USART_ClearFlag(UARTx, USART_FLAG_ORE); //读SR 
        USART_ReceiveData(UARTx); //读DR 
    }
}
