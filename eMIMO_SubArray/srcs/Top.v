`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: hyq
//
// Create Date:    2024年10月23日09:32:24
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
// Revision v1 - File Created
// 
//
// Revision v2 （已弃用）:
//		增加SPI选路器
//
//
// 2024年10月23日21:54:45
// Revision v3 （已弃用）：修改了帧格式定义，因此弃用
//
// 2024年10月24日13:46:46
// Revision v4（当前版本）：
//		新增DEV_MODE 连接MCU  PB1
//		新增TR开关控制逻辑
//
//
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module top(
	input  HOST_SCLK,
	input  HOST_SDI,
	input  HOST_LE,
	input  UPDATE,
	input  TX_ON,
	input  RX_ON,
	input  REV1,
	input  REV2,
	input  MCU_FCLK,
	input  MCU_DCLK,
	input  MCU_PLUG,
	input  MCU_DATA,
	input  MCU_INIT,
	input  MCU_LE,
	input  clk_in,
	input  DEV_MODE, // 连接MCU  PB1
	
	output [7:0]   PE44951_CS, // 芯片使能信号，低电平有效
	output [1:0]   PE44951_SCLK, // SPI SCLK，4个TX共用PE44951_SCLK[0]，4个RX共用PE44951_SCLK[1]
	output [7:0]   PE44951_MOSI, // SPI MOSI，PE44951_MOSI[3:0]用于TX，PE44951_MOSI[7:4]用于RX
	input  [7:0]   PE44951_MISO, // SPI MISO
	output   	   PE44951_Rset, // 复位引脚
	output [1:0]   PE44951_LP, // 更新相位，4个TX共用PE44951_LP[0]，4个RX共用PE44951_LP[1]

	output FEM_LNA_BYPASS,

	output [7:0]   FEM_TX_ON,
	output [7:0]   FEM_RX_ON,
	output IF_TX_ON,
	output IF_RX_ON,
	output [1:0] IF_DSA_LE,
	output [11:0] IF_DSA_DIN,
	output TX_ON_LED,
	output RX_ON_LED
    );

	// 默认时钟频率100MHz 请大于100MHz 并且小于250MHz
	parameter clk_frq = 100000000;
	// SCLK分频数：f_SCLK = clk_frq / clk_div
	parameter spi_clk_div = 2;
	// 一次SPI传输位数的最大值
	parameter spi_max_data_len = 24;
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
	wire clk = clk_in;

	wire rst_n; 
	// 主机的SPI状态和数据
	wire spi_slave_data_valid;
	wire [7:0] spi_slave_byte;
	wire [31:0] spi_listener_data;
	wire spi_listener_interrupt;
	// 从机SPI状态和数据
	wire spi_ready;
	wire spi_start;
	wire [3:0] chip_id;
	wire [spi_max_data_len-1:0] spi_master_data;
	wire [spi_max_data_len-1:0] spi_data_rx;
	wire [spi_bits_cnt_width-1:0] spi_data_depth;

	// 主机SPI选路输出
	wire selected_SCLK;
	wire selected_SDI;
	wire selected_LE;

	wire TR_status;
	wire [7:0] TX_on_spi;
	wire [7:0] RX_on_spi;
	wire IF_TX_on_spi;
	wire IF_RX_on_spi;

	// ============================== spi_slave ==============================
	parameter SPI_MODE = 0; // CPOL = 0, CPHA = 0
	SPI_Slave #(
		.SPI_MODE(SPI_MODE)
	)
	SPI_Slave_test    
	(
		.i_Rst_L(rst_n),
		.i_Clk(clk),
		.o_RX_DV(spi_slave_data_valid), 
		.o_RX_Byte(spi_slave_byte),
		.i_SPI_Clk(selected_SCLK),
		.i_SPI_MOSI(selected_SDI),
		.i_SPI_CS_n(selected_LE)
	);
	// ============================== spi_listener ==============================
	spi_listener SPI_Listener_test
	(
	    .clk(clk),
	    .spi_slave_data_valid(spi_slave_data_valid),
	    .spi_slave_byte(spi_slave_byte),
	    .spi_data(spi_listener_data),
	    .spi_listener_interrupt(spi_listener_interrupt)
	);
	// ============================== 数据处理模块 ==============================
	spi_process #(
		.spi_master_data_len(spi_max_data_len)
	)
	process_test (
		.clk_100M(clk),
		.rst_n(rst_n),

		.i_DEV_MODE(DEV_MODE),
		.i_UPDATE(UPDATE),
		.i_spi_listener_interrupt(spi_listener_interrupt),
		.i_spi_data(spi_listener_data),

		.o_chip_id(chip_id),
		.o_SPI_data(spi_master_data),
		.o_spi_data_depth(spi_data_depth),
		.o_SPI_start(spi_start),
		.i_SPI_ready(spi_ready),
	
		// 复位
		.o_RsetB(PE44951_Rset),
		// 更新相位
		.o_LP_Pulse(PE44951_LP),
		// 切换TX
		.o_TX_ON(TX_on_spi),
		.o_IF_TX_ON(IF_TX_on_spi),
		// 切换RX
		.o_RX_ON(RX_on_spi),
		.o_IF_RX_ON(IF_RX_on_spi),
		// 禁用LNA
		.o_LNA_BYPASS(FEM_LNA_BYPASS),
		// 中频衰减器
		.o_IFDSA_LE(IF_DSA_LE),
		.o_IFDSA_DIN(IF_DSA_DIN)
	);

	// ============================== SPI发送模块 ==============================

	SPI_Master_PE44951 #(
		// SPI时钟频率
		.clk_div(2),
		// 默认时钟频率100MHz
		.spi_max_data_len(spi_max_data_len)
	)
	SPI_Master_test (
		.i_clk        (clk),
		.i_rst_n      (rst_n),
		.i_spi_data_tx(spi_master_data[spi_max_data_len-1:0]),
		.i_spi_start  (spi_start),
		.i_spi_dir    (1'b0),
		.i_chip_id    (chip_id[3:0]),
		.i_miso       (PE44951_MISO),

		.o_spi_data_rx(spi_data_rx[spi_max_data_len-1:0]),
		.o_cs         (PE44951_CS),
		.o_mosi       (PE44951_MOSI),
		.o_sclk       (PE44951_SCLK),
		.o_spi_ready  (spi_ready)
	);

	// ============================== 主机SPI选路器 ==============================
	host_spi_mux spi_mux_inst(
		.i_SEL(MCU_PLUG), // 控制信号

		// 外部排针的SPI信号
		.i_SCLK_1(HOST_SCLK),
		.i_SDI_1(HOST_SDI),
		.i_LE_1(HOST_LE),

		// MCU的SPI信号
		.i_SCLK_2(MCU_DCLK),
		.i_SDI_2(MCU_DATA),
		.i_LE_2(MCU_LE),

		// 输出选择的SPI信号
		.o_SCLK_mux_out(selected_SCLK),
		.o_SDI_mux_out(selected_SDI),
		.o_LE_mux_out(selected_LE)
	);


	// ============================== TR开关控制 ==============================
	FEM_TR_switch FEM_TR_switch_inst (
		.i_soft_EN(DEV_MODE),
		.i_TX_ON(TX_ON),
		.i_RX_ON(RX_ON),
		.i_TX_ON_soft(TX_on_spi),
		.i_RX_ON_soft(RX_on_spi),
		.i_IF_TX_ON_soft(IF_TX_on_spi),
		.i_IF_RX_ON_soft(IF_RX_on_spi),
		.o_TX_ON(FEM_TX_ON),
		.o_RX_ON(FEM_RX_ON),
		.o_IF_TX_ON(IF_TX_ON),
		.o_IF_RX_ON(IF_RX_ON),
		.o_TX_LED(TX_ON_LED),
		.o_RX_LED(RX_ON_LED)
	);

	// ============================== rst模块 ==============================
	parameter delay_cnt = 10;

	rst #(
		.delay_cnt(delay_cnt)
	)
	rst_test (
		.clk(clk),
		.rst_n(rst_n)
	);

endmodule