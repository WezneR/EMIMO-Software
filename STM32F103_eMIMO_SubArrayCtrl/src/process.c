#include "process.h"

uint8_t general_BID;
uint8_t init_phase[16] = {0};
uint8_t init_atten[16] = {0};

/* 延时函数示例，根据具体实现调整 */
static void Delay_us(uint32_t us)
{
    for(uint32_t i = 0; i < us; i++);
}

/// @brief 初始化GPIO，用于 DEV_MODE, MCU_PLUG, LED
/* 
    GPIOA 和 GPIOB 的外设时钟分别已经在 FPGA_SPI_Init 和 EEPROM_Init 中启动了，
    这里只需要配置引脚功能即可。
 */
void GPIO_init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct;
    // DEV_MODE：PB1
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStruct);

    // MCU_PLUG: PA6
    GPIO_InitStruct.GPIO_Pin = MCU_PLUG_Pin_x;
    GPIO_Init(MCU_PLUG_GPIOx, &GPIO_InitStruct);

    #if (USE_LED == 1)
    // LED
    GPIO_InitStruct.GPIO_Pin = LED_GPIO_Pin_x;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(LED_GPIOx, &GPIO_InitStruct);
    #endif

    // 测试电平用: PB5

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_5;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOB, &GPIO_InitStruct);
    GPIO_WriteBit(GPIOB, GPIO_Pin_5, Bit_SET);

    DEV_MODE_CLR();
    MCU_PLUG_CLR();
}



void SubArray_init_info_transmitt(void)
{

    EEPROM_ReadSequenBytes(MEM_PHA, init_phase, 16);
    EEPROM_ReadSequenBytes(MEM_ATT, init_atten, 16);
    general_BID = EEPROM_ReadByte(MEM_BID);

    FPGA_CSEL_CLR();
    MCU_PLUG_SET();
    FPGA_Master_Send(SPI_BORADCAST_DF32A|CMD_RECV_BOARD_ID);
    FPGA_Master_Send((uint16_t)general_BID);
    while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
    FPGA_CSEL_SET();
    MCU_PLUG_CLR();

    uint8_t Chip_ID;
    uint16_t Channel_ID;
    for (uint8_t i = 0; i < 16; i++)
    {
        Channel_ID = (uint16_t)i&(uint16_t)0x1;
        Chip_ID = (i>>1)&(uint8_t)0x7;
        FPGA_CSEL_CLR();
        MCU_PLUG_SET();
        FPGA_Master_Send(SPI_BORADCAST_DF32A|(Chip_ID<<4)|CMD_RECV_PHASE_INIT);
        FPGA_Master_Send((Channel_ID<<8)|init_phase[i]);
        // while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
        // FPGA_CSEL_SET();

        // FPGA_CSEL_CLR();
        FPGA_Master_Send(SPI_BORADCAST_DF32A|(Chip_ID<<4)|CMD_RECV_ATTEN_INIT);
        FPGA_Master_Send((Channel_ID<<8)|init_atten[i]);
        while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
        FPGA_CSEL_SET();
        MCU_PLUG_CLR();
        Delay_us(2);
    }
}

void process(uint8_t uart_data[8], uint8_t * ptr_process_once)
{
    // 需要转发给FPGA的指令
    if (uart_data[6] == UART_Tail0 && uart_data[7] == UART_Tail1)
    {
        FPGA_CSEL_CLR();
        MCU_PLUG_SET();
        FPGA_Master_Send(((uint16_t)uart_data[2]<<8)|uart_data[3]);
        FPGA_Master_Send(((uint16_t)uart_data[4]<<8)|uart_data[5]);
        while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
        FPGA_CSEL_SET();
        MCU_PLUG_CLR();
    }
    // 需要自己处理的指令
    else if (uart_data[6] == UART_Tail1 && uart_data[7] == UART_Tail0)
    {
        uint8_t cmd_addr = uart_data[3] & 0x0F;

        switch (cmd_addr)
        {
        case 0x0:
            if (uart_data[5]& 0x01)
            {
                DEV_MODE_SET();
            }
            else
            {
                DEV_MODE_CLR();
            }
            break;
        case 0x1:
            SubArray_init_info_transmitt();
            break;
        case 0x7:
            EEPROM_WriteByte(MEM_BID, uart_data[5]);
            break;
        case 0x8:
            EEPROM_WriteByte(MEM_PHA | (uart_data[3]&0xF0>>3) | (uart_data[4]&0x01), uart_data[5]);
            break;
        case 0x9:
            EEPROM_WriteByte(MEM_ATT | (uart_data[3]&0xF0>>3) | (uart_data[4]&0x01), uart_data[5]);
            break;
        default:
            break;
        }
    }
    *ptr_process_once = 1;
    printf("Done.\r\n");
}