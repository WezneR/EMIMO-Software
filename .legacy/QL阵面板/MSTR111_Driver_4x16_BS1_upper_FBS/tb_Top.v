`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:23:30 07/01/2024
// Design Name:   top
// Module Name:   D:/FPGA_project/MSTR111_4X8_20240629/topp.v
// Project Name:  MSTR111_DRIVER
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top;
	parameter spi_half_clock_ = 20;
	// Inputs
	reg clk_in;
	reg Module_RX;
	reg Module_TX;
	reg Module_EN;
	reg Module_SDO_P;
	reg Module_SDO_N;
	reg Module_clk_P;
	reg Module_clk_N;
	reg [3:0] MISO;

	// Outputs
	wire [15:0] CSB;
	wire [3:0] SCLK;
	wire [3:0] MOSI;
	wire [3:0] RsetB;
	wire [3:0] Fast_TR;
	wire [3:0] Fast_SetT;
	wire [3:0] Fast_SetR;

	// //  Differential signal
	// reg Module_clk;
	// reg Module_SDO;
	// OBUFDS #(
	//     .DIFF_TERM("TRUE"),
	// 	.IOSTANDARD("LVDS_33")
	// )
	// fpga_spi_sdo_ibufds
	// (    
	//     .I(Module_SDO),
	//     .O(Module_SDO_N),
	//     .OB(Module_SDO_P) 
	// );

	// OBUFDS #(    
	//     .DIFF_TERM("TRUE"),
	// 	.IOSTANDARD("LVDS_33")
	// )
	// fpga_spi_clk_ibufds
	// (    
	//     .I(Module_clk),
	//     .O(Module_clk_N),
	//     .OB(Module_clk_P)
	// );

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk_in(clk_in), 
		.Module_RX(Module_RX), 
		.Module_TX(Module_TX), 
		.Module_EN(Module_EN), 
		.Module_SDO_P(Module_SDO_P), 
		.Module_SDO_N(Module_SDO_N), 
		.Module_clk_P(Module_clk_P), 
		.Module_clk_N(Module_clk_N), 
		.CSB(CSB), 
		.SCLK(SCLK), 
		.MOSI(MOSI), 
		.MISO(MISO), 
		.RsetB(RsetB), 
		.Fast_TR(Fast_TR), 
		.Fast_SetT(Fast_SetT), 
		.Fast_SetR(Fast_SetR)
	);

reg [7:0] i = 24;

always #5 clk_in = ~clk_in;
	initial begin
		// Initialize Inputs
		clk_in = 0;
		Module_RX = 0; 
		Module_TX = 1;
		MISO = 0; 
		Module_EN <= 1;
		Module_SDO_P <= 0;
		Module_SDO_N <= 1;
		Module_clk_P <= 0;

		// Wait till initialization completes	
		#40000000;

		// Simulate 24bits SPI intruction
		
		// close all channels
		spi_send_bytes(24'h00_00_0A);
		#4000;
		
		// re init
		spi_send_bytes(24'h20_00_0B);
		#2000;
		
		Module_EN <= 1;
		Module_SDO_P <= 0;
		Module_SDO_N <= 1;
		Module_clk_P <= 0;
		Module_clk_N <= 1;
		#4000;
        
		$stop;
		// Add stimulus here

	end
      

task spi_send_bytes;
    input [23:0] data;
    integer i;
    reg [23:0] conc_3_bytes;

    begin
		conc_3_bytes = {data};
		for(i=24;i>0;i=i-1) begin
			Module_EN <= 0;
			Module_SDO_P <= conc_3_bytes[i-1];
			Module_SDO_N <= ~ conc_3_bytes[i-1];
			Module_clk_P <= 0;
			Module_clk_N <= 1;
	        #spi_half_clock_; 
			Module_clk_P <= 1;
			Module_clk_N <= 0;
			#spi_half_clock_;
		end
    end
endtask
endmodule

