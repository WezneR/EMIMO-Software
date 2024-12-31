`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:33 08/13/2024 
// Design Name: 
// Module Name:    TRX_switch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TRX_switch(
    input Module_TX,
	input Module_RX,
    output reg [3:0] o_Fast_TR = 4'b1111     //控制芯片收发状态，0为发射模式，1为接收模式，上电后默认接收模式
    );
always @(Module_TX or Module_RX) begin
if(Module_TX == 1 && Module_RX == 1) begin  //连续波雷达模式，两半机箱一收一发，BS1发射，BS2接收
    o_Fast_TR = 4'b0000;
end
if(Module_TX == 0 && Module_RX == 0) begin  //待机模式，进入较低功耗的接收模式
    o_Fast_TR = 4'b1111;
end
if(Module_TX == 1 && Module_RX == 0) begin  //发射模式
    o_Fast_TR = 4'b0000;
end
if(Module_TX == 0 && Module_RX == 1) begin  //接收模式
    o_Fast_TR = 4'b1111;
end
end
endmodule
