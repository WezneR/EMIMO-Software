#include "stm32f10x.h"
#include "LMK04832_Drv.h"
#include "delay.h"

/// @brief 初始化GPIO，用于用户按键输入, LMK SYNC, LMK RST, CLKin SEL, Status LD.
/* 
 */
void GPIO_init(void)
{
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOC | RCC_APB2Periph_GPIOD, ENABLE);

    GPIO_InitTypeDef GPIO_InitStruct;
    // 用户按键
    GPIO_InitStruct.GPIO_Pin = USRKEY1_Pin | USRKEY2_Pin | USRKEY3_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPU;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_10MHz;
    GPIO_Init(USRKEY_GPIOx, &GPIO_InitStruct);

    // LMK 功能引脚: 状态指示
    GPIO_InitStruct.GPIO_Pin = LMK_StatusLD1_Pin | LMK_StatusLD2_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AIN;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(LMK_GPIOx, &GPIO_InitStruct);

    // LMK 功能引脚: SYNC
    GPIO_InitStruct.GPIO_Pin = LMK_SYNC_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_10MHz;
    GPIO_Init(LMK_GPIOx, &GPIO_InitStruct);

    // LMK 功能引脚: 复位
    GPIO_InitStruct.GPIO_Pin = LMK_RST_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(LMK_GPIOx, &GPIO_InitStruct);
    
    // LMK 功能引脚: 输入时钟选择
    GPIO_InitStruct.GPIO_Pin = LMK_CLKinSEL0_Pin | LMK_CLKinSEL1_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(LMK_GPIOx, &GPIO_InitStruct);


    // 打开PD0 PD1复用功能
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);

    GPIO_PinRemapConfig(GPIO_Remap_PD01, ENABLE);

    // 配置PD0和PD1为复用推挽输出
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOD, &GPIO_InitStruct);

    TGIN_CLR();
    TGOUT_CLR();

    // 发送三个上升沿，因为后级LMK00101的时钟输入疑似有三级缓存
    TGIN_SET();
    TGOUT_SET();
    delay_ms(1);
    TGIN_CLR();
    TGOUT_CLR();
    delay_ms(1);
    TGIN_SET();
    TGOUT_SET();
    delay_ms(1);
    TGIN_CLR();
    TGOUT_CLR();
    delay_ms(1);
    TGIN_SET();
    TGOUT_SET();
    delay_ms(1);
    TGIN_CLR();
    TGOUT_CLR();
}

/// @brief 初始化SPI1外设用于与LMK04832通信
/// @param 
void LMK_Master_Init(void)
{
    //初始化GPIO引脚
    GPIO_InitTypeDef GPIO_InitStruct;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_LMK_GPIOx | RCC_APB2Periph_LMK_SPIx, ENABLE);
 
    //配置SCK和MOSI引脚为复用推挽输出
    GPIO_InitStruct.GPIO_Pin = LMK_SCLK_Pin | LMK_MOSI_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(LMK_GPIOx,&GPIO_InitStruct);
 
    // //配置MISO引脚为浮空输入
    // GPIO_InitStruct.GPIO_Pin = LMK_MISO_Pin;
    // GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    // GPIO_Init(LMK_GPIOx,&GPIO_InitStruct);
 
    //配置CS引脚为输出
    GPIO_InitStruct.GPIO_Pin = LMK_CSEL_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(LMK_GPIOx,&GPIO_InitStruct);

    LMK_CSEL_SET();
 
    //初始化SPI主机
    SPI_InitTypeDef SPI_InitStruct;
    SPI_InitStruct.SPI_Direction = SPI_Direction_2Lines_FullDuplex; //全双工模式
    SPI_InitStruct.SPI_Mode = SPI_Mode_Master; //主模式
    SPI_InitStruct.SPI_DataSize = SPI_DataSize_8b; //8位数据
    SPI_InitStruct.SPI_CPOL = SPI_CPOL_Low; //时钟极性为低电平
    SPI_InitStruct.SPI_CPHA = SPI_CPHA_1Edge; //时钟相位为第一个时钟沿
    SPI_InitStruct.SPI_NSS = SPI_NSS_Soft;  //软件控制片选信号
    SPI_InitStruct.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_32;
    SPI_InitStruct.SPI_FirstBit = SPI_FirstBit_MSB; //最高有效位先传输
    SPI_InitStruct.SPI_CRCPolynomial = 7; //设置CRC多项式
    SPI_Init(LMK_SPIx,&SPI_InitStruct); //SPI初始化

    SPI_Cmd(LMK_SPIx, ENABLE);  //使能SPI外设
}


