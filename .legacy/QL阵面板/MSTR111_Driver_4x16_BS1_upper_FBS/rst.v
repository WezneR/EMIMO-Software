`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:21 06/04/2023 
// Design Name: 
// Module Name:    rst 
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
module rst
#(
    parameter delay_cnt = 10
)
(
    input clk,
    output reg rst_n=0,
	output reg [3:0] resetB = 0
);

reg [7:0] clk_cnt=0;

always @(posedge clk) 
begin
    if(clk_cnt!=delay_cnt-1)
    begin
        rst_n<=0;
        resetB <= 0;
        clk_cnt<=clk_cnt+1;
    end
    else
    begin
        resetB <=4'b1111;
        rst_n<=1;
    end
end

endmodule
