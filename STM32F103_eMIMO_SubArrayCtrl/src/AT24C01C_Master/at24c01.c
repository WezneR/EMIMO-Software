#include "at24c01.h"


/* 延时函数示例，根据具体实现调整 */
static void Delay_ms(uint32_t ms)
{
    for(uint32_t i = 0; i < ms * 400; i++);
}


/// @brief 初始化I2C1用于与EEPROM通信
void EEPROM_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct;
    I2C_InitTypeDef I2C_InitStruct;

    // 启用时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_EEPROM_GPIOx, ENABLE);
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_EEPROM_I2Cx, ENABLE);

    // 配置SCL和SDA引脚
    GPIO_InitStruct.GPIO_Pin = EEPROM_SCL_Pin | EEPROM_SDA_Pin;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_OD;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(EEPROM_GPIOx, &GPIO_InitStruct);

    // 配置I2C参数
    I2C_InitStruct.I2C_Mode = I2C_Mode_I2C;
    I2C_InitStruct.I2C_DutyCycle = I2C_DutyCycle_2;
    I2C_InitStruct.I2C_OwnAddress1 = 0x00;
    I2C_InitStruct.I2C_Ack = I2C_Ack_Enable;
    I2C_InitStruct.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
    I2C_InitStruct.I2C_ClockSpeed = 100000; // 100kHz
    I2C_Init(EEPROM_I2Cx, &I2C_InitStruct);

    // 启用I2C
    I2C_Cmd(EEPROM_I2Cx, ENABLE);
}

/// @brief 向EEPROM写入一个字节
void EEPROM_WriteByte(uint8_t MemAddress, uint8_t Data)
{
    uint8_t device_addr = 0xA4;

    // 生成START条件
    I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT));
    // 发送I2C设备地址
    I2C_Send7bitAddress(EEPROM_I2Cx, device_addr, I2C_Direction_Transmitter);
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

    // 发送存储地址
    I2C_SendData(EEPROM_I2Cx, MemAddress);

    // 发送数据
    I2C_SendData(EEPROM_I2Cx, Data);
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_TRANSMITTED));

    // 生成STOP条件
    I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
    
    // 等待EEPROM完成内部写入（需要5ms）
    Delay_ms(3); 
}

/// @brief 从EEPROM读取一个字节
uint8_t EEPROM_ReadByte(uint8_t MemAddress)
{
    uint8_t device_addr_write = 0xA4;
    uint8_t device_addr_read = 0xA5;
    uint8_t receivedData = 0;

    // 生成START条件
    I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
    /* 检测EV5事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT));

    // 发送设备地址（写）
    I2C_Send7bitAddress(EEPROM_I2Cx, device_addr_write, I2C_Direction_Transmitter);
    /* 检测EV6事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

    // 发送存储地址
    I2C_SendData(EEPROM_I2Cx, MemAddress);
	/* 检测EV8事件 */
	while(!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_TRANSMITTING));

    // 生成重复START条件
    I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
    /* 检测EV5事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT));

    // 发送设备地址（读）
    I2C_Send7bitAddress(EEPROM_I2Cx, device_addr_read, I2C_Direction_Receiver);
    /* 检测EV6事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));

    // 当前接收的就是最后一个字节，所以要做出NACK
    // I2C_NACKPositionConfig(EEPROM_I2Cx, I2C_NACKPosition_Current);
    I2C_AcknowledgeConfig(EEPROM_I2Cx, DISABLE);

    // 等待数据接收
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_RECEIVED));
    receivedData = I2C_ReceiveData(EEPROM_I2Cx);

    // 生成STOP条件
    I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
    I2C_AcknowledgeConfig(EEPROM_I2Cx, ENABLE);

    return receivedData;
}


/// @brief 从EEPROM读取n个字节
void EEPROM_ReadSequenBytes(uint8_t MemAddress, uint8_t *ByteArray, uint8_t n_Bytes)
{
    uint8_t device_addr_write = 0xA4;
    uint8_t device_addr_read = 0xA5;

    // 生成START条件
    I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT));

    // 发送设备地址（写）
    I2C_Send7bitAddress(EEPROM_I2Cx, device_addr_write, I2C_Direction_Transmitter);
    /* 检测EV6事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));

    // 发送存储地址
    I2C_SendData(EEPROM_I2Cx, MemAddress);
	/* 检测EV8事件 */
	while(!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_TRANSMITTING));

    // 生成重复START条件
    I2C_GenerateSTART(EEPROM_I2Cx, ENABLE);
    /* 检测EV5事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_MODE_SELECT));

    // 发送设备地址（读）
    I2C_Send7bitAddress(EEPROM_I2Cx, device_addr_read, I2C_Direction_Receiver);
    /* 检测EV6事件 */
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));

    for (int i = 0; i < n_Bytes - 1; i++)
    {
        // 等待数据接收
        while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_RECEIVED));
        ByteArray[i] = I2C_ReceiveData(EEPROM_I2Cx);
    }
    // 当前接收的就是最后一个字节，所以要做出NACK
    I2C_AcknowledgeConfig(EEPROM_I2Cx, DISABLE);

    // 等待数据接收
    while (!I2C_CheckEvent(EEPROM_I2Cx, I2C_EVENT_MASTER_BYTE_RECEIVED));
    ByteArray[n_Bytes - 1] = I2C_ReceiveData(EEPROM_I2Cx);

    // 生成STOP条件
    I2C_GenerateSTOP(EEPROM_I2Cx, ENABLE);
    I2C_AcknowledgeConfig(EEPROM_I2Cx, ENABLE);
}
