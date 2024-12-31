#include "uart.h"
#include "process.h"

extern uint8_t uart_rx_buffer[8];
extern uint8_t host_instruction_valid;
extern uint8_t process_once;


int main(void) {

    // init
    FPGA_SPI_Init();
    UART_Init();
    EEPROM_Init();
    GPIO_init();


    // 上电后从EEPROM中读数据，发给FPGA
    // SubArray_init_info_transmitt();

    // 正常工作模式下，STM32到此不再向FPGA发送任何信息
    // 但在开发调试的情况下，STM32仍需要监听UART指令，并根据指令向FPGA转发或者进行其他操作。
    while (1) {
        // 检查是否接收到有效的UART指令
        if (host_instruction_valid && process_once == 0)
        {
            // MCU_PLUG_SET();
            process(uart_rx_buffer, &process_once);
            #if (USE_LED == 1)
            LED_OFF();
            #endif
        }
        else
        {
            #if (USE_LED == 1)
            LED_ON();
            #endif
        }
    }
}