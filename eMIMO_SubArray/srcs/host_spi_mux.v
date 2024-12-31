`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/23 09:38:07
// Design Name: 
// Module Name: host_spi_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module host_spi_mux(
    input wire i_SEL, // 控制信号，用于选择SPI信号源

    input wire i_SCLK_1,
    input wire i_SDI_1,
    input wire i_LE_1,

    input wire i_SCLK_2,
    input wire i_SDI_2,
    input wire i_LE_2,

    // 输出选择的SPI信号
    output wire o_SCLK_mux_out,
    output wire o_SDI_mux_out,
    output wire o_LE_mux_out
);

    // 使用三元运算符实现多路选择器
    assign o_SCLK_mux_out = i_SEL ? i_SCLK_2 : i_SCLK_1;
    assign o_SDI_mux_out  = i_SEL ? i_SDI_2  : i_SDI_1;
    assign o_LE_mux_out   = i_SEL ? i_LE_2   : i_LE_1;

endmodule

