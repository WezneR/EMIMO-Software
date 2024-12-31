`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:        hyq
//
// Create Date:     21:44:54 04/25/2024
// Design Name:     
// Module Name:     SPI_master
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//
//
// Revision 2024年7月13日12:35:27
//  针对基站板16芯片对应变量的位宽做了修改。
//
//
//
//
// Additional Comments:
//
//  FPGA <-- SPI -- > MSTR111
//
// TODO:
// - 没有测试 RX 功能

    // spi_dir = 0 (TX) 时的流程：
    //
    //
    //                                   下一个clk_div周期， 已传输bit数 = 总传输bit数-1 （因为是从零开始计数，所以实际上已经传输完成）
    //                                    ____________________________________________________________________
    //                                   |                             ____________________________________   |
    //                                   |                            |           下一个clk_div周期         |  |
    //                                   |                            |     已传输bit数 < 总传输bit数-1      |  |
    //                                   |                            |                                    |  |
    //                                   V                            V                                    |  |
    //               下一个clk_div周期
    //                |————————————>   S0                            S1                                    S2
    //                |_____________             spi_start==1                      下一个clk_div周期
    //                               (idle)      ————————————>     (tx clk low)      ————————————>       (tx clk high)
    //
    //
    // 跳转状态前执行的操作：
    //
    //                  S0 -> S0 或 rst                S0->S1                      S1->S2                                    S2->S1
    //        -------------------------------------------------------------------------------------------------------------------------------------------
    //   引脚 |           拉高CS                        拉低CS
    //   电平 |           拉低SCLK,MOSI（非必须）                                   拉低SCLK                                    拉高SCLK
    //   　　 |                                                                    根据TX寄存器的值输出MOSI，先传MSB            已传输bit数+1
    //
    //   数据 |           已传输bit数清零               装载TX数据
    //   操作 |
    //
    //
    //
    //
    //
    // spi_dir = 1 (RX) 时的流程：
    //
    //
    //                                                                      下一个clk_div周期， 已传输bit数==总传输bit数-1 （因为是从零开始计数，所以实际上已经传输完成）
    //                                    _______________________________________________________________________________________________________________________________________________________________
    //                                   |                             ____________________________________                                              ________________________________________        |
    //                                   |                            |           下一个clk_div周期         |                                            |          下一个clk_div周期              |       |
    //                                   |                            |     已传输bit数 < rx_head_depth-1   |                                            |      已传输bit数 < 总传输bit数-1        |       |
    //                                   |                            |                                    |                                            |                                        |       |
    //                                   V                            V                                    |                                            V                                        |       |
    //               下一个clk_div周期
    //                |————————————>   S0                            S1                                    S2               下一个clk_div周期           S3                                       S4
    //                |_____________             spi_start==1                      下一个clk_div周期                    已传输bit数==rx_head_depth-1                   下一个clk_div周期
    //                               (idle)      ————————————>     (tx clk low)      ————————————>       (tx clk high)         ————————————>       (rx clk low)        ————————————>       (rx clk high)
    //
    //
    //
    // 跳转状态前执行的操作：
    //
    //                  S0 -> S0 或 rst                S0->S1           S1->S2                              S2->S1               S2->S3                S3->S4                S4->S3                S4->S0
    //        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //   引脚 |           拉高CS                        拉低CS
    //   电平 |           拉低SCLK,MOSI（非必须）                        拉低SCLK                             拉高SCLK             拉高SCLK              拉低SCLK               拉高SCLK             拉高SCLK
    //   　　 |                                                         根据TX寄存器的值输出MOSI，先传MSB                                                                      对MISO采样           对MISO采样
    //
    //   数据 |           已传输bit数清零               装载TX数据                                            已传输bit数+1        已传输bit数+1         清空RX Buffer TODO      已传输bit数+1        已传输bit数+1
    //   操作 |
    //    
    //    
    //    
    //    
    //    
//////////////////////////////////////////////////////////////////////////////////


module spi_master #(
    // SPI分频倍率。f_SCLK = f_in / (clk_div * 2)  = 100MHz / 4 = 25MHz。 要乘2是因为每计数clk_div时钟翻转一次，实际对应半个SCLK周期
    parameter clk_div=2,
    // SPI一次最多传输48 bits （serial mode） 一次最少传输27 btis （fast parallel mode） 这个值用来确定寄存器变量的位宽
    parameter spi_max_data_len=48,
    // 在MSTR111有返回的数据的情况下，TX数据的长度。（返回数据，如果有，只可能为32 bits）
    parameter rx_head_depth=48-32,
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
    )
)
(
    // 系统时钟
    input clk,
    // 复位信号
    input rst_n,
    // 触发一次SPI传输事件
    input spi_start,
    // SPI传输方向：只发不收(0)，有发有收(1)
    input spi_dir,
    // 选择芯片1~8, 0x00表示没有选中，0x01~0x08表示第1~8片，0x09表示全选中。 必须保证该信号线在一次SPI传输事件中保持不变。
    input [3:0] chip_id,
    input spi_all,
    // 本次传输事件中需要传输的总位数，包括TX和RX。在与MSTR111通信的实例中，这个值只可能取27或48，分别对应Fast Parallel和Serial。 必须保证该信号线在一次SPI传输事件中保持不变。
    input [spi_bits_cnt_width-1:0] spi_data_depth,
    // 接收数据
    input [3:0] spi_miso,
    // 待发送的数据
    input [spi_max_data_len-1:0] spi_data_tx,
    // 存放接收到的数据
    output reg [spi_max_data_len-1:0] spi_data_rx,
    // 1:可以进行传输，0:表示在忙
    output reg spi_ready,
    // 1:接收数据结束，0:未开始接收或正在接收
    output reg spi_finish,
    // 输出的SPI时钟信号
    output reg [3:0] spi_sclk,
    // 输出的SPI数据
    output reg [3:0] spi_mosi,
    // 输出的SPI使能，低电平有效
    output reg [15:0] spi_le
);

reg spi_dir_reg;
reg [spi_max_data_len-1:0] spi_data_tx_reg;
reg [spi_bits_cnt_width-1:0] spi_bit_cnt;
reg [15:0] clk_div_cnt;

reg 						[2:0] spi_state;     // 用来写状态机的
localparam                  SPI_IDLE       = 0,  // 初始空闲状态
                            SPI_WRITE_CLOCK_LOW  = 1,
                            SPI_WRITE_CLOCK_HIGH  = 2,
                            SPI_READ_CLOCK_LOW  = 3,
                            SPI_READ_CLOCK_HIGH  = 4;
always @(posedge clk)
begin
    if(!rst_n)
    begin
        spi_le <= 16'hFFFF;
        spi_sclk <= 0;
        spi_mosi <= 0;
        spi_state <= SPI_IDLE;
        spi_ready <= 1;
        spi_finish <= 0;
        spi_bit_cnt <= 0;
    end
    else if(spi_ready)//idle
    begin
        // spi_finish <= 0;
        if(spi_start)
        begin
            spi_ready<=0;
            // 拉低CS
            if(spi_all == 0)
                spi_le[chip_id] <= 1'b0;
            else
                spi_le <= 0;
            spi_dir_reg<=spi_dir;           // 只发不收(0)，有发有收(1)
            spi_data_tx_reg<=spi_data_tx;   // 将输入模块的TX数据存入TX寄存器
            spi_state<=SPI_WRITE_CLOCK_LOW; // 状态机S0->S1
        end
    end
    else//busy
    begin
        spi_finish <= 0;
        if(clk_div_cnt!=clk_div-1)
            clk_div_cnt<=clk_div_cnt+1'b1;  // 完成 clk_div 分频
        else
        begin
            clk_div_cnt<=0;                 // 计数清零
            case(spi_state)
            SPI_IDLE:
            begin
                spi_ready<=1;
                spi_le <= 16'hFFFF;
                spi_bit_cnt <= 0;
                spi_sclk <= 0;
                spi_mosi <= 0;
                spi_state<=SPI_IDLE;
            end
            SPI_WRITE_CLOCK_LOW:
            begin
                spi_sclk<=0;
                // 给所有MOSI信号线传输相同的数据，先传输高位
                spi_mosi[0]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                spi_mosi[1]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                spi_mosi[2]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                spi_mosi[3]<=spi_data_tx_reg[spi_data_depth-spi_bit_cnt-1];
                spi_state<=SPI_WRITE_CLOCK_HIGH;
            end
            SPI_WRITE_CLOCK_HIGH:
            begin
                spi_bit_cnt<=spi_bit_cnt+1'b1;

                spi_sclk<=4'hF;

                if(spi_dir_reg)//rx
                    if(spi_bit_cnt==rx_head_depth-1)
                        spi_state<=SPI_READ_CLOCK_LOW;
                    else
                        spi_state<=SPI_WRITE_CLOCK_LOW;
                else//tx
                    if(spi_bit_cnt==spi_data_depth-1)//tx finish
                    begin
                        spi_finish <= 1;
                        spi_state<=SPI_IDLE;
                    end
                    else
                        spi_state<=SPI_WRITE_CLOCK_LOW;
            end
            SPI_READ_CLOCK_LOW:
            begin
                spi_sclk<=0;
                spi_state<=SPI_READ_CLOCK_HIGH;
            end
            SPI_READ_CLOCK_HIGH:
            begin
                spi_bit_cnt<=spi_bit_cnt+1'b1;

                spi_sclk<=4'hF;
                //接收时，只接收chip_id对应的MISO信号线
                case(chip_id)
                    4'b0000, 4'b0001, 4'b0010, 4'b0011: // chip 0,1,2,3 共用 MISO 0
                        spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= spi_miso[0];
                    4'b0100, 4'b0101, 4'b0110, 4'b0111: // chip 4,5,6,7 共用 MISO 1
                        spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= spi_miso[1]; 
                    4'b1000, 4'b1001, 4'b1010, 4'b1011: // chip 8,9,10,11 共用 MISO 2
                        spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= spi_miso[2];
                    4'b1100, 4'b1101, 4'b1110, 4'b1111: // chip 12,13,14,15 共用 MISO 3
                        spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= spi_miso[3];
                    default: spi_data_rx[spi_data_depth-spi_bit_cnt-1] <= 1'bz; // 其他情况，高阻状态
                endcase
                if(spi_bit_cnt==spi_data_depth-1)//rx finish
                begin
                    spi_state<=SPI_IDLE;
                    spi_finish <= 1;
                end
                else
                    spi_state<=SPI_READ_CLOCK_LOW;
            end
            endcase
        end
    end
end

endmodule