#include "delay.h"
#include "uart.h"
#include "LMK04832_Drv.h"

extern uint8_t init_regmap[];

int main()
{

    SystemInit();
    LMK_Master_Init();
    UART_Init();
    SysTick_Init();
    GPIO_init();

    LMK_regmap_init(init_regmap);
    delay_ms(100);
    LMK_regmap_init(init_regmap);

    uint8_t combined_key_encode = 0;

    while (1)
    {
        if (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY1_Pin) == 0)
        {
            // Key1处于按下状态时，轮询Key2
            while (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY1_Pin) == 0)
            {
                // 如果Key2也被按下
                if (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY3_Pin) == 0)
                {
                    combined_key_encode = 1; // Key1 + Key2
                }
                else
                {
                    combined_key_encode = 2; // Key1
                }
            }
            
        }
        else if (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY3_Pin) == 0)
        {
            // Key2处于按下状态时，轮询Key1
            while (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY3_Pin) == 0)
            {
                // 如果Key1也被按下
                if (GPIO_ReadInputDataBit(USRKEY_GPIOx, USRKEY1_Pin) == 0)
                {
                    combined_key_encode = 3; // Key2 + Key1
                }
                else
                {
                    combined_key_encode = 4; // Key2
                }
            }
        }
        else
        {
            combined_key_encode = 0;
        }
        
        switch (combined_key_encode)
        {
        case 1:
            break;
        case 2:
            {
                TGOUT_SET();
                delay_ms(1);
                TGOUT_CLR();
                break;
            }
        case 3:
            break;
        case 4:
            {
                TGIN_SET();
                delay_ms(1);
                TGIN_CLR();
                break;
            }            
        default:
            break;
        }
        // 检查是否接收到有效的UART指令
        if (host_instruction_valid && process_once == 0)
        {
            // MCU_PLUG_SET();
            process(uart_rx_buffer, &process_once);
            #if (USE_LED == 1)
            LED_OFF();
            #endif
        }
    }
    
}
