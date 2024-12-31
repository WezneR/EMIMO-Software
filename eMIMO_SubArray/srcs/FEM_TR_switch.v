`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/24 12:53:22
// Design Name: 
// Module Name: FEM_TR_switch
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


module FEM_TR_switch(
    // 软件控制使能。当为高电平时，允许使用软件（SPI指令）控制TR开关，否则由外部电平信号直接决定TR开关
    input wire i_soft_EN,

    input wire i_TX_ON,
    input wire i_RX_ON,
    input wire i_IF_TX_ON,
    input wire i_IF_RX_ON,

    input wire [7:0] i_TX_ON_soft,
    input wire [7:0] i_RX_ON_soft,
    input wire [7:0] i_IF_TX_ON_soft,
    input wire [7:0] i_IF_RX_ON_soft,

    output reg [7:0] o_TX_ON,
    output reg [7:0] o_RX_ON,
    output reg o_IF_TX_ON,
    output reg o_IF_RX_ON,
    output reg o_TX_LED,
    output reg o_RX_LED
);

// assign o_TX_ON = (i_soft_en == 1) ? {8{i_TX_ON}} : // 如果i_soft_en为高，则直接输出i_TX_ON扩展到8位
//                   ((i_TX_ON != i_RX_ON) ? {8{i_TX_ON}} : 8'b0); // 如果TX和RX不同，则输出i_TX_ON，否则输出0

// assign o_RX_ON = (i_soft_en == 1) ? {8{i_RX_ON}} : // 如果i_soft_en为高，则直接输出i_RX_ON扩展到8位
//                   ((i_TX_ON != i_RX_ON) ? {8{i_RX_ON}} : 8'b0); // 如果TX和RX不同，则输出i_RX_ON，否则输出0

always @* begin
    if (i_soft_EN == 0) begin
        // 不受SPI控制
        if (i_TX_ON != i_RX_ON) begin
            o_TX_ON = {8{i_TX_ON}};  // 只有当TX和RX不同时
            o_RX_ON = {8{i_RX_ON}};
            o_IF_TX_ON = i_TX_ON;
            o_IF_RX_ON = i_RX_ON;
            o_TX_LED = i_TX_ON;
            o_RX_LED = i_RX_ON;
        end else begin
            o_TX_ON = 8'b0;  // 同时为高或低，输出0
            o_RX_ON = 8'b0;  // 
            o_IF_TX_ON = 0;
            o_IF_RX_ON = 0;
            o_TX_LED = 0;
            o_RX_LED = 0;
        end
    end
    else begin
        // 仅由SPI控制
        o_TX_ON = i_TX_ON_soft;
        o_RX_ON = i_RX_ON_soft;
        o_IF_TX_ON = i_IF_TX_ON_soft;
        o_IF_RX_ON = i_IF_RX_ON_soft;
        o_TX_LED = i_IF_TX_ON_soft;
        o_RX_LED = i_IF_RX_ON_soft;
    end
end
endmodule