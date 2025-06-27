`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:    hyq
//
// Create Date:    10:54 10/16/2024
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
//
// 2024年10月24日13:46:46
// Revision v4（Obsoleted）：
//      
//
//
//
//  2024年11月18日20:32:21
//  Revision v5（当前版本）：
//
//      测试时才注意到RX的4个移相器芯片因为在背面，每个芯片的Channel_1相比Channel_2更靠近阵元#7而不是阵元#1，即，连接FEM Chip_ID = 0（通道0、阵元#0）的，分别是PE44951 Chip_ID = 0的Channel_1（TX0）和Chip_ID = 4的Channel_2（RX0）。
//      所以原来的逻辑是错的，在处理RX的移相器时，channel_ID应当反过来才对。
//      简单来说，Chip_ID为0至3的4个PE44951，仍然保持不变，它们的输出映射到FEM的关系如下：
//
//                  Channel1            FEM0
//      PS0         
//                  Channel2            FEM1
//
//
//                  Channel1            FEM2
//      PS1         
//                  Channel2            FEM3
//   
//   
//                  Channel1            FEM4
//      PS2         
//                  Channel2            FEM5
//
//
//                  Channel1            FEM6
//      PS3         
//                  Channel2            FEM7
//
//
//      但是负责RX的、Chip_ID为4至7的4个PE44951，映射到FEM的关系在实际的硬件上，如下所示：
//
//                  Channel2            FEM0
//      PS4         
//                  Channel1            FEM1
//
//
//                  Channel2            FEM2
//      PS5         
//                  Channel1            FEM3
//   
//   
//                  Channel2            FEM4
//      PS6         
//                  Channel1            FEM5
//
//
//                  Channel2            FEM6
//      PS7         
//                  Channel1            FEM7
//
//
//      由于这种“1,0,3,2,5,4,7,6”的映射顺序非常不符合认知习惯，所以在新的 process 模块中，把RX的4个PE44951的Channel_ID顺序反过来。
//
//      新的映射关系框图如下:
//
//                  Channel1            FEM0
//      PS4         
//                  Channel2            FEM1
//
//
//                  Channel1            FEM2
//      PS5         
//                  Channel2            FEM3
//   
//   
//                  Channel1            FEM4
//      PS6         
//                  Channel2            FEM5
//
//
//                  Channel1            FEM6
//      PS7         
//                  Channel2            FEM7
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////
module spi_process #(
    parameter spi_listener_data_len = 32,
    parameter spi_master_data_len = 24
)(
    input               clk_100M,              // 时钟信号
    input               rst_n,                 // 复位信号
    input               i_DEV_MODE,
    input               i_UPDATE,
    input               i_spi_listener_interrupt,  // SPI监听器的中断信号
    input  [spi_listener_data_len-1:0] i_spi_data,  // 从SPI监听器接收到的主机数据

    output reg [3:0]    o_chip_id,             // 芯片ID
    output reg [spi_master_data_len-1:0] o_SPI_data, // 要发送给PE44951的SPI数据
    output reg [4:0]    o_spi_data_depth,      // SPI数据的深度
    output reg          o_SPI_start,           // SPI开始信号
    input               i_SPI_ready,           // SPI准备就绪信号

    // 控制信号
    output reg          o_RsetB,               // 复位信号
    output reg [1:0]    o_LP_Pulse,            // 更新相位脉冲信号
    output reg [7:0]    o_TX_ON,               // 打开射频TX开关
    output reg [7:0]    o_RX_ON,               // 打开射频RX开关
    output reg          o_IF_TX_ON,            // 打开中频TX开关
    output reg          o_IF_RX_ON,            // 打开中频RX开关
    output reg          o_LNA_BYPASS,          // LNA旁路信号
    output reg [1:0]    o_IFDSA_LE,
    output reg [11:0]   o_IFDSA_DIN
);

    // 定义命令地址常量
    localparam CMD_PHASE_ARRAY_CAL = 4'h0;
    localparam CMD_INIT            = 4'h1;
    localparam CMD_WRITE_PHASE     = 4'h2;
    localparam CMD_WRITE_ATTEN     = 4'h3;
    localparam CMD_SWITCH_TXRX     = 4'h4;
    localparam CMD_UPDATE_PHASE    = 4'h5;
    localparam CMD_POWER_DOWN      = 4'h6;
    localparam CMD_RECV_BOARD_ID   = 4'h7;
    localparam CMD_RECV_PHASE_INIT = 4'h8;
    localparam CMD_RECV_ATTEN_INIT = 4'h9;
    localparam CMD_WRITE_IFDSA     = 4'hA;

    localparam BOARD_ID_ALL = 4'h8;
    localparam BOARD_ID_MODULE_ONLY = 4'h9;

    // 板子ID定义
    reg [3:0] Modlue_ID;     // FPGA本地存储的Modlue_ID
    reg [3:0] Board_ID = BOARD_ID_ALL;     // FPGA本地存储的Board_ID
    wire [7:0] General_BID = {Modlue_ID, Board_ID};

    // 提取主机数据的字段
    wire [3:0] host_module_id = i_spi_data[31:28];
    wire [3:0] host_board_id = i_spi_data[27:24];
    wire [3:0] host_chip_id = i_spi_data[23:20];
    wire [3:0] cmd_addr = i_spi_data[19:16];
    wire [15:0] host_data = i_spi_data[15:0];

    wire channel_id = host_data[8];

    // 状态寄存器，映射关系按照新的框图所示。例如，BF_phase_reg [8]表示 PS_Chip_ID = 4 的移相器芯片的Channel_ID = 0 的通道
    reg [7:0] BF_phase_reg [15:0];      // 移相寄存器
    reg [7:0] AC_phase_reg [15:0];      // 移相寄存器
    reg [7:0] atten_reg_init [15:0];      // 衰减寄存器初始值
    reg [7:0] atten_reg [15:0];      // 衰减寄存器


    reg [1:0] init_state;
    reg [4:0] init_cnt = 0;
    localparam  S_INIT_IDEL = 0,
                S_INIT_BF = 1,
                S_INIT_AC = 2,
                S_INIT_ATT = 3;


    reg LP_state;
    reg [3:0] LP_cnt = 0;
    localparam  S_LP_LOW = 0,
                S_LP_HIGH = 1;

    integer i;
    integer j;

    reg write_onece_state;
    reg write_onece_cnt = 0;
    localparam  S_WO_IDEL = 0,
                S_WO_BUSY = 1;
    reg [3:0] write_onece_chip_id;
    reg [spi_master_data_len-1:0] write_onece_spi_data;
    reg [4:0] write_onece_data_depth;


    reg signed [7:0] ang_pitch;
    reg signed [7:0] ang_azimuth;
    wire [7:0] PSB0;
    wire [7:0] PSB1;
    wire [7:0] PSB2;
    wire [7:0] PSB3;
    wire [7:0] PSB4;
    wire [7:0] PSB5;
    wire [7:0] PSB6;
    wire [7:0] PSB7;


    phase_shift_calculator phase_shift_calculator_inst(
        .ang_pitch(ang_pitch),
        .ang_azimuth(ang_azimuth),
        .General_BID(General_BID),
        .PSB0(PSB0),
        .PSB1(PSB1),
        .PSB2(PSB2),
        .PSB3(PSB3),
        .PSB4(PSB4),
        .PSB5(PSB5),
        .PSB6(PSB6),
        .PSB7(PSB7)
    );

    reg [1:0] beamform_state;
    reg [4:0] beamform_cnt = 0;
    localparam  S_BF_IDEL = 0,
                S_BF_CAL = 1,
                S_BF_LOAD = 2;

    // 保存IFDSA的衰减码字
    reg [5:0] IFDSA_atten_reg [1:0];
    reg [1:0] IFDSA_ID;
    reg  load_IFDSA;

    // o_RsetB 复位计数器
    reg [4:0] rst_cn = 0;


    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n) begin
            o_RsetB <= 1'b0;
            o_SPI_data <= 24'd0;
            o_spi_data_depth <= 5'd0;
            o_chip_id <= 0;
            o_SPI_start <= 0;
            o_TX_ON <= 8'd0;
            o_RX_ON <= 8'd0;
            o_LNA_BYPASS <= 1'b0;
            o_LP_Pulse <= 2'b00;
            o_IFDSA_LE <= 0;
            o_IFDSA_DIN <= 0;
            init_state <= S_INIT_IDEL;
            LP_state <= S_LP_LOW;
            write_onece_state <= S_WO_IDEL;
            beamform_state <= S_BF_IDEL;
        end
        else begin
            if (i_spi_listener_interrupt) begin
                // 比较主机的Board_ID与本地存储的Board_ID
                if (({host_module_id, host_board_id} == General_BID) || (host_board_id == BOARD_ID_ALL) || (host_module_id == Modlue_ID && host_board_id == BOARD_ID_MODULE_ONLY)) begin
                    // 处理不同的命令地址
                    case (cmd_addr)
                        CMD_PHASE_ARRAY_CAL: begin
                            ang_pitch <= host_data[7:0];
                            ang_azimuth <= host_data[15:8];
                            beamform_state <= S_BF_CAL;
                        end
                        CMD_INIT: begin
                            // 初始化所有通道的相位和幅度
                            if (init_state == S_INIT_IDEL)
                                init_state <= S_INIT_BF;
                        end
                        CMD_WRITE_PHASE: begin
                            // 向指定的芯片和通道写入相位信息
                            if (write_onece_state == S_WO_IDEL) begin
                                write_onece_chip_id <= host_chip_id;
                                case (host_chip_id)
                                    4'd0, 4'd1, 4'd2, 4'd3, 4'd8, 4'd9: begin
                                        write_onece_spi_data <= {2'b00, 4'b1110, host_data[9:8], 8'h00, host_data[7:0]};
                                    end
                                    4'd4, 4'd5, 4'd6, 4'd7, 4'd10: begin
                                        write_onece_spi_data <= {2'b00, 4'b1110, host_data[9], ~host_data[8], 8'h00, host_data[7:0]}; // 将RX通道的Channel_ID顺序反过来
                                    end
                                    default: begin
                                        // 无效的chip_ID
                                        write_onece_spi_data <= 0;
                                    end
                                endcase
                                write_onece_data_depth <= 5'd24;
                                write_onece_state <= S_WO_BUSY;
                            end
                        end
                        CMD_WRITE_ATTEN: begin
                            // 向指定的芯片和通道写入衰减信息
                            if (write_onece_state == S_WO_IDEL) begin
                                write_onece_chip_id <= host_chip_id;
                                case (host_chip_id)
                                    4'd0, 4'd1, 4'd2, 4'd3, 4'd8, 4'd9: begin
                                        write_onece_spi_data <= {2'b00, 5'b11110, channel_id, 8'h00, host_data[7:0]};
                                    end
                                    4'd4, 4'd5, 4'd6, 4'd7, 4'd10: begin
                                        write_onece_spi_data <= {2'b00, 5'b11110, ~channel_id, 8'h00, host_data[7:0]}; // 将RX通道的Channel_ID顺序反过来
                                    end
                                    default: begin
                                        // 无效的chip_ID
                                        write_onece_spi_data <= 0;
                                    end
                                endcase
                                write_onece_data_depth <= 5'd24;
                                write_onece_state <= S_WO_BUSY;
                            end
                        end
                        CMD_SWITCH_TXRX: begin
                            // 通过SPI指令切换指定通道的TX或RX状态，只允许在DEV_MODE下执行该操作
                            if (i_DEV_MODE == 1) begin
                                // 如果TX和RX同时为1或同时为0，则视作“既不打开TX也不打开RX”
                                if (host_data[9] != host_data[8]) begin
                                    case (host_chip_id)
                                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7: begin
                                            // if (o_TX_ON == 0 && o_RX_ON == 0) begin
                                                o_TX_ON[host_chip_id[2:0]] <= host_data[9];
                                                o_RX_ON[host_chip_id[2:0]] <= host_data[8];
                                            // end
                                        end
                                        4'd8: begin
                                            o_TX_ON[7:0] <= {8{host_data[9]}};
                                            o_RX_ON[7:0] <= {8{host_data[8]}};
                                        end
                                        default: begin
                                            o_TX_ON <= o_TX_ON;
                                            o_RX_ON <= o_RX_ON;
                                        end
                                    endcase
                                end
                                else begin
                                    case (host_chip_id)
                                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7: begin
                                            o_TX_ON[host_chip_id[2:0]] <= 0;
                                            o_RX_ON[host_chip_id[2:0]] <= 0;
                                        end
                                        4'd8: begin
                                            o_TX_ON[7:0] <= 0;
                                            o_RX_ON[7:0] <= 0;
                                        end
                                        default: begin
                                            o_TX_ON <= o_TX_ON;
                                            o_RX_ON <= o_RX_ON;
                                        end
                                    endcase
                                end
                            end
                        end
                        CMD_UPDATE_PHASE: begin
                            // 触发相位更新脉冲
                            if (LP_state == S_LP_LOW)
                                LP_state <= S_LP_HIGH;
                        end
                        CMD_POWER_DOWN: begin
                            // 关闭所有通道
                            o_TX_ON <= 0;
                            o_RX_ON <= 0;
                            // o_LNA_BYPASS <= 1;
                        end
                        CMD_RECV_BOARD_ID: begin
                            // 修改Board_ID
                            Modlue_ID <= host_data[7:4];
                            Board_ID <= host_data[3:0];
                        end
                        CMD_RECV_PHASE_INIT: begin
                            // 修改初始化相位值
                            case (host_chip_id)
                                4'd8: begin
                                    // 给所有16个寄存器赋值
                                    for (i = 0; i < 16; i = i + 1) begin
                                        BF_phase_reg[i] <= host_data[7:0];
                                    end
                                end
                                4'd9: begin
                                    // 给前8个寄存器赋值
                                    for (i = 0; i < 8; i = i + 1) begin
                                        BF_phase_reg[i] <= host_data[7:0];
                                    end
                                end
                                4'd10: begin
                                    // 给后8个寄存器赋值
                                    for (i = 8; i < 16; i = i + 1) begin
                                        BF_phase_reg[i] <= host_data[7:0];
                                    end
                                end
                                default: begin
                                    BF_phase_reg[{host_chip_id[2:0], channel_id}] <= host_data[7:0];
                                end
                            endcase

                        end
                        CMD_RECV_ATTEN_INIT: begin
                            // 修改初始化幅度衰减值
                            atten_reg_init[{host_chip_id[2:0], channel_id}] <= host_data[7:0];
                        end
                        CMD_WRITE_IFDSA: begin
                            // 保存IFDSA衰减值
                            case (host_chip_id[1:0])
                                2'd0, 2'd1: begin
                                    IFDSA_atten_reg [host_chip_id[1:0]] <= host_data[5:0];
                                end
                                2'd2: begin
                                    for (i = 0; i < 2; i = i + 1) begin
                                        IFDSA_atten_reg[i] <= host_data[5:0];
                                    end
                                end
                                default:
                                    IFDSA_atten_reg[0] <= IFDSA_atten_reg[0];
                            endcase
                            load_IFDSA <= host_data[8];
                            IFDSA_ID <= host_chip_id[1:0];
                        end
                        default: begin
                            // 其他未定义的命令处理
                        end
                    endcase
                end
            end

            // 负责执行PE44951初始化的模块
            if (init_state == S_INIT_BF && i_SPI_ready == 1) begin
                if (init_cnt < 5'd16) begin
                    o_chip_id <= init_cnt[3:1];
                    if (init_cnt < 5'd8) begin
                        o_SPI_data <= {2'b00, 3'b000, 3'b001, BF_phase_reg[init_cnt], BF_phase_reg[init_cnt + 1]};
                    end
                    else begin // 负责RX的4片移相器芯片，Channel_ID应该倒序
                        o_SPI_data <= {2'b00, 3'b000, 3'b001, BF_phase_reg[init_cnt + 1], BF_phase_reg[init_cnt]};
                    end
                    o_spi_data_depth <= 5'd24;
                    o_SPI_start <= 1'b1;
                    init_cnt <= init_cnt + 2;
                end
                else begin
                    init_state <= S_INIT_AC;
                    o_SPI_start <= 0;
                    init_cnt <= 0;
                end
            end

            if (init_state == S_INIT_AC && i_SPI_ready == 1) begin
                if (init_cnt < 5'd1) begin
                    o_chip_id <= 4'd8;
                    // 所有AC寄存器写入0
                    o_SPI_data <= {2'b00, 3'b010, 3'b011, 8'b0, 8'b0};
                    o_spi_data_depth <= 5'd24;
                    o_SPI_start <= 1'b1;
                    init_cnt <= init_cnt + 2;
                end
                else begin
                    init_state <= S_INIT_ATT;
                    o_SPI_start <= 0;
                    init_cnt <= 0;
                end
            end

            if (init_state == S_INIT_ATT && i_SPI_ready == 1) begin
                if (init_cnt < 5'd16) begin
                    o_chip_id <= init_cnt[3:1];
                    if (init_cnt < 5'd8) begin
                        o_SPI_data <= {2'b00, 3'b100, 3'b101, atten_reg_init[init_cnt], atten_reg_init[init_cnt + 1]};
                    end
                    else begin // 负责RX的4片移相器芯片，Channel_ID应该倒序
                        o_SPI_data <= {2'b00, 3'b100, 3'b101, atten_reg_init[init_cnt + 1], atten_reg_init[init_cnt]};
                    end
                    o_spi_data_depth <= 5'd24;
                    o_SPI_start <= 1'b1;
                    init_cnt <= init_cnt + 2;
                end
                else begin
                    init_state <= S_INIT_IDEL;
                    LP_state <= S_LP_HIGH;
                    o_SPI_start <= 0;
                    init_cnt <= 0;
                end
            end


            // 负责写相位值的模块
            if (write_onece_state == S_WO_BUSY && init_state == S_INIT_IDEL && i_SPI_ready == 1) begin
                if (write_onece_cnt == 0) begin
                    o_chip_id <= write_onece_chip_id;
                    o_SPI_data <= write_onece_spi_data;
                    o_spi_data_depth <= write_onece_data_depth;
                    o_SPI_start <= 1'b1;
                    write_onece_cnt <= 1;
                end
                else begin
                    write_onece_state <= S_WO_IDEL;
                    o_SPI_start <= 0;
                    write_onece_cnt <= 0;
                end
            end

            // 负责把AC寄存器中的码字发送给PE44951的模块
            if (beamform_state == S_BF_LOAD && init_state == S_INIT_IDEL && write_onece_state == S_WO_IDEL && i_SPI_ready == 1) begin
                if (beamform_cnt < 5'd16) begin
                    o_chip_id <= beamform_cnt[3:1];
                    if (beamform_cnt < 5'd8) begin
                        o_SPI_data <= {2'b00, 3'b010, 3'b011, AC_phase_reg[beamform_cnt], AC_phase_reg[beamform_cnt + 1]};
                    end
                    else begin // 负责RX的4片移相器芯片，Channel_ID应该倒序
                        o_SPI_data <= {2'b00, 3'b010, 3'b011, AC_phase_reg[beamform_cnt + 1], AC_phase_reg[beamform_cnt]};
                    end
                    o_spi_data_depth <= 5'd24;
                    o_SPI_start <= 1'b1;
                    beamform_cnt <= beamform_cnt + 2;
                end
                else begin
                    o_SPI_start <= 0;
                    beamform_cnt <= 0;
                    beamform_state <= S_BF_IDEL;
                end
            end

            // 负责拉高 LP 的模块
            if (LP_state == S_LP_HIGH && init_state == S_INIT_IDEL && write_onece_state == S_WO_IDEL && beamform_state == S_BF_IDEL && i_SPI_ready == 1) begin
                o_LP_Pulse <= 2'b11;
                LP_state <= S_LP_LOW;
            end
            // 负责维持 LP 高电平一段时间后拉低的模块
            else if (o_LP_Pulse == 2'b11) begin
                if (LP_cnt < 3'd4) begin
                    LP_cnt <= LP_cnt + 1;
                end
                else begin
                    o_LP_Pulse <= 2'b00;
                    LP_cnt <= 0;
                end
            end

            // 硬件触发 LP
            if (i_UPDATE == 1 && LP_state == S_LP_LOW) begin
                LP_state <= S_LP_HIGH;
            end

            // 负责把移相码字存入AC寄存器的模块
            if (beamform_state == S_BF_CAL) begin
                AC_phase_reg[0] <= PSB0;
                AC_phase_reg[1] <= PSB1;
                AC_phase_reg[2] <= PSB2;
                AC_phase_reg[3] <= PSB3;
                AC_phase_reg[4] <= PSB4;
                AC_phase_reg[5] <= PSB5;
                AC_phase_reg[6] <= PSB6;
                AC_phase_reg[7] <= PSB7;

                AC_phase_reg[8] <= PSB0;
                AC_phase_reg[9] <= PSB1;
                AC_phase_reg[10] <= PSB2;
                AC_phase_reg[11] <= PSB3;
                AC_phase_reg[12] <= PSB4;
                AC_phase_reg[13] <= PSB5;
                AC_phase_reg[14] <= PSB6;
                AC_phase_reg[15] <= PSB7;

                beamform_state <= S_BF_LOAD;
            end

            // 负责load IFDSA的模块
            if (load_IFDSA == 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    o_IFDSA_DIN[j*6 +: 6] <= IFDSA_atten_reg[j];
                end
                load_IFDSA <= 0;
                o_IFDSA_LE <= 2'b11;
            end

            // 负责维持IFDSA并口时序的模块
            if (o_IFDSA_LE == 2'b11) begin
                o_IFDSA_LE <= 0;
            end

            // 负责维持 o_RsetB 低电平一段时间后拉高的模块
            if (o_RsetB == 0) begin
                o_RsetB <= 1;
                if (rst_cn < 3'd6) begin
                    rst_cn <= rst_cn + 1;
                end
                else begin
                    o_RsetB <= 1;
                    rst_cn <= 0;
                end
            end

        end
    end

always @(*) begin
    o_IF_TX_ON = |o_TX_ON[7:0];  // 如果o_TX_ON中至少有一个为1，则打开中频TX
    o_IF_RX_ON = |o_RX_ON[7:0];  // 如果o_RX_ON中至少有一个为1，则打开中频RX
end


endmodule
