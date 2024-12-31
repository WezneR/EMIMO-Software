
#include "master_spi.h"


int main()
{
    FPGA_SPI_Init();
    FPGA_CSEL_SET();

    __NOP();
    FPGA_CSEL_CLR();
    FPGA_Master_Send(0xaa);
    FPGA_Master_Send(0xbb);
    FPGA_Master_Send(0x0f);
    //等待SPI发送结束
    while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
    FPGA_CSEL_SET();
}

// #include "master_spi.h"
// #include "stm32f10x.h"  // 包含STM32库

// void delay(uint32_t count) {
//     while(count--) {
//         __NOP();
//     }
// }

// int main()
// {
//     // 初始化PC13引脚
//     RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);  // 使能GPIOC时钟
//     GPIO_InitTypeDef GPIO_InitStructure;
//     GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;
//     GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
//     GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;       // 配置为推挽输出模式
//     GPIO_Init(GPIOC, &GPIO_InitStructure);

//     // 初始化SPI
//     FPGA_SPI_Init();
//     FPGA_CSEL_SET();

//     // SPI通信测试
//     __NOP();
//     FPGA_CSEL_CLR();
//     FPGA_Master_Send(0xaa);
//     FPGA_Master_Send(0xbb);
//     FPGA_Master_Send(0x0f);
    
//     // 等待SPI发送结束
//     while (SPI_I2S_GetFlagStatus(FPGA_SPIx, SPI_I2S_FLAG_BSY) == SET);
//     FPGA_CSEL_SET();

//     // 进入主循环，控制LED闪烁
//     while (1) {
//         // 切换PC13的状态
//         GPIOC->ODR ^= GPIO_Pin_13;  // 使用按位异或切换PC13的状态
//         delay(1000000);             // 简单延时
//     }
// }
