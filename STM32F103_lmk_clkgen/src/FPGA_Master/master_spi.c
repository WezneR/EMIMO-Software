#include "master_spi.h"


/// @brief 初始化SPI1外设用于与FPGA通信
/// @param 
void FPGA_SPI_Init(void)
{
    //初始化GPIO引脚
    GPIO_InitTypeDef GPIO_InitStruct;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_FPGA_GPIOx | RCC_APB2Periph_FPGA_SPIx, ENABLE);
 
    //配置SCK和MOSI引脚为复用推挽输出
    GPIO_InitStruct.GPIO_Pin = FPGA_SCLK_Pin | FPGA_MOSI_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(FPGA_GPIOx,&GPIO_InitStruct);
 
    //配置CS引脚为输出
    GPIO_InitStruct.GPIO_Pin = FPGA_CSEL_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(FPGA_GPIOx,&GPIO_InitStruct);
 
    //初始化SPI主机
    SPI_InitTypeDef SPI_InitStruct;
    SPI_InitStruct.SPI_Direction = SPI_Direction_1Line_Tx; //单工模式
    SPI_InitStruct.SPI_Mode = SPI_Mode_Master; //主模式
    SPI_InitStruct.SPI_DataSize = SPI_DataSize_16b; //8位数据
    SPI_InitStruct.SPI_CPOL = SPI_CPOL_Low; //时钟极性为低电平
    SPI_InitStruct.SPI_CPHA = SPI_CPHA_1Edge; //时钟相位为第一个时钟沿
    SPI_InitStruct.SPI_NSS = SPI_NSS_Soft;  //软件控制片选信号
    SPI_InitStruct.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_16;
    SPI_InitStruct.SPI_FirstBit = SPI_FirstBit_MSB; //最高有效位先传输
    SPI_InitStruct.SPI_CRCPolynomial = 7; //设置CRC多项式
    SPI_Init(FPGA_SPIx,&SPI_InitStruct); //SPI初始化
 
    SPI_Cmd(FPGA_SPIx, ENABLE);  //使能SPI外设
}
 
void FPGA_Master_Send(uint16_t data)
{
    //等待发送缓冲区为空
    while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_TXE) == RESET);
    //发送数据
    SPI_I2S_SendData(FPGA_SPIx, data);
}
 
