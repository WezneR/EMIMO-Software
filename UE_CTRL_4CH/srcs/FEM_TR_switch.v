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
    // 软件控制使能。当为高电平时，允许使用软件（SPI或UART指令）控制TR开关，否则由外部电平信号直接决定TR开关
    input wire i_soft_EN,

    input wire i_TX_ON,
    input wire i_RX_ON,

    input wire [1:0] i_TX_ON_soft,
    input wire [1:0] i_RX_ON_soft,

    output reg  o_TX_ON_B1,
    output reg  o_RX_ON_B1
);


always @* begin
    if (i_soft_EN == 0) begin
        // 不受软件指令控制
        if (i_TX_ON != i_RX_ON) begin
            o_TX_ON_B1 = i_TX_ON;
            o_RX_ON_B1 = i_RX_ON;
        end else begin
            o_TX_ON_B1 = 0;
            o_RX_ON_B1 = 0;
        end
    end
    else begin
        // 仅由软件指令控制
    end
end
endmodule