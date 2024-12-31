`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: hyq
//
// Create Date:    16:11:46 05/04/2024
// Design Name:
// Module Name:    Top
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
// Revision 2024年6月20日 18点29分：
// 之前的版本没有使用 spi_ready ，因为原本的设想是用于在收到UART_RX的指令后判断SPI是否空闲，否则暂存指令并等待SPI空闲。
// 没有使用的原因则是一次SPI传输的耗时远少于接收一个UART_RX指令的时间，所以SPI一定总是空闲的。
// 但在新增初始化MSTR的需求后，情况就不再是这样了：process模块可能会在连续的clk↑时刻发出SPI请求，
// 导致如果没有 spi_ready ，就无法判断SPI是否已经完成初始化信息的发送。所以新版本把这根信号线连起来了。
// 							【SPI_master】---spi_ready--> 【process】
// 
// Revision 2024年7月13日10:54:17
// 基站端16芯片-64阵元 阵面控制逻辑，修改自 4x8 MSTR111 Driver，主要改动包括：
// 1. Top.v 中涉及的输入输出信号线宽度：
//		rst.v			RsetB : 2 -> 4
//		SPI_master.v	CSB : 8 -> 16
//      SPI_master.v    SCLK : 8 -> 4
//      SPI_master.v    MOSI : 8 -> 4
//      SPI_master.v    MISO : 8 -> 4
//      process.v		RsetB : 2 -> 4
//      process.v		Fast_TR : 2 -> 4
//      process.v		Fast_SetT : 2 -> 4
//
//
// 2. chip_id 位宽变为 4
//
//
//
//
//
//
//
//
//
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module top(
	input  clk_in,
	input  Module_RX,
	input  Module_TX,
	input  Module_EN,
	input  Module_SDO_P,
	input  Module_SDO_N,
	input  Module_clk_P,
	input  Module_clk_N,

	
	output [15:0]  CSB, // 芯片使能信号，低电平有效
	output [3:0]   SCLK, // SPI SCLK
	output [3:0]   MOSI, // SPI MOSI
	input  [3:0]   MISO, // SPI MISO
	output [3:0]   RsetB, // MSTR111复位引脚
	output [3:0]   Fast_TR, // 收发切换
	output [3:0]   Fast_SetT, // TX快速配置
	output [3:0]   Fast_SetR // RX快速配置
    );


	// 默认时钟频率100MHz 请大于100MHz 并且小于250MHz
	parameter  clk_frq = 100000000;
	// SCLK分频数：f_SCLK = clk_frq / clk_div
	parameter spi_clk_div = 2;
	// 一次SPI传输位数的最大值
	parameter spi_max_data_len =48;
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
    );

	wire rst_n; 
	wire spi_slave_data_valid;
	wire [7:0] spi_slave_byte;
	wire [23:0] spi_listener_data;
	wire spi_listener_interrupt;
	wire spi_ready;
	wire spi_start;
	wire [3:0] chip_id;
	wire spi_all;
	wire [spi_max_data_len-1:0] spi_master_data;
	wire [spi_max_data_len-1:0] spi_data_rx;
	wire [spi_bits_cnt_width-1:0] spi_data_depth;
	wire spi_finish;


	///////////////////////////// spi_slave /////////////////////////////
	parameter SPI_MODE = 0; // CPOL = 0, CPHA = 0
	SPI_Slave #(
		.SPI_MODE(SPI_MODE)
	)
	SPI_Slave_test    
	(
	   .i_Rst_L(rst_n),
	   .i_Clk(clk_in),
	   .o_RX_DV(spi_slave_data_valid), 
	   .o_RX_Byte(spi_slave_byte),
	   .i_SPI_Clk(Module_clk),
	   .i_SPI_MOSI(Module_SDO), 
	   .i_SPI_CS_n(Module_EN)
	);
	///////////////////////////// spi_listener /////////////////////////////
	parameter first_byte = 8'h20; //chip 1 is 20
	spi_listener #(
	    .first_byte(first_byte)
	)
	SPI_Listener_test
	(
	    .clk(clk_in),
	    .spi_slave_data_valid(spi_slave_data_valid),
	    .spi_slave_byte(spi_slave_byte),
	    .spi_data(spi_listener_data),
	    .spi_listener_interrupt(spi_listener_interrupt)
	);
	///////////////////////////// TRX_switch /////////////////////////////
	TRX_switch TRX_switch(
	.o_Fast_TR(Fast_TR),
	.Module_RX(Module_RX),
	.Module_TX(Module_TX)
	
);
	// ============================== 数据处理模块 ==============================
	process #(
		.spi_max_data_len(spi_max_data_len)
	)
	process_test (
		.clk_100M(clk_in),
		.rst_n(rst_n),
		.Module_TX(Module_TX),
		.Module_RX(Module_RX),

		.o_Fast_SetT(Fast_SetT), // 快速配置
		.o_Fast_SetR(Fast_SetR),
		// MSTR复位
		// .o_RsetB(RsetB),

		.spi_listener_interrupt(spi_listener_interrupt),
		.spi_data(spi_listener_data),

		.o_chip_id(chip_id),
		.o_SPI_data(spi_master_data),
		.o_spi_data_depth(spi_data_depth),
		.o_SPI_start(spi_start),
		//.i_SPI_start_clear(spi_finish),
		.i_SPI_ready(spi_ready),
		.spi_all(spi_all)
	);



	// ============================== SPI发送模块 ==============================

	spi_master #(
		// SPI时钟频率
		.clk_div(spi_clk_div),
		// 默认时钟频率100MHz
		.spi_max_data_len(spi_max_data_len)
	)
	SPI_Master_test (
		// SPI输入时钟
		.clk(clk_in),
		// 复位，低电平复位
		.rst_n(rst_n),

		// 触发一次传输事件
		.spi_start(spi_start),
		// SPI传输方向（0:只发不收，1:有发有收）
		.spi_dir(1'b0),
		// 选择MSTR111芯片
		.chip_id(chip_id),
		.spi_all(spi_all),
		// 本次传输的总位数
		.spi_data_depth(spi_data_depth),
		// SPI MISO
		.spi_miso(MISO),
		// 待发送的数据
		.spi_data_tx(spi_master_data),
		// 接收到的数据
		.spi_data_rx(spi_data_rx),
		.spi_ready(spi_ready),
		.spi_finish(spi_finish),
		.spi_sclk(SCLK),
		.spi_mosi(MOSI),
		.spi_le(CSB)
	);

	// ============================== rst模块 ==============================
	parameter delay_cnt = 10;

	rst #(
		.delay_cnt(delay_cnt)
	)
	rst_test (
		.clk(clk_in),
		.rst_n(rst_n),
		.resetB(RsetB)
	);

///////////////////////////// 差分信号转化 /////////////////////////////	
IBUFDS #(
    .IOSTANDARD("LVDS_33"),
    .DIFF_TERM("TRUE")
)
fpga_spi_sdo_ibufds
(    
    .O(Module_SDO),
    .I(Module_SDO_P),
    .IB(Module_SDO_N) 
);

IBUFDS #(
    .IOSTANDARD("LVDS_33"),
    .DIFF_TERM("TRUE")
)
fpga_spi_clk_ibufds
(    
    .O(Module_clk),
    .I(Module_clk_P),
    .IB(Module_clk_N)
);
endmodule