void LMK_Master_Send(uint8_t data)
{
    //等待发送缓冲区为空
    while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_TXE) == RESET);
    //发送数据
    SPI_I2S_SendData(LMK_SPIx, data);
}
 

/// @brief 初始化LMK04832的126个寄存器
/* 8.5.1 Recommended Programming Sequence
Registers are generally programmed in numeric order with 0x000 being the first and 0x555 being the last register
programmed. The recommended programming sequence from POR involves:
1. Program register 0x000 with RESET = 1.
2. Program defined registers from 0x000 to 0x165.
3. If PLL2 is used, program 0x173 with PLL2_PD and PLL2_PRE_PD clear to allow PLL2 to lock after PLL2_N
is programmed.
4. Continue programming defined registers from 0x166 to 0x555. 
*/
/// @param  
void LMK_regmap_init(uint8_t init_regmap[378])
{
    for (uint32_t i = 0; i < 376; i=i+3) // 最后一次循环，i自加至375，发送的是 init_regmap[375] [375+1] [375+2]
    {
        LMK_CSEL_CLR();
        LMK_Master_Send(init_regmap[i]);
        LMK_Master_Send(init_regmap[i+1]);
        LMK_Master_Send(init_regmap[i+2]);
        while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_BSY) == SET);
        LMK_CSEL_SET();
        if(i == 0)
        {
            // 配置Reg0x000 的RESET字段，等待复位结束
            delay_ms(1);
        }
        else if (i == 330) // 已经初始化完Reg0x165。此时应该先进行PLL2 Power up 操作，再配置PLL2分频器
        {
            LMK_CSEL_CLR();
            LMK_Master_Send(0x01);
            LMK_Master_Send(0x73);
            // Power up PLL2 by setting PLL2_PRE_PD = 0 and PLL2_PD = 0 in register 0x173 before programming PLL2_N. （这也是手册8.5.1第3条说的，给PLL2_PD 和 PLL2_PRE_PD 清零，然后再配置N Counter，PLL2才会锁定。）
            LMK_Master_Send(0x10);
            // 此时 Reg0x173的 PLL2_PD 和 PLL2_PRE_PD 已经从 POR value 1 变为 0，下一步继续配置 PLL2 N （Reg0x166 ~ Reg0x168）
            while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_BSY) == SET);
            LMK_CSEL_SET();
            // 等待 PLL2 power up
            delay_ms(1);
        }
    }       
}



void LMK_PLL2_PD(void)
{
    // 配置R371(Reg 0x173) 的 PLL2_PRE_PD 和 PLL2_PD 
    LMK_CSEL_CLR();
    LMK_Master_Send(0x01);
    LMK_Master_Send(0x73);
    LMK_Master_Send(0x70);
    while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_BSY) == SET);
    LMK_CSEL_SET();
}



void LMK_PLL1_PD(void)
{
    // 配置R320(Reg 0x140) 的 PLL1_PD
    LMK_CSEL_CLR();
    LMK_Master_Send(0x01);
    LMK_Master_Send(0x40);
    LMK_Master_Send(0x81);
    while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_BSY) == SET);
    LMK_CSEL_SET();
}


