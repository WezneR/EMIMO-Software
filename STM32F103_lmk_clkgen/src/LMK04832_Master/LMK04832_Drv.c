#include "stm32f10x.h"
#include "LMK04832_Drv.h"
#include "delay.h"

void LMK_write_register(uint16_t addr, uint8_t data)
{
    LMK_CSEL_CLR();
    LMK_Master_Send((addr >> 8) & 0xFF);  // 高字节
    LMK_Master_Send(addr & 0xFF);         // 低字节
    LMK_Master_Send(data);                // 数据
    while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_BSY) == SET);
    LMK_CSEL_SET();
}

// SYSREF清零函数
static void LMK_clear_sysref_delay_buffers(void)
{
    // 根据手册8.3.3.1.2，设置SYSREF_CLR=1持续15个VCO时钟周期
    // VCO频率约3GHz，15个周期约5ns，但为了安全，我们使用更长的延迟
    
    // 设置SYSREF_CLR = 1 (Reg 0x143, bit 1)
    LMK_write_register(0x143, 0x16);  // SYNC_EN=1, SYSREF_CLR=1, 其他位保持
    
    // 等待15个VCO周期 (约5ns)
    // __NOP();
    delay_ms(1);    
    // 清除SYSREF_CLR = 0
    LMK_write_register(0x143, 0x14);  // SYNC_EN=1, SYSREF_CLR=0
}

// 执行同步操作
static void LMK_perform_sync(void)
{
    // 通过切换SYNC_POL位执行同步
    // 先设置SYNC_POL = 1
    LMK_write_register(0x143, 0x34);  // SYNC_EN=1, SYNC_POL=1, SYNC_MODE=1
    delay_ms(1);
    
    // 然后设置SYNC_POL = 0
    LMK_write_register(0x143, 0x14);  // SYNC_EN=1, SYNC_POL=0, SYNC_MODE=1
    delay_ms(1);
}

// 修复的SYSREF模式切换函数
void LMK_set_sysref_mode_switch(uint8_t mode)
{
    switch(mode) {
        case 0:  // 禁用SYSREF - 通过SYSREF_PD=1
            // 步骤1: 禁用所有相关的SYNC
            LMK_write_register(0x144, 0xFF);  // 设置所有SYNC_DISx = 1
            LMK_write_register(0x145, 0x01);  // 设置SYNC_DISSYSREF = 1
            
            // 步骤2: 断电SYSREF
            LMK_write_register(0x140, 0x0D);  // SYSREF_PD=1, SYSREF_DDLY_PD=1, SYSREF_PLSR_PD=1
            delay_ms(1);  // 等待电路稳定
            break;
            
        case 1:  // Pin or SPI SYNC (SYSREF_MUX=0, SYNC_MODE=1)
            // 步骤1: 准备SYSREF电路
            LMK_write_register(0x140, 0x00);  // Power up: SYSREF_PD=0, SYSREF_DDLY_PD=0, SYSREF_PLSR_PD=0
            delay_ms(1);
            
            // 步骤2: 清零SYSREF延迟缓冲区
            LMK_clear_sysref_delay_buffers();
            delay_ms(1);
            // 步骤3: 设置SYNC配置
            LMK_write_register(0x143, 0x14);  // SYNC_EN=1, SYNC_MODE=1, SYNC_POL=0
            LMK_write_register(0x139, 0x00);  // SYSREF_MUX=0
            
            // 步骤4: 启用必要的SYNC (允许同步影响分频器)
            LMK_write_register(0x144, 0x00);  // 清除SYNC_DISx位
            LMK_write_register(0x145, 0x00);  // 清除SYNC_DISSYSREF位
            
            // 步骤5: 执行同步
            LMK_perform_sync();
            
            // 步骤6: 禁用SYNC以防止后续意外同步
            LMK_write_register(0x144, 0xFF);  // 重新设置SYNC_DISx = 1
            LMK_write_register(0x145, 0x01);  // 重新设置SYNC_DISSYSREF = 1
            break;
            
        case 2:  // Pulser模式 (SYSREF_MUX=2)
            
            // 禁用SYNC并切换到Pulser模式
            LMK_write_register(0x144, 0xFF);  // 设置SYNC_DISx = 1
            LMK_write_register(0x145, 0x01);  // 设置SYNC_DISSYSREF = 1
            
            // 设置Pulser模式
            LMK_write_register(0x143, 0x13);  // SYNC_EN=1, SYNC_MODE=3 (Pulser on SPI programming)
            LMK_write_register(0x139, 0x02);  // SYSREF_MUX=2 (Pulser)
            break;
            
        case 3:  // Continuous模式 (SYSREF_MUX=3)
            // 准备SYSREF电路 // 不需要，置位这些PD会导致SYSREF波形在触发阈值附近反复横跳
            // LMK_write_register(0x140, 0x01);  // SYSREF_PD=0, SYSREF_DDLY_PD=0, SYSREF_PLSR_PD=1
            // delay_ms(1);

            // 清零SYSREF延迟缓冲区
            LMK_clear_sysref_delay_buffers();
            delay_ms(1);
            
            
            // 步骤4: 切换到连续模式
            LMK_write_register(0x139, 0x03);  // SYSREF_MUX=3 (Continuous)
            delay_ms(1);
            break;
    }
}

void LMK_set_sysref_pulse(uint8_t SYSREF_PULSE_CNT)
{   
    // 编程脉冲计数 - 这将触发脉冲发送
    LMK_write_register(0x13E, SYSREF_PULSE_CNT);
    }

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
    for(int i = 0; i < 3; i++) {
        TGIN_SET();
        TGOUT_SET();
        delay_ms(1);
        TGIN_CLR();
        TGOUT_CLR();
        delay_ms(1);
    }
}

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
 
    //配置CS引脚为输出
    GPIO_InitStruct.GPIO_Pin = LMK_CSEL_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(LMK_GPIOx,&GPIO_InitStruct);

    LMK_CSEL_SET();
 
    //初始化SPI主机
    SPI_InitTypeDef SPI_InitStruct;
    SPI_InitStruct.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
    SPI_InitStruct.SPI_Mode = SPI_Mode_Master;
    SPI_InitStruct.SPI_DataSize = SPI_DataSize_8b;
    SPI_InitStruct.SPI_CPOL = SPI_CPOL_Low;
    SPI_InitStruct.SPI_CPHA = SPI_CPHA_1Edge;
    SPI_InitStruct.SPI_NSS = SPI_NSS_Soft;
    SPI_InitStruct.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_32;
    SPI_InitStruct.SPI_FirstBit = SPI_FirstBit_MSB;
    SPI_InitStruct.SPI_CRCPolynomial = 7;
    SPI_Init(LMK_SPIx,&SPI_InitStruct);

    SPI_Cmd(LMK_SPIx, ENABLE);
}

void LMK_Master_Send(uint8_t data)
{
    while (SPI_I2S_GetFlagStatus(LMK_SPIx, SPI_I2S_FLAG_TXE) == RESET);
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
    
    // 初始化完成后，清零SYSREF延迟缓冲区
    LMK_clear_sysref_delay_buffers();
}

void LMK_PLL2_PD(void)
{
    LMK_write_register(0x173, 0x70);
}

void LMK_PLL1_PD(void)
{
    LMK_write_register(0x140, 0x81);
}