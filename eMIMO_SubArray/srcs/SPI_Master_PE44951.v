`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/15 15:17:18
// Design Name: 
// Module Name: SPI_Master_PE44951
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// 
// 
// 
// 
// 
// Additional Comments:
// 
//  PE44951对SPI时序的要求：
//      1, SCLK最快50MHz
//      2, CS下降沿到第一个SCLK上升沿需要维持至少t_cs=10ns
//      3, 最后一个SCLK下降沿到CS上升沿需要维持至少t_ce=10ns
//      4, 两次不同的传输事件之间CS高电平持续时间至少为t_idle=10s
// 
// Revision v1（已弃用）：因为信号线的位宽不总是等于slave_num，实际的板子上虽然有8个芯片作SPI从机，但是4个TX共用同一个SCLK，4个RX共用一个SCLK
// 
// Revision v2（已弃用）: 
//      使用 chip_id 来表示全部选取或者部分多片选取，而不再使用 spi_all 信号线。
//
// 2024年10月23日21:54:45
// Revision v3 （已弃用）：修改了帧格式定义，因此弃用
//
// Revision v4（当前版本）：
//      
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module SPI_Master_PE44951#(
    // SPI分频倍率。f_SCLK = f_in / (clk_div * 2)  = 100MHz / 4 = 25MHz。 要乘2是因为每计数clk_div时钟翻转一次，实际对应半个SCLK周期
    parameter clk_div=2,
    // SPI一次最多传输24 bits。 这个值用来确定寄存器变量的位宽
    parameter spi_max_data_len=24,
    // 根据 spi_max_data_len 计算 spi_bits_cnt_width（ = log2(spi_max_data_len) 向上取整）
    parameter spi_bits_cnt_width = (
        spi_max_data_len <= 2    ? 1 :
        spi_max_data_len <= 4    ? 2 :
        spi_max_data_len <= 8    ? 3 :
        spi_max_data_len <= 16   ? 4 :
        spi_max_data_len <= 32   ? 5 :
        spi_max_data_len <= 64   ? 6 :
        spi_max_data_len <= 128  ? 7 :
                                8
    ),
    // 一次SPI传输事件中需要传输的总位数，包括TX和RX。在与PE44951通信的实例中，这个值只可能取24。
    parameter spi_data_depth = spi_max_data_len,
    // 在slave有返回的数据的情况下，TX数据的长度。在与PE44951通信的实例中，返回数据只可能为0或16 bits）
    parameter rx_head_depth = spi_data_depth - 16,
    // slave实例的个数。这个值用来确定SPI信号引脚和chip_id的位宽
    parameter slave_num = 8
)
(
    // 系统时钟
    input i_clk,
    // 复位信号
    input i_rst_n,
    // 一次SPI传输事件所需的数据。根据手册，必定为24位
    input [spi_max_data_len-1:0] i_spi_data_tx,
    // 触发一次SPI传输事件
    input i_spi_start,
    // SPI传输方向：只发不收(0)，有发有收(1)
    input i_spi_dir,
    // 选择芯片1~8, 0x00表示没有选中，0x01~0x08表示第1~8片，0x09表示全选中。 必须保证该信号线在一次SPI传输事件中保持不变。
    input [3:0] i_chip_id,
    // 存放接收到的数据
    output reg [spi_max_data_len-1:0] o_spi_data_rx,
    
    // 输出的SPI使能，低电平有效
    output reg [slave_num-1:0] o_cs,
    // 输出的SPI数据
    output reg [slave_num-1:0] o_mosi,
    // 输出的SPI时钟信号
    output reg [1:0] o_sclk,
    // 接收的SPI数据
    input [slave_num-1:0] i_miso,
    // 1:可以进行SPI传输，0:表示在忙
    output reg o_spi_ready
);

    
reg spi_dir_reg;
reg [spi_max_data_len-1:0] spi_data_tx_reg;
reg [spi_bits_cnt_width-1:0] spi_bit_cnt;
reg [15:0] clk_div_cnt;

reg 						[2:0] spi_state;
localparam                  SPI_IDLE       = 0,  // 初始空闲状态
                            SPI_WRITE_CLOCK_LOW  = 1,
                            SPI_WRITE_CLOCK_HIGH  = 2,
                            SPI_READ_CLOCK_LOW  = 3,
                            SPI_READ_CLOCK_HIGH  = 4;
always @(posedge i_clk)
begin
    if(!i_rst_n)
    begin
        o_cs <= 8'b11111111;
        o_sclk <= 0;
        o_mosi <= 0;
        spi_state <= SPI_IDLE;
        o_spi_ready<=1;
        // spi_finish<=0;
        spi_bit_cnt<=0;
        // 初始化后默认为TX
        spi_dir_reg<=0;
    end
    else if(o_spi_ready)//idle
    begin
        // // spi_finish <= 0;
        if(i_spi_start)
        begin
            o_spi_ready<=0;
            // 拉低CS
            case (i_chip_id)
                4'd8:
                    // 全选
                    o_cs <= 0;
                4'd9:
                    // 选中TX（前4片）
                    o_cs[3:0] <= 0;
                4'd10:
                    // 选中RX（后4片）
                    o_cs[7:4] <= 0;
                default: 
                    o_cs[i_chip_id[2:0]] <= 1'b0;
            endcase
            spi_dir_reg<=i_spi_dir;           // 只发不收(0)，有发有收(1)
            spi_data_tx_reg<=i_spi_data_tx;   // 将输入模块的TX数据存入TX寄存器
            spi_state<=SPI_WRITE_CLOCK_LOW; // 状态机S0->S1
        end
    end
    else//busy
    begin
        // spi_finish <= 0;
        if(clk_div_cnt!=clk_div-1)
            clk_div_cnt<=clk_div_cnt+1'b1;  // 完成 clk_div 分频
        else
        begin
            clk_div_cnt<=0;                 // 计数清零
            case(spi_state)
            SPI_IDLE:
            begin
                o_spi_ready<=1;
                o_cs <= 8'b11111111;
                spi_bit_cnt <= 0;
                o_sclk <= 0;
                o_mosi <= 0;
                spi_state<=SPI_IDLE;
            end
            SPI_WRITE_CLOCK_LOW:
            begin
                o_sclk<=0;
                // 给所有MOSI信号线传输相同的数据，先传输高位
                o_mosi[0]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[1]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[2]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[3]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[4]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[5]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[6]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                o_mosi[7]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                spi_state<=SPI_WRITE_CLOCK_HIGH;
            end
            SPI_WRITE_CLOCK_HIGH:
            begin
                spi_bit_cnt<=spi_bit_cnt+1'b1;

                o_sclk<=2'b11;

                if(spi_dir_reg)//rx
                    if(spi_bit_cnt==rx_head_depth-1)
                        spi_state<=SPI_READ_CLOCK_LOW;
                    else
                        spi_state<=SPI_WRITE_CLOCK_LOW;
                else//tx
                    if(spi_bit_cnt==spi_data_depth-1)//tx finish
                    begin
                        // spi_finish <= 1;
                        spi_state<=SPI_IDLE;
                    end
                    else
                        spi_state<=SPI_WRITE_CLOCK_LOW;
            end
            SPI_READ_CLOCK_LOW:
            begin
                o_sclk<=0;
                spi_state<=SPI_READ_CLOCK_HIGH;
            end
            SPI_READ_CLOCK_HIGH:
            begin
                spi_bit_cnt<=spi_bit_cnt+1'b1;

                o_sclk<=2'b11;
                //接收时，只接收chip_id对应的MISO信号线
                case(i_chip_id)
                    4'b0000: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= 1'bz; // SPI RX模式下全选没有意义，因此设为高阻状态
                    4'b0001: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[0]; // 选中芯片1
                    4'b0010: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[1]; // 选中芯片2
                    4'b0011: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[2]; // 选中芯片3
                    4'b0100: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[3]; // 选中芯片4
                    4'b0101: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[4]; // 选中芯片5
                    4'b0110: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[5]; // 选中芯片6
                    4'b0111: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[6]; // 选中芯片7
                    4'b1000: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= i_miso[7]; // 选中芯片8
                    default: o_spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= 1'bz; // 其他情况，高阻状态
                endcase
                if(spi_bit_cnt==spi_data_depth-1)//rx finish
                begin
                    spi_state<=SPI_IDLE;
                    // spi_finish <= 1;
                end
                else
                    spi_state<=SPI_READ_CLOCK_LOW;
            end
            endcase
        end
    end
end
endmodule
