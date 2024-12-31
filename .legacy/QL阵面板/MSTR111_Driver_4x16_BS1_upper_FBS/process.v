`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:    hyq
//
// Create Date:    08:47:43 05/04/2024
// Design Name:
// Module Name:    process
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
//  版本 v20240509 （已弃用）
//      这个process模块会在 RX_interrupt 触发时，进入忙状态，并根据 收到的数据的不同，执行某一个具体的任务，可能包括 SPI传输类任务、UART发送类任务和引脚控制类任务。
//      但是这个版本面临一个问题：有些任务持续时间较久，在这个过程中，如果输入数据改变，那么 process 可能会执行错误的任务。一个典型的例子是当SPI传输任务执行过程中，UART_RX收到新的起始位，导致 receive_data 的值改变——它在UART_RX模块的逻辑中被清零，进而 process 在下一个时钟沿到来时，认为接收到了一个没有识别到帧头的数据，进而发送 error_0 。
//      这种现象是不被期望的。为了解决它，一个可行的方法是让这三类任务只在 proc_state 从 0变化到1的时候执行一次。这样就避免了在同一个忙状态下执行第二个任务的可能。
//
//  版本 v20240514 
//  process模块中所有对 ResetB 的控制操作全部注释掉了，改为在 rst 模块中复位一次，之后始终置高电平。
//  
//  
//  版本 v20240618 （当前版本）
//  新增初始化寄存器
//  新增信号线 i_SPI_ready 用来在初始化的时候判断SPI是否空闲
//  
//  
//  Revision 2024年7月13日12:36:37
//     1, 针对基站板16芯片对应变量的位宽做了修改。
//     2, 16个芯片每个芯片需要初始化12个寄存器，对应的初始常量存储在 reg 数组类型 MSTR111_init_reg_xx 中， xx = 00,01,...,15 对应每个芯片
//     3, 16个芯片每个芯片后续需要改变通道相位，对应的相位控制字存储在 reg 数组类型 MSTR111_0x008, MSTR111_0x009, MSTR111_0x00c, MSTR111_0x00d 中，每个二维数组宽48bit，长为16对应每个芯片
//     4, proc_state 状态机新增8个状态，状态机变量位宽 4 -> 5
//  
//   Revision 2024年8月23日14点32分
//     1. 已验证完SPI相位、衰减写入功能
//     2. 上电后默认用Fast_TR引脚进行控制
//     3. 尝试加入快速波束切换功能，待验证效果
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
//
//
//////////////////////////////////////////////////////////////////////////////////
module process#(
    //一次SPI通信的最大bit数（SPI数据位宽，包括发+收的全过程)
    parameter spi_max_data_len=48,
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
    //可自定义时钟频率
    input clk_100M,
    //低电平有效
    input rst_n,
    //收发状态使能，TX=1&RX=0为发；TX=0&RX=1为收，同时为1或0为待机
    input Module_TX,
	input Module_RX,

    //============================ 引脚控制 ============================
    //MSTR111 Fast_SetT引脚控制，在发射状态下，该引脚上升沿触发快速切换相幅（芯片Mem.中的数据被移动到Temp.中）
    output reg [3:0] o_Fast_SetT = 0,
    //MSTR111 Fast_SetR引脚控制，在接收状态下，该引脚上升沿触发快速切换相幅（芯片Mem.中的数据被移动到Temp.中）
    output reg [3:0] o_Fast_SetR = 0,
    //MSTR111 RsetB引脚控制，低电平复位
    // output reg [1:0] o_RsetB = 1,

    //============================ SPI_Listener ============================
	input spi_listener_interrupt,  //收到一次信号
    input [23:0] spi_data,         //收到的24bit数据

    //============================ SPI_Master ============================
    //天线在左下角状态，从左到右从上到下芯片编号依次为1-8。使用4位宽，0x0表示全选，0x1-0x8分别对应8个芯片。
    //为了便于调试：FPGA复位状态赋值为 0xf， PROC_IDLE状态被赋值为 0xe， 复位MSTR111时被赋值为0xa， 
    //帧头检验未通过时被赋值为0x9

    output reg	[3:0] o_chip_id, 
    //一次SPI通信中需要传输的数据，以总线形式给到 spi_master 模块的 spi_data_tx 寄存器
    output reg  [spi_max_data_len-1:0] o_SPI_data,
    //本次SPI通信需要传数的总位数，包括发和收。当只发不收时，这个值等于o_SPI_data的宽度
    output reg [spi_bits_cnt_width-1:0] o_spi_data_depth,
    //进行一次SPI数据传输
    output reg o_SPI_start,
    //SPI模块传输完成后将置1，收到该信号后在非复位的clk上升沿清除o_SPI_start
    //input wire i_SPI_start_clear,
    // SPI 空闲标志
    input wire i_SPI_ready,
    // 1表示同时给所有的芯片发送信息
    output reg spi_all = 0
);
    //初始化寄存器, 0~11为0x000~0x009以及0x00c和0x00d，12~136为快速波束切换发射相位，137~261为快速波束切换发射衰减
    reg [47:0] MSTR111_init_reg_00 [0:261];
    reg [47:0] MSTR111_init_reg_01 [0:261];
    reg [47:0] MSTR111_init_reg_02 [0:261];
    reg [47:0] MSTR111_init_reg_03 [0:261];
    reg [47:0] MSTR111_init_reg_04 [0:261];
    reg [47:0] MSTR111_init_reg_05 [0:261];
    reg [47:0] MSTR111_init_reg_06 [0:261];
    reg [47:0] MSTR111_init_reg_07 [0:261];
    reg [47:0] MSTR111_init_reg_08 [0:261];
    reg [47:0] MSTR111_init_reg_09 [0:261];
    reg [47:0] MSTR111_init_reg_10 [0:261];
    reg [47:0] MSTR111_init_reg_11 [0:261];
    reg [47:0] MSTR111_init_reg_12 [0:261];
    reg [47:0] MSTR111_init_reg_13 [0:261];
    reg [47:0] MSTR111_init_reg_14 [0:261];
    reg [47:0] MSTR111_init_reg_15 [0:261];

    reg [7:0]  phase1 [0:15];     //用来完整存储发送来的相位信息
    reg [7:0]  phase2 [0:15];
    reg [7:0]  phase3 [0:15];
    reg [7:0]  phase4 [0:15];
    reg [7:0]  amp1 [0:15];     //用来完整存储发送来的幅度信息
    reg [7:0]  amp2 [0:15];
    reg [7:0]  amp3 [0:15];
    reg [7:0]  amp4 [0:15];

    

    initial begin
        $readmemh("./mem/init_reg_00.txt", MSTR111_init_reg_00);
	    $readmemh("./mem/init_reg_01.txt", MSTR111_init_reg_01);
	    $readmemh("./mem/init_reg_02.txt", MSTR111_init_reg_02);
	    $readmemh("./mem/init_reg_03.txt", MSTR111_init_reg_03);
	    $readmemh("./mem/init_reg_04.txt", MSTR111_init_reg_04);
	    $readmemh("./mem/init_reg_05.txt", MSTR111_init_reg_05);
	    $readmemh("./mem/init_reg_06.txt", MSTR111_init_reg_06);
	    $readmemh("./mem/init_reg_07.txt", MSTR111_init_reg_07);
	    $readmemh("./mem/init_reg_08.txt", MSTR111_init_reg_08);
	    $readmemh("./mem/init_reg_09.txt", MSTR111_init_reg_09);
	    $readmemh("./mem/init_reg_10.txt", MSTR111_init_reg_10);
	    $readmemh("./mem/init_reg_11.txt", MSTR111_init_reg_11);
	    $readmemh("./mem/init_reg_12.txt", MSTR111_init_reg_12);
	    $readmemh("./mem/init_reg_13.txt", MSTR111_init_reg_13);
	    $readmemh("./mem/init_reg_14.txt", MSTR111_init_reg_14);
	    $readmemh("./mem/init_reg_15.txt", MSTR111_init_reg_15);
    end
    reg [4:0]                   proc_state = 0;     // process状态机
    localparam                  PROC_IDLE  = 0,     // 空闲状态
                                PROC_INTI_chip00  = 1,     // 初始化chip00的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip01  = 2,     // 初始化chip01的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip02  = 3,     // 初始化chip02的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip03  = 4,     // 初始化chip03的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip04  = 5,     // 初始化chip04的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip05  = 6,     // 初始化chip05的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip06  = 7,     // 初始化chip06的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip07  = 8,     // 初始化chip07的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip08  = 9,     // 初始化chip08的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip09  = 10,    // 初始化chip09的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip10  = 11,    // 初始化chip10的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip11  = 12,    // 初始化chip11的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip12  = 13,    // 初始化chip12的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip13  = 14,    // 初始化chip13的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip14  = 15,    // 初始化chip14的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_INTI_chip15  = 16,    // 初始化chip15的0x000~0x009以及0x00c和0x00d和快速波束切换幅相
                                PROC_FastSet      = 17,
                                PROC_BUSY         = 18;     // 通信状态
    reg [3:0]   spi_state = 0;   // 信号传输状态机
    localparam  chip_read   = 1, // 第一步读取chip_id
                phase_write = 2, // 第二步将相位写入临时寄存器
                reg_write   = 3, // 第三步将相位更新到MSTR111对应寄存器
                spi_trans   = 4, // 第四步拼接信号开始传输
                FastSetTR_posedge = 5; //第五步，可选取是否需要，上升沿更新幅相信息
    reg [3:0]   FastSetTR_state = 0;
    localparam  FastSetTR_High  = 1, // 第一步拉高
                FastSetTR_Low   = 2; // 第二步拉低
 
    reg [9:0] init_reg_addr; //用来统计每颗芯片的12个寄存器初始到哪个
    reg [13:0] delay_cnt; //初始化开始发送后延迟一段时间再给上升沿，等数据发完

	always @ (posedge clk_100M) begin
		if (!rst_n) begin
            //复位引脚状态
            o_Fast_SetT <= 0;
            o_Fast_SetR <= 0;
            // o_RsetB <= 0;

            //复位SPI_Master数据和相关标志位
			o_chip_id <= 4'b0;
			o_SPI_data <= 0;
			o_SPI_start <= 0;
            o_spi_data_depth <= 48;

            spi_all <= 0;
            init_reg_addr <= 0;
            delay_cnt <= 0;
            proc_state <= PROC_INTI_chip00;
            spi_state <= chip_read;
            FastSetTR_state <= FastSetTR_High;

            phase1[0][7:0]  <= 8'h00;
            phase1[1][7:0]  <= 8'h00;
            phase1[2][7:0]  <= 8'h00;
            phase1[3][7:0]  <= 8'h00;
            phase1[4][7:0]  <= 8'h00;
            phase1[5][7:0]  <= 8'h00;
            phase1[6][7:0]  <= 8'h00;
            phase1[7][7:0]  <= 8'h00;
            phase1[8][7:0]  <= 8'h00;
            phase1[9][7:0]  <= 8'h00;
            phase1[10][7:0] <= 8'h00;
            phase1[11][7:0] <= 8'h00;
            phase1[12][7:0] <= 8'h00;
            phase1[13][7:0] <= 8'h00;
            phase1[14][7:0] <= 8'h00;
            phase1[15][7:0] <= 8'h00;
            phase2[0][7:0]  <= 8'h00;
            phase2[1][7:0]  <= 8'h00;
            phase2[2][7:0]  <= 8'h00;
            phase2[3][7:0]  <= 8'h00;
            phase2[4][7:0]  <= 8'h00;
            phase2[5][7:0]  <= 8'h00;
            phase2[6][7:0]  <= 8'h00;
            phase2[7][7:0]  <= 8'h00;
            phase2[8][7:0]  <= 8'h00;
            phase2[9][7:0]  <= 8'h00;
            phase2[10][7:0] <= 8'h00;
            phase2[11][7:0] <= 8'h00;
            phase2[12][7:0] <= 8'h00;
            phase2[13][7:0] <= 8'h00;
            phase2[14][7:0] <= 8'h00;
            phase2[15][7:0] <= 8'h00;
            phase3[0][7:0]  <= 8'h00;
            phase3[1][7:0]  <= 8'h00;
            phase3[2][7:0]  <= 8'h00;
            phase3[3][7:0]  <= 8'h00;
            phase3[4][7:0]  <= 8'h00;
            phase3[5][7:0]  <= 8'h00;
            phase3[6][7:0]  <= 8'h00;
            phase3[7][7:0]  <= 8'h00;
            phase3[8][7:0]  <= 8'h00;
            phase3[9][7:0]  <= 8'h00;
            phase3[10][7:0] <= 8'h00;
            phase3[11][7:0] <= 8'h00;
            phase3[12][7:0] <= 8'h00;
            phase3[13][7:0] <= 8'h00;
            phase3[14][7:0] <= 8'h00;
            phase3[15][7:0] <= 8'h00;
            phase4[0][7:0]  <= 8'h00;
            phase4[1][7:0]  <= 8'h00;
            phase4[2][7:0]  <= 8'h00;
            phase4[3][7:0]  <= 8'h00;
            phase4[4][7:0]  <= 8'h00;
            phase4[5][7:0]  <= 8'h00;
            phase4[6][7:0]  <= 8'h00;
            phase4[7][7:0]  <= 8'h00;
            phase4[8][7:0]  <= 8'h00;
            phase4[9][7:0]  <= 8'h00;
            phase4[10][7:0] <= 8'h00;
            phase4[11][7:0] <= 8'h00;
            phase4[12][7:0] <= 8'h00;
            phase4[13][7:0] <= 8'h00;
            phase4[14][7:0] <= 8'h00;
            phase4[15][7:0] <= 8'h00;
            phase1[0][7:0]  <= 8'h00;
            amp1[1][7:0]  <= 8'h00;
            amp1[2][7:0]  <= 8'h00;
            amp1[3][7:0]  <= 8'h00;
            amp1[4][7:0]  <= 8'h00;
            amp1[5][7:0]  <= 8'h00;
            amp1[6][7:0]  <= 8'h00;
            amp1[7][7:0]  <= 8'h00;
            amp1[8][7:0]  <= 8'h00;
            amp1[9][7:0]  <= 8'h00;
            amp1[10][7:0] <= 8'h00;
            amp1[11][7:0] <= 8'h00;
            amp1[12][7:0] <= 8'h00;
            amp1[13][7:0] <= 8'h00;
            amp1[14][7:0] <= 8'h00;
            amp1[15][7:0] <= 8'h00;
            amp2[0][7:0]  <= 8'h00;
            amp2[1][7:0]  <= 8'h00;
            amp2[2][7:0]  <= 8'h00;
            amp2[3][7:0]  <= 8'h00;
            amp2[4][7:0]  <= 8'h00;
            amp2[5][7:0]  <= 8'h00;
            amp2[6][7:0]  <= 8'h00;
            amp2[7][7:0]  <= 8'h00;
            amp2[8][7:0]  <= 8'h00;
            amp2[9][7:0]  <= 8'h00;
            amp2[10][7:0] <= 8'h00;
            amp2[11][7:0] <= 8'h00;
            amp2[12][7:0] <= 8'h00;
            amp2[13][7:0] <= 8'h00;
            amp2[14][7:0] <= 8'h00;
            amp2[15][7:0] <= 8'h00;
            amp3[0][7:0]  <= 8'h00;
            amp3[1][7:0]  <= 8'h00;
            amp3[2][7:0]  <= 8'h00;
            amp3[3][7:0]  <= 8'h00;
            amp3[4][7:0]  <= 8'h00;
            amp3[5][7:0]  <= 8'h00;
            amp3[6][7:0]  <= 8'h00;
            amp3[7][7:0]  <= 8'h00;
            amp3[8][7:0]  <= 8'h00;
            amp3[9][7:0]  <= 8'h00;
            amp3[10][7:0] <= 8'h00;
            amp3[11][7:0] <= 8'h00;
            amp3[12][7:0] <= 8'h00;
            amp3[13][7:0] <= 8'h00;
            amp3[14][7:0] <= 8'h00;
            amp3[15][7:0] <= 8'h00;
            amp4[0][7:0]  <= 8'h00;
            amp4[1][7:0]  <= 8'h00;
            amp4[2][7:0]  <= 8'h00;
            amp4[3][7:0]  <= 8'h00;
            amp4[4][7:0]  <= 8'h00;
            amp4[5][7:0]  <= 8'h00;
            amp4[6][7:0]  <= 8'h00;
            amp4[7][7:0]  <= 8'h00;
            amp4[8][7:0]  <= 8'h00;
            amp4[9][7:0]  <= 8'h00;
            amp4[10][7:0] <= 8'h00;
            amp4[11][7:0] <= 8'h00;
            amp4[12][7:0] <= 8'h00;
            amp4[13][7:0] <= 8'h00;
            amp4[14][7:0] <= 8'h00;
            amp4[15][7:0] <= 8'h00;
		end
		else begin
            case (proc_state)
                PROC_INTI_chip00: begin if (i_SPI_ready == 1) begin 
                // 使用SPI 串行通信 给所有MSTR111初始化
                    // Serial Mode 数据为48 bits
                    //TX_H通道4~1相位校准值
                    spi_all <= 0;
                    o_chip_id <= 4'h0;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_00[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip01;
				    end
                end end
                
                PROC_INTI_chip01: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h1;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_01[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip02;
				    end
                end end
                PROC_INTI_chip02: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h2;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_02[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip03;
				    end
                end end
                PROC_INTI_chip03: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h3;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_03[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip04;
				    end
                end end
                PROC_INTI_chip04: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h4;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_04[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip05;
				    end
                end end
                PROC_INTI_chip05: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h5;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_05[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip06;
				    end
                end end
                PROC_INTI_chip06: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h6;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_06[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip07;
				    end
                end end
                PROC_INTI_chip07: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h7;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_07[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip08;
				    end
                end end
                PROC_INTI_chip08: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h8;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_08[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip09;
				    end
                end end
                PROC_INTI_chip09: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'h9;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_09[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip10;
				    end
                end end
                PROC_INTI_chip10: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hA;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_10[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip11;
				    end
                end end
                PROC_INTI_chip11: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hB;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_11[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip12;
				    end
                end end
                PROC_INTI_chip12: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hC;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_12[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip13;
				    end
                end end
                PROC_INTI_chip13: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hD;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_13[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip14;
				    end
                end end
                PROC_INTI_chip14: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hE;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_14[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_INTI_chip15;
				    end
                end end
                PROC_INTI_chip15: begin if (i_SPI_ready == 1) begin 
                    spi_all <= 0;
                    o_chip_id <= 4'hF;
                    o_spi_data_depth <= 48;
                    o_SPI_data <= MSTR111_init_reg_15[init_reg_addr];
                    o_SPI_start <= 1; // 进行一次SPI数据传输
                    init_reg_addr <= init_reg_addr+1;
				    if(init_reg_addr==262)  
				    begin
				    	init_reg_addr <= 0;
				    	o_SPI_start <= 0;
				    	proc_state <= PROC_FastSet;
				    end
                end end
                PROC_FastSet:begin
                    delay_cnt <= delay_cnt +1;
                    if(delay_cnt == 16383)
                    begin
                        delay_cnt <= 0;
                        case(FastSetTR_state)
                            FastSetTR_High:
                            begin
                                o_Fast_SetT <= 4'hF;
                                o_Fast_SetR <= 4'hF;
                                FastSetTR_state <= FastSetTR_Low;
                            end
                            FastSetTR_Low:
                            begin
                                o_Fast_SetT <= 0;
                                o_Fast_SetR <= 0;
                                FastSetTR_state <= FastSetTR_High;
                                proc_state <= PROC_IDLE;
                            end
                        endcase
                    end
                end

                PROC_IDLE: begin
                    o_SPI_start <= 0;
                    if (spi_listener_interrupt)
                        proc_state <= PROC_BUSY;
                end
                
                PROC_BUSY: begin
                    case(spi_data[20:16])
                        5'h0:  //快速波束切换
			            begin
                            case(spi_state)
                            chip_read: 
                            begin
                                spi_all <= 1;
                                o_spi_data_depth <= 27;
                                spi_state <= spi_trans;
                            end
                            spi_trans:
                            begin
                                if((Module_TX == 1 && Module_RX == 0)||(Module_TX == 1 && Module_RX == 1))
			 	                begin
                                    o_SPI_data <= {9'b111100000,spi_data[8:0],spi_data[8:0]};
                                    o_SPI_start <= 1;
                                    spi_state <= FastSetTR_posedge;
                                end
                                if(Module_TX == 0 && Module_RX == 1)
			 	                begin
                                    o_SPI_data <= {9'b111100001,spi_data[8:0],spi_data[8:0]};
                                    o_SPI_start <= 1;
                                    spi_state <= FastSetTR_posedge;
                                end
                            end
                            FastSetTR_posedge:
                            begin
                                o_SPI_start <= 0;
                                delay_cnt <= delay_cnt +1;
                                if(delay_cnt == 128)
                                begin
                                    delay_cnt <= 0;
                                    case(FastSetTR_state)
                                        FastSetTR_High:
                                        begin
                                            o_Fast_SetT <= 4'hF;
                                            o_Fast_SetR <= 4'hF;
                                            FastSetTR_state <= FastSetTR_Low;
                                        end
                                        FastSetTR_Low:
                                        begin
                                            o_Fast_SetT <= 0;
                                            o_Fast_SetR <= 0;
                                            FastSetTR_state <= FastSetTR_High;
                                            proc_state <= PROC_IDLE;
                                            spi_state <= chip_read;
                                        end
                                    endcase
                                end 
                            end                          
                            endcase                                  			            
			            end

                        5'h1:  //初始化至校准完状态
			            begin
				            proc_state <= PROC_INTI_chip00;
			            end
                        5'h2:  //相位控制
                        begin
                            case(spi_state)
                            chip_read: 
                            begin
                                spi_all <= 0;
                                o_spi_data_depth <= 48;
                                o_chip_id <= spi_data[13:10];
                                spi_state <= phase_write;
                            end
                            phase_write:
                            begin 
                                if(spi_data[9:8] == 2'b00)
                                begin
                                    phase1[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end 
                                if(spi_data[9:8] == 2'b01)
                                begin
                                    phase2[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end
                                if(spi_data[9:8] == 2'b10)
                                begin
                                    phase3[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end 
                                if(spi_data[9:8] == 2'b11)
                                begin
                                    phase4[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans; 
                                end
                            end
                            spi_trans:
                            begin
                                if((Module_TX == 1 && Module_RX == 0)||(Module_TX == 1 && Module_RX == 1))
			 	                begin
                                    o_SPI_data <= {16'h0008,phase4[o_chip_id],phase3[o_chip_id],phase2[o_chip_id],phase1[o_chip_id]};
                                    o_SPI_start <= 1;
                                    spi_state <= chip_read;
                                    proc_state <= PROC_IDLE;
                                end
                                if(Module_TX == 0 && Module_RX == 1)
			 	                begin
                                    o_SPI_data <= {16'h000c,phase4[o_chip_id],phase3[o_chip_id],phase2[o_chip_id],phase1[o_chip_id]};
                                    o_SPI_start <= 1;
                                    spi_state <= chip_read;
                                    proc_state <= PROC_IDLE;
                                end
                            end
                            endcase                                    
                        end

                        5'h3:  //幅度控制
                        begin
                            case(spi_state)
                            chip_read: 
                            begin
                                spi_all <= 0;
                                o_spi_data_depth <= 48;
                                o_chip_id <= spi_data[13:10];
                                spi_state <= phase_write;
                            end
                            phase_write:
                            begin 
                                if(spi_data[9:8] == 2'b00)
                                begin
                                    amp1[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end 
                                if(spi_data[9:8] == 2'b01)
                                begin
                                    amp2[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end
                                if(spi_data[9:8] == 2'b10)
                                begin
                                    amp3[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans;
                                end 
                                if(spi_data[9:8] == 2'b11)
                                begin
                                    amp4[o_chip_id] <= spi_data[7:0];
                                    spi_state <= spi_trans; 
                                end
                            end
                            spi_trans:
                            begin
                                if((Module_TX == 1 && Module_RX == 0)||(Module_TX == 1 && Module_RX == 1))
			 	                begin
                                    o_SPI_data <= {16'h0009,amp4[o_chip_id],amp3[o_chip_id],amp2[o_chip_id],amp1[o_chip_id]};
                                    o_SPI_start <= 1;
                                    spi_state <= chip_read;
                                    proc_state <= PROC_IDLE;
                                end
                                if(Module_TX == 0 && Module_RX == 1)
			 	                begin
                                    o_SPI_data <= {16'h000d,amp4[o_chip_id],amp3[o_chip_id],amp2[o_chip_id],amp1[o_chip_id]};
                                    o_SPI_start <= 1;
                                    spi_state <= chip_read;
                                    proc_state <= PROC_IDLE;
                                end
                            end
                            endcase                                    
                        end

                        5'h4: //收发模式切换及通道开关控制
                        begin
                            spi_all <= 0;
                            o_spi_data_depth <= 48;
                            o_chip_id <= spi_data[11:8];
                            o_SPI_data <= {32'h000200FF,spi_data[7:0],8'h00};
                            o_SPI_start <= 1;
                            proc_state <= PROC_IDLE;
                        end
                        5'h5: //FastSet发送上升沿，更新幅度相位信息
                        begin
                            if((Module_TX == 1 && Module_RX == 0)||(Module_TX == 1 && Module_RX == 1)) 
                            begin
                                case(FastSetTR_state)
                                    FastSetTR_High:
                                    begin
                                        o_Fast_SetT <= 4'hF;
                                        FastSetTR_state <= FastSetTR_Low;
                                    end
                                    FastSetTR_Low:
                                    begin
                                        o_Fast_SetT <= 0;
                                        FastSetTR_state <= FastSetTR_High;
                                        proc_state <= PROC_IDLE;
                                    end
                            endcase
                            end
                            else if(Module_TX == 0 && Module_RX == 1)
                            begin
                                case(FastSetTR_state)
                                    FastSetTR_High:
                                    begin
                                        o_Fast_SetR <= 4'hF;
                                        FastSetTR_state <= FastSetTR_Low;
                                    end
                                    FastSetTR_Low:
                                    begin
                                        o_Fast_SetR <= 0;
                                        FastSetTR_state <= FastSetTR_High;
                                        proc_state <= PROC_IDLE;
                                    end
                                endcase
                            end
                            else begin
                                o_Fast_SetT <= 0;
                                o_Fast_SetR <= 0;
                                proc_state <= PROC_IDLE;
                            end
                        end
                        5'h6: //关闭全部通道，执行后用SPI控制收发
                        begin 
                            spi_all <= 1;
                            o_spi_data_depth <= 48;
                            o_SPI_data <= 48'h0002_00FF_0000; 
                            o_SPI_start <= 1;
                            proc_state <= PROC_IDLE;
                        end
                        5'h7: //打开全部通道，执行后用SPI控制收发
                        begin 
                            if((Module_TX == 1 && Module_RX == 0)||(Module_TX == 1 && Module_RX == 1)) //发射模式
                            begin
                                spi_all <= 1;
                                o_spi_data_depth <= 48;
                                o_SPI_data <= 48'h0002_00FF_0F00; 
                                o_SPI_start <= 1;
                                proc_state <= PROC_IDLE;
                            end
                            if(Module_TX == 0 && Module_RX == 1) //接收模式
                            begin
                                spi_all <= 1;
                                o_spi_data_depth <= 48;
                                o_SPI_data <= 48'h0002_00FF_F000; 
                                o_SPI_start <= 1;
                                proc_state <= PROC_IDLE;
                            end
                        end
                        5'h8: //打开全部通道，执行后用Fast_TR控制收发
                        begin 
                            spi_all <= 1;
                            o_spi_data_depth <= 48;
                            o_SPI_data <= 48'h0002_0000_0000; 
                            o_SPI_start <= 1;
                            proc_state <= PROC_IDLE;
                        end
                    endcase 
                end
            endcase
                

	    end //复位else结束
end //always 结束
endmodule