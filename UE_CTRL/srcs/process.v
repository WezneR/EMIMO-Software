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
// Revision v4 （已弃用：不支持HDMI输入的控制信号）
//      
//
// 2025-02-25 14:53:16
// Revision v5 （已弃用：不支持同时控制TX的所有通道或RX的所有通道的衰减器）
//  - 加入了来自HDMI接口的外部SPI控制信号，需要和原来的USB接口的UART信号进行选路，选路信号为PLUG_IN。
//    为了使两种控制信号兼容同一个process模块，需要删除原来process模块中有关receive_data_bytes和interrupt_clear的部分。
//    只留下相同的部分：32位的输入数据 和 一个中断信号。
//
//
// 2025-03-30 18:21:22
// Revision v6 （当前版本）
// - 修改了帧格式定义中有关 ALL_DSA 字段的部分。新的版允许同时控制TX的所有通道或RX的所有通道的衰减器，或者同时控制TX+RX的所有通道的衰减器。
//
//
//
//////////////////////////////////////////////////////////////////////////////////
module ctrl_process (
    input               clk_100M,              // 时钟信号
    input               rst_n,                 // 复位信号

    // 控制信号输入
    input wire [31:0] ctrl_data,
    input wire ctrl_interrupt,

    // 和DSA数据和控制有关的信号
    output reg [5:0] TX_B1_DSA,
    output reg [7:0] TX_B1_LE,
    output reg [5:0] RX_B1_DSA,
    output reg [7:0] RX_B1_LE,
    output reg [5:0] TX_B2_DSA,
    output reg [7:0] TX_B2_LE,
    output reg [5:0] RX_B2_DSA,
    output reg [7:0] RX_B2_LE,

    // 和前端射频开关和TR方向有关的信号
    output reg [1:0] o_TX_ON,
    output reg [1:0] o_RX_ON,
    // LNA_BYPASS
    output reg [7:0] o_B1_LNA_BYPASS,
    output reg [7:0] o_B2_LNA_BYPASS
);

    // 定义命令地址常量
    localparam CMD_SWITCH_TXRX     = 4'h4;
    localparam CMD_POWER_DOWN      = 4'h6;
    localparam CMD_RECV_BOARD_ID   = 4'h7;
    localparam CMD_WRITE_DSA       = 4'hA;
    localparam CMD_LNA_BP          = 4'hB;

    localparam BOARD_ID_ALL = 4'h0;

    // 板子ID定义
    reg [3:0] Board_ID = BOARD_ID_ALL;     // FPGA本地存储的Board_ID

    // 提取主机数据的字段
    wire [3:0] host_board_id= ctrl_data[31:28];
    wire [1:0] host_bank_id = ctrl_data[25:24];
    wire [3:0] host_dsa_id = ctrl_data[23:20];
    wire [3:0] cmd_addr = ctrl_data[19:16];
    wire [15:0] host_data = ctrl_data[15:0];


    // 保存DSA的衰减码字和片选信息
    reg [5:0] dsa_att;
    reg [1:0] Bank_ID;
    reg [3:0] DSA_ID;
    reg [1:0] ALL_DSA;

    // 维持DSA(HMC1122)数据和LE时序的状态机
    reg [1:0] write_dsa_state;
    localparam S_WDSA_IDLE = 0,
                S_WDSA_DATA_START = 1,
                S_WDSA_LE_HIGH = 2,
                S_WDSA_LE_LOW = 3;
    reg [3:0] write_dsa_cnt = 0;
    

    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n) begin
            // 所有状态机回到初始状态
            write_dsa_state <= S_WDSA_IDLE;
            // 所有控制信号置为初始值
            o_TX_ON <=0;
            o_RX_ON <=0;
            TX_B1_DSA <=0;
            TX_B1_LE <=0;
            RX_B1_DSA <=0;
            RX_B1_LE <=0;
            TX_B2_DSA <=0;
            TX_B2_LE <=0;
            RX_B2_DSA <=0;
            RX_B2_LE <=0;
            o_B1_LNA_BYPASS <=0;
            o_B2_LNA_BYPASS <=0;
        end 
        else begin
            if (ctrl_interrupt) begin
                // 比较主机的Board_ID与本地存储的Board_ID
                if (host_board_id == Board_ID || host_board_id == BOARD_ID_ALL) begin
                    // 处理不同的命令地址
                    case (cmd_addr)
                        CMD_SWITCH_TXRX: begin
                            // 通过指令切换TX或RX状态
                            if (host_data[9] != host_data[8]) begin
                                case (host_bank_id)
                                    2'd0, 2'd1: begin
                                        o_TX_ON[host_bank_id] <= host_data[9];
                                        o_RX_ON[host_bank_id] <= host_data[8];                                                
                                    end
                                    2'd2: begin
                                        o_TX_ON <= {2{host_data[9]}};
                                        o_RX_ON <= {2{host_data[8]}};
                                    end
                                    default: begin
                                        o_TX_ON <= o_TX_ON;
                                        o_RX_ON <= o_RX_ON;
                                    end
                                endcase
                            end
                            else begin
                                case (host_bank_id)
                                    2'd0, 2'd1: begin
                                        o_TX_ON[host_bank_id] <= 0;
                                        o_RX_ON[host_bank_id] <= 0;                                                
                                    end
                                    2'd2: begin
                                        o_TX_ON <= 0;
                                        o_RX_ON <= 0;
                                    end
                                    default: begin
                                        o_TX_ON <= o_TX_ON;
                                        o_RX_ON <= o_RX_ON;
                                    end
                                endcase
                            end
                        end
                        CMD_POWER_DOWN: begin
                            // 关闭所有通道
                            o_TX_ON <= 0;
                            o_RX_ON <= 0;
                        end
                        CMD_RECV_BOARD_ID: begin
                            // 修改Board_ID
                            Board_ID <= host_data[3:0];
                        end
                        CMD_WRITE_DSA: begin
                            // 保存DSA衰减值
                            dsa_att <= host_data[5:0];
                            ALL_DSA <= host_data[9:8];
                            Bank_ID <= host_bank_id;
                            DSA_ID <= host_dsa_id;
                            write_dsa_state <= S_WDSA_DATA_START;
                        end
                        CMD_LNA_BP: begin
                            case (host_bank_id)
                                2'd0: begin
                                    if (host_data[8]) begin // ALL_LNA
                                        o_B1_LNA_BYPASS <= {8{host_data[0]}};
                                    end
                                    else begin
                                        o_B1_LNA_BYPASS[host_dsa_id[2:0]] <= host_data[0];
                                    end
                                end
                                2'd1: begin
                                    if (host_data[8]) begin // ALL_LNA
                                        o_B2_LNA_BYPASS <= {8{host_data[0]}};
                                    end
                                    else begin
                                        o_B2_LNA_BYPASS[host_dsa_id[2:0]] <= host_data[0];
                                    end
                                end
                                2'd2: begin
                                    if (host_data[8]) begin // ALL_LNA
                                        o_B1_LNA_BYPASS <= {8{host_data[0]}};
                                        o_B2_LNA_BYPASS <= {8{host_data[0]}};
                                    end
                                    else begin
                                        o_B1_LNA_BYPASS[host_dsa_id[2:0]] <= host_data[0];
                                        o_B2_LNA_BYPASS[host_dsa_id[2:0]] <= host_data[0];
                                    end
                                end
                                default: begin
                                    
                                end
                            endcase
                        end
                        default: begin
                            // 其他未定义的命令处理
                        end
                    endcase
                end
            end

            // 负责更新DSA数据总线的模块
            if (write_dsa_state == S_WDSA_DATA_START) begin
                case (Bank_ID)
                    2'd0: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某一个DSA
                                if (DSA_ID < 8) begin
                                    TX_B1_DSA <= dsa_att;
                                end
                                else begin
                                    RX_B1_DSA <= dsa_att;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B1_DSA <= dsa_att;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B1_DSA <= dsa_att;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B1_DSA <= dsa_att;
                                RX_B1_DSA <= dsa_att;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    2'd1: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某一个DSA
                                if (DSA_ID < 8) begin
                                    TX_B2_DSA <= dsa_att;
                                end
                                else begin
                                    RX_B2_DSA <= dsa_att;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B2_DSA <= dsa_att;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B2_DSA <= dsa_att;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B2_DSA <= dsa_att;
                                RX_B2_DSA <= dsa_att;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    2'd2: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某两个DSA
                                if (DSA_ID < 8) begin
                                    TX_B1_DSA <= dsa_att;
                                    TX_B2_DSA <= dsa_att;
                                end
                                else begin
                                    RX_B1_DSA <= dsa_att;
                                    RX_B2_DSA <= dsa_att;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B1_DSA <= dsa_att;
                                RX_B2_DSA <= dsa_att;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B1_DSA <= dsa_att;
                                TX_B2_DSA <= dsa_att;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B1_DSA <= dsa_att;
                                TX_B2_DSA <= dsa_att;
                                RX_B1_DSA <= dsa_att;
                                RX_B2_DSA <= dsa_att;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    default: begin
                        
                    end
                endcase
                write_dsa_state <= S_WDSA_LE_HIGH;
            end

            // 负责拉高所选衰减器LE的模块
            if (write_dsa_state == S_WDSA_LE_HIGH) begin
                case (Bank_ID)
                    2'd0: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某一个DSA
                                if (DSA_ID < 8) begin
                                    TX_B1_LE[DSA_ID[2:0]] <= 1;
                                end
                                else begin
                                    RX_B1_LE[DSA_ID[2:0]] <= 1;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B1_LE <= 8'hFF;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B1_LE <= 8'hFF;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B1_LE <= 8'hFF;
                                RX_B1_LE <= 8'hFF;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    2'd1: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某一个DSA
                                if (DSA_ID < 8) begin
                                    TX_B2_LE[DSA_ID[2:0]] <= 1;
                                end
                                else begin
                                    RX_B2_LE[DSA_ID[2:0]] <= 1;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B2_LE <= 8'hFF;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B2_LE <= 8'hFF;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B2_LE <= 8'hFF;
                                RX_B2_LE <= 8'hFF;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    2'd2: begin
                        case (ALL_DSA)
                            2'd0: begin // 只更新某两个DSA
                                if (DSA_ID < 8) begin
                                    TX_B1_LE[DSA_ID[2:0]] <= 1;
                                    TX_B2_LE[DSA_ID[2:0]] <= 1;
                                end
                                else begin
                                    RX_B1_LE[DSA_ID[2:0]] <= 1;
                                    RX_B2_LE[DSA_ID[2:0]] <= 1;
                                end
                            end
                            2'd1: begin // 更新所有RX DSA
                                RX_B1_LE <= 8'hFF;
                                RX_B2_LE <= 8'hFF;
                            end
                            2'd2: begin // 更新所有TX DSA
                                TX_B1_LE <= 8'hFF;
                                TX_B2_LE <= 8'hFF;
                            end
                            2'd3: begin // 更新所有DSA
                                TX_B1_LE <= 8'hFF;
                                TX_B2_LE <= 8'hFF;
                                RX_B1_LE <= 8'hFF;
                                RX_B2_LE <= 8'hFF;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    default: begin
                        
                    end
                endcase
                write_dsa_state <= S_WDSA_LE_LOW;
            end


            // 负责维持LE高电平一段时间（约几十纳秒）后拉低的模块
            if (write_dsa_state == S_WDSA_LE_LOW) begin
                write_dsa_cnt <= write_dsa_cnt + 1;
                if (write_dsa_cnt > 4) begin
                    TX_B1_LE <= 0;
                    RX_B1_LE <= 0;
                    TX_B2_LE <= 0;
                    RX_B2_LE <= 0;
                    write_dsa_cnt <=0;
                    write_dsa_state <= S_WDSA_IDLE;
                end
            end


        end
    end

endmodule