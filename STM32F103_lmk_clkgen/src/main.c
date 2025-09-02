#include "stdio.h"
#include "delay.h"
#include "uart.h"
#include "LMK04832_Drv.h"

// extern uint8_t init_regmap[];
// extern uint8_t init_regmap_pll1only[];
extern uint8_t init_regmap_v2[];

extern uint8_t host_instruction_valid;

extern uint8_t process_once;

extern uint8_t uart_rx_buffer[8];

static void process(uint8_t uart_data[8], uint8_t * ptr_process_once);

int main()
{

    SystemInit();
    SysTick_Init();
    LMK_Master_Init();
    GPIO_init();
    UART_Init();

    // LMK_regmap_init(init_regmap);
    // LMK_regmap_init(init_regmap_pll1only);
    LMK_regmap_init(init_regmap_v2);
    delay_ms(100);
    LMK_regmap_init(init_regmap_v2);

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
            process(uart_rx_buffer, &process_once);
        }
    }
    
}

static void process(uint8_t uart_data[8], uint8_t * ptr_process_once)
{

    uint8_t cmd_addr = uart_data[3] & 0x0F;

    uint8_t dist = ((uart_data[3]&0xF0)>>4);

    switch (cmd_addr)
    {
    case 0x1:
        if (uart_data[5]& 0x01)
        {
            if (dist == 0)
            {
                TGOUT_SET();
                printf("trig_out is ON.\r\n");
            }
            else
            {
                TGIN_SET();
                printf("trig_in is ON.\r\n");
            }
        }
        else
        {
            if (dist == 0)
            {
                TGOUT_CLR();
                printf("trig_out is OFF.\r\n");
            }
            else
            {
                TGIN_CLR();
                printf("trig_in is OFF.\r\n");
            }
        }
        break;
    case 0x2:
        if (dist == 0)
        {
            TGOUT_SET();
            delay_ms(1);
            TGOUT_CLR();
            printf("A trig_out pulse is sent.\r\n");
        }
        else
        {
            TGIN_SET();
            delay_ms(1);
            TGIN_CLR();
            printf("A trig_in pulse is sent.\r\n");
        }
        break;
    
    default:
        printf("lmk_clk_gen: Unknown command %02X\r\n", cmd_addr);
        break;
    }
    *ptr_process_once = 1;
}

