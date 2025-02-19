#include "delay.h"

// 系统时钟频率
extern uint32_t SystemCoreClock;

static volatile uint32_t systick_counter = 0; // 延时计数器

// SysTick 初始化
void SysTick_Init(void) {
    SysTick_Config(SystemCoreClock / 1000); // 配置 SysTick，每 1 ms 触发一次中断
}

// 延时函数
void delay_ms(uint32_t ms) {
    if (ms == 0) return;

    systick_counter = ms; // 加载延时计数值
    while (systick_counter != 0) {
        // 等待计数器递减到 0
    }
}

// 递减计数器函数
static void delay_decrement(void) {
    if (systick_counter > 0) {
        systick_counter--;
    }
}


/**
  * @brief  This function handles SysTick Handler.
  * @param  None
  * @retval None
  */
void SysTick_Handler(void)
{
    // 调用延时的递减计数函数
    delay_decrement();
}
