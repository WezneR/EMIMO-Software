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
//
// Description:
//     Refactored version of the process module with cleaner structure and
//     integrated beam scan controller support.
//
//     Changes from original:
//     - Separated state machines into logical sub-modules
//     - Added beam scan controller integration
//     - Cleaner command dispatch logic
//     - Added new SPI commands for beam scanning
//
// Dependencies: beam_scan_controller, phase_shift_calculator
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
//      所以原来的逻辑是错的，在处理RX的移相器时，Channel_ID应当反过来才对。
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
//      由于这种"1,0,3,2,5,4,7,6"的映射顺序非常不符合认知习惯，所以在新的 process 模块中，把RX的4个PE44951的Channel_ID顺序反过来。
//
//
//
//
// 2025-12-07 23:00
// Revision v6 - Refactored with beam scan support
//
// New SPI Command Format (32-bit):
//     [31:28] Module_ID
//     [27:24] Board_ID  
//     [23:20] Chip_ID / Direction Index
//     [19:16] CMD_ADDR
//     [15:0]  Data
//
// New Commands:
//     CMD_BEAM_SCAN_CONFIG  (0xB): Configure scan parameters
//         Data[15:8] = num_directions
//         Data[7:4]  = scan_mode (0=TX, 1=RX, 2=TXRX)
//     CMD_BEAM_SCAN_ADD_DIR (0xC): Add scan direction
//         Chip_ID[5:0] = direction_index
//         Data[15:8] = azimuth
//         Data[7:0]  = pitch
//     CMD_BEAM_SCAN_ARM     (0xD): Arm beam scan
//         Data[15:0] = timeout_us
//     CMD_BEAM_SCAN_DISARM  (0xE): Disarm beam scan
//
// SPI Process Module with Parallel SPI Support
// - Supports simultaneous 8-chip SPI writes for beam scanning
//
// added 2025-12-11 16:40:38
//
// SPI Process Module v4 - Optimized with Shared Phase Calculator
//
// Key optimization:
// - Single phase_shift_calculator instance shared between manual beamforming
//   and beam scan controller
// - Multiplexer selects inputs based on which operation needs calculation
// - Reduces LUT usage significantly (removes one 8KB lookup table)
//
// Changes from v3:
// - Removed phase calculator from beam_scan_controller
// - Added arbitration logic for shared calculator access
// - beam_scan_controller_v2 uses external calculator interface
//
//////////////////////////////////////////////////////////////////////////////////

module spi_process_v4 #(
    parameter spi_listener_data_len = 32,
    parameter spi_master_data_len = 24
)(
    input               clk_100M,
    input               rst_n,
    input               i_DEV_MODE,
    input               i_UPDATE,
    input               i_spi_listener_interrupt,
    input  [spi_listener_data_len-1:0] i_spi_data,

    // Parallel SPI outputs
    output wire [7:0]   o_PS_CS,
    output wire [7:0]   o_PS_MOSI,
    output wire [1:0]   o_PS_SCLK,

    // Control signals
    output reg          o_RsetB,
    output reg [1:0]    o_LP_Pulse,
    output reg [7:0]    o_TX_ON,
    output reg [7:0]    o_RX_ON,
    output reg          o_IF_TX_ON,
    output reg          o_IF_RX_ON,
    output reg          o_LNA_BYPASS,
    output reg [1:0]    o_IFDSA_LE,
    output reg [11:0]   o_IFDSA_DIN,
  
    // Beam scan status
    output wire [5:0]   o_scan_dir_index,
    output wire [2:0]   o_scan_state,
    output wire         o_scan_armed,
    output wire         o_scan_active,
    output wire         o_scan_done,
    output wire         o_scan_timeout
);

<<<<<<< Updated upstream
    localparam LP_PULSE_CYCLES = 1;
    localparam LP_LEAD_CYCLES = 2;
    localparam LP_LAG_CYCLES = 2;
=======
    localparam LP_PULSE_CYCLES = 2;
    localparam LP_LEAD_CYCLES = 3;
    localparam LP_LAG_CYCLES = 3;
>>>>>>> Stashed changes

    //==========================================================================
    // Command Constants
    //==========================================================================
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
    localparam CMD_BEAM_SCAN_CONFIG   = 4'hB;
    localparam CMD_BEAM_SCAN_ADD_DIR  = 4'hC;
    localparam CMD_BEAM_SCAN_ARM      = 4'hD;
    localparam CMD_BEAM_SCAN_DISARM   = 4'hE;

    localparam BOARD_ID_ALL = 4'h8;
    localparam BOARD_ID_MODULE_ONLY = 4'h9;

    //==========================================================================
    // Board ID
    //==========================================================================
    reg [3:0] Module_ID;
    reg [3:0] Board_ID;
    wire [7:0] General_BID;
    assign General_BID = {Module_ID, Board_ID};

    // PE44951寄存器。映射关系如下：
    // 0    TX PS0 Ch0 (BF1, AC1, DSA1)
    // 1    TX PS0 Ch1 (BF2, AC2, DSA2)
    // 2    TX PS1 Ch0 (BF1, AC1, DSA1)
    // 3    TX PS1 Ch1 (BF2, AC2, DSA2)
    // ...
    // 6    TX PS3 Ch0 (BF1, AC1, DSA1)
    // 7    TX PS3 Ch1 (BF2, AC2, DSA2)
    // 8    RX PS0 Ch0 (BF1, AC1, DSA1)
    // 9    RX PS0 Ch1 (BF2, AC2, DSA2)
    // ...
    // 14   RX PS3 Ch0 (BF1, AC1, DSA1)
    // 15   RX PS3 Ch1 (BF2, AC2, DSA2)
    reg [7:0] BF_phase_reg [15:0];      // 移相寄存器 used for calibration init
    reg [7:0] AC_phase_reg [15:0];      // 移相寄存器 used for manual beamforming
    reg [7:0] atten_reg_init [15:0];      // 衰减寄存器初始值
    reg [7:0] atten_reg [15:0];      // 衰减寄存器

    //==========================================================================
    // SPI Data Extraction
    //==========================================================================
    wire [3:0] host_module_id;
    wire [3:0] host_board_id;
    wire [3:0] host_chip_id;
    wire [3:0] cmd_addr;
    wire [15:0] host_data;
    wire Channel_ID = host_data[8];
    wire pha_reg_sel = host_data[9];
    wire board_id_match;
  
    assign host_module_id = i_spi_data[31:28];
    assign host_board_id = i_spi_data[27:24];
    assign host_chip_id = i_spi_data[23:20];
    assign cmd_addr = i_spi_data[19:16];
    assign host_data = i_spi_data[15:0];
  
    assign board_id_match = (({host_module_id, host_board_id} == General_BID) || 
                             (host_board_id == BOARD_ID_ALL) || 
                             (host_module_id == Module_ID && host_board_id == BOARD_ID_MODULE_ONLY));

    //==========================================================================
    // Shared Phase Shift Calculator
    //==========================================================================
    // Calculator input selection signals
    reg signed [7:0] calc_mux_azimuth;
    reg signed [7:0] calc_mux_pitch;
  
    // Manual beamforming angle inputs
    reg signed [7:0] ang_pitch;
    reg signed [7:0] ang_azimuth;
  
    // Beam scan calculator interface
    wire beam_calc_request;
    wire signed [7:0] beam_calc_azimuth;
    wire signed [7:0] beam_calc_pitch;
  
    // Calculator outputs (shared)
    wire [7:0] PSB0, PSB1, PSB2, PSB3, PSB4, PSB5, PSB6, PSB7;
  
    // Calculator input multiplexer
    // Priority: beam_calc_request has priority during beam scan configuration
    always @(*) begin
        if (beam_calc_request) begin
            calc_mux_azimuth = beam_calc_azimuth;
            calc_mux_pitch = beam_calc_pitch;
        end else begin
            calc_mux_azimuth = ang_azimuth;
            calc_mux_pitch = ang_pitch;
        end
    end
  
    // Single shared phase calculator instance
    phase_shift_calculator phase_calc_shared (
        .ang_pitch(calc_mux_pitch),
        .ang_azimuth(calc_mux_azimuth),
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

    //==========================================================================
    // Beam Scan Controller (v2 - uses external calculator)
    //==========================================================================
    reg beam_cfg_valid;
    reg [3:0] beam_cfg_cmd;
    reg [3:0] beam_cfg_dir_index;
    reg [7:0] beam_cfg_num_dirs;
    reg [1:0] beam_cfg_scan_mode;
    reg signed [7:0] beam_cfg_azimuth;
    reg signed [7:0] beam_cfg_pitch;
    reg [15:0] beam_cfg_timeout_us;
    reg beam_scan_init_rst_n = 1;
    reg local_spi_busy;

    wire beam_spi_start;
    wire [spi_master_data_len-1:0] beam_spi_data_0;
    wire [spi_master_data_len-1:0] beam_spi_data_1;
    wire [spi_master_data_len-1:0] beam_spi_data_2;
    wire [spi_master_data_len-1:0] beam_spi_data_3;
    wire [spi_master_data_len-1:0] beam_spi_data_4;
    wire [spi_master_data_len-1:0] beam_spi_data_5;
    wire [spi_master_data_len-1:0] beam_spi_data_6;
    wire [spi_master_data_len-1:0] beam_spi_data_7;
    wire [7:0] beam_spi_chip_en;
    wire [1:0] beam_lp_pulse;
    wire beam_scan_active_internal;
    wire beam_scan_rst_n;

    assign beam_scan_rst_n = rst_n && beam_scan_init_rst_n;

<<<<<<< Updated upstream
    beam_scan_controller_v2 #(
=======
    beam_scan_controller_v3 #(
>>>>>>> Stashed changes
        .CLK_FREQ(100_000_000),
        .MAX_SCAN_DIRECTIONS(16),
        .SPI_DATA_LEN(spi_master_data_len)
    ) beam_scan_inst (
        .i_clk(clk_100M),
        .i_rst_n(beam_scan_rst_n),
        .i_cfg_valid(beam_cfg_valid),
        .i_cfg_cmd(beam_cfg_cmd),
        .i_cfg_dir_index(beam_cfg_dir_index),
        .i_cfg_num_dirs(beam_cfg_num_dirs),
        .i_cfg_scan_mode(beam_cfg_scan_mode),
        .i_cfg_azimuth(beam_cfg_azimuth),
        .i_cfg_pitch(beam_cfg_pitch),
        .i_cfg_timeout_us(beam_cfg_timeout_us),
        .i_lp_trigger(i_UPDATE),
      
        // External calculator interface
        .o_calc_request(beam_calc_request),
        .o_calc_azimuth(beam_calc_azimuth),
        .o_calc_pitch(beam_calc_pitch),
        .i_calc_PSB0(PSB0),
        .i_calc_PSB1(PSB1),
        .i_calc_PSB2(PSB2),
        .i_calc_PSB3(PSB3),
        .i_calc_PSB4(PSB4),
        .i_calc_PSB5(PSB5),
        .i_calc_PSB6(PSB6),
        .i_calc_PSB7(PSB7),
      
        // SPI interface
        .o_spi_start(beam_spi_start),
        .o_spi_data_0(beam_spi_data_0),
        .o_spi_data_1(beam_spi_data_1),
        .o_spi_data_2(beam_spi_data_2),
        .o_spi_data_3(beam_spi_data_3),
        .o_spi_data_4(beam_spi_data_4),
        .o_spi_data_5(beam_spi_data_5),
        .o_spi_data_6(beam_spi_data_6),
        .o_spi_data_7(beam_spi_data_7),
        .o_spi_chip_en(beam_spi_chip_en),
        .i_spi_ready(!local_spi_busy),
        .o_lp_pulse(beam_lp_pulse),
        .o_current_dir_index(o_scan_dir_index),
        .o_scan_state(o_scan_state),
        .o_scan_armed(o_scan_armed),
        .o_scan_active(beam_scan_active_internal),
        .o_scan_done(o_scan_done),
        .o_scan_timeout(o_scan_timeout)
    );
  
    assign o_scan_active = beam_scan_active_internal;

    //==========================================================================
    // Local SPI Signals for Manual Operations
    //==========================================================================
    reg local_spi_start;
    reg [spi_master_data_len-1:0] local_spi_data [7:0];
    reg [7:0] local_spi_chip_en;

    //==========================================================================
    // SPI Arbitration and Parallel SPI Master
    //==========================================================================
    wire [spi_master_data_len-1:0] mux_spi_data_0;
    wire [spi_master_data_len-1:0] mux_spi_data_1;
    wire [spi_master_data_len-1:0] mux_spi_data_2;
    wire [spi_master_data_len-1:0] mux_spi_data_3;
    wire [spi_master_data_len-1:0] mux_spi_data_4;
    wire [spi_master_data_len-1:0] mux_spi_data_5;
    wire [spi_master_data_len-1:0] mux_spi_data_6;
    wire [spi_master_data_len-1:0] mux_spi_data_7;
    wire [7:0] mux_spi_chip_en;
    wire mux_spi_start;
    wire PE44951_ready;

    // Beam scan has priority when active
    assign mux_spi_start = beam_scan_active_internal ? beam_spi_start : local_spi_start;
    assign mux_spi_chip_en = beam_scan_active_internal ? beam_spi_chip_en : local_spi_chip_en;
  
    assign mux_spi_data_0 = beam_scan_active_internal ? beam_spi_data_0 : local_spi_data[0];
    assign mux_spi_data_1 = beam_scan_active_internal ? beam_spi_data_1 : local_spi_data[1];
    assign mux_spi_data_2 = beam_scan_active_internal ? beam_spi_data_2 : local_spi_data[2];
    assign mux_spi_data_3 = beam_scan_active_internal ? beam_spi_data_3 : local_spi_data[3];
    assign mux_spi_data_4 = beam_scan_active_internal ? beam_spi_data_4 : local_spi_data[4];
    assign mux_spi_data_5 = beam_scan_active_internal ? beam_spi_data_5 : local_spi_data[5];
    assign mux_spi_data_6 = beam_scan_active_internal ? beam_spi_data_6 : local_spi_data[6];
    assign mux_spi_data_7 = beam_scan_active_internal ? beam_spi_data_7 : local_spi_data[7];

    // Parallel SPI Master
    SPI_Master_PE44951_Parallel #(
<<<<<<< Updated upstream
        .clk_div(2),
=======
        .clk_div(1),
>>>>>>> Stashed changes
        .spi_data_len(spi_master_data_len)
    ) spi_master_inst (
        .i_clk(clk_100M),
        .i_rst_n(rst_n),
        .i_spi_data_0(mux_spi_data_0),
        .i_spi_data_1(mux_spi_data_1),
        .i_spi_data_2(mux_spi_data_2),
        .i_spi_data_3(mux_spi_data_3),
        .i_spi_data_4(mux_spi_data_4),
        .i_spi_data_5(mux_spi_data_5),
        .i_spi_data_6(mux_spi_data_6),
        .i_spi_data_7(mux_spi_data_7),
        .i_spi_start(mux_spi_start),
        .i_chip_en(mux_spi_chip_en),
        .o_cs(o_PS_CS),
        .o_mosi(o_PS_MOSI),
        .o_sclk(o_PS_SCLK),
        .o_spi_ready(PE44951_ready)
    );

    //==========================================================================
    // LP Pulse Arbitration - Combinational for beam scan, registered for manual
    //==========================================================================
    // wire beam_lp_enable;  // Wire from beam_scan_controller (add to port connection)
    reg [1:0] local_lp_pulse;

    always @(*) begin
        if (beam_scan_active_internal) begin
            // During beam scan: LP directly follows i_UPDATE for immediate response
            // beam_lp_pulse is already combinationally generated in beam_scan_controller
            o_LP_Pulse = beam_lp_pulse;
        end else begin
            o_LP_Pulse = local_lp_pulse;
        end
    end

    //==========================================================================
    // IF DSA
    //==========================================================================
    // 保存IFDSA的衰减码字
    reg [5:0] IFDSA_atten_reg [1:0];
    reg [1:0] IFDSA_ID;
    reg load_IFDSA;
    reg IFDSA_LE_psflag;

    //==========================================================================
    // State Machines
    //==========================================================================
    // Manual Beamforming state machine
    reg [2:0] beamform_state;
    reg [7:0] beamform_cnt; // for LP timing adjustment
    localparam  S_MBF_IDLE = 0,
                S_MBF_CAL = 1,
                S_MBF_LOAD = 2,
                S_MBF_WAIT_SPI = 3,
                S_MBF_LP_LEAD = 4,
                S_MBF_LP = 5;
  
    // Initialization state machine
    reg [2:0] init_state;
    reg [7:0] init_cnt;
    localparam S_INIT_IDLE = 3'd0,
               S_INIT_BF   = 3'd1,
               S_INIT_AC   = 3'd2,
               S_INIT_ATT  = 3'd3,
               S_INIT_LP   = 3'd4,
               S_INIT_WAIT = 3'd5;

    // LP pulse state machine
    reg lp_state;
    reg [3:0] lp_cnt;
    localparam S_LP_LOW  = 1'b0,
               S_LP_HIGH = 1'b1;

    // Reset counter
<<<<<<< Updated upstream
    reg [4:0] rst_cnt;
=======
    reg [3:0] rst_cnt;
>>>>>>> Stashed changes

    integer i;

    //==========================================================================
    // Command Processing
    //==========================================================================
    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n) begin
            Module_ID <= 4'd0;
            Board_ID <= BOARD_ID_ALL;
            beam_cfg_valid <= 1'b0;
            beam_cfg_cmd <= 4'd0;
            beam_cfg_dir_index <= 0;
            beam_cfg_num_dirs <= 8'd0;
            beam_cfg_scan_mode <= 2'd0;
            beam_cfg_azimuth <= 8'd0;
            beam_cfg_pitch <= 8'd0;
            beam_cfg_timeout_us <= 16'd0;
            beam_scan_init_rst_n <= 1;
            ang_pitch <= 8'd0;
            ang_azimuth <= 8'd0;
            o_TX_ON <= 8'h00;
            o_RX_ON <= 8'h00;
            o_LNA_BYPASS <= 1'b0;
            init_state <= S_INIT_IDLE;
            init_cnt <= 8'd0;
            local_spi_start <= 1'b0;
            local_spi_chip_en <= 8'd0;
            local_spi_busy <= 1'b0;
            local_lp_pulse <= 2'b00;
            lp_state <= S_LP_LOW;
            lp_cnt <= 4'd0;
            o_RsetB <= 1'b0;
<<<<<<< Updated upstream
            rst_cnt <= 5'd0;
=======
            rst_cnt <= 0;
>>>>>>> Stashed changes
            o_IFDSA_LE <= 2'b00;
            o_IFDSA_DIN <= 12'd0;
            beamform_state <= S_MBF_IDLE;
            beamform_cnt <= 0;
            load_IFDSA <= 0;
            IFDSA_ID <= 0;
            for (i = 0; i < 16; i = i + 1) begin
                BF_phase_reg[i] <= 8'd0;
                AC_phase_reg[i] <= 8'd0;
                atten_reg_init[i] <= 8'd0;
                atten_reg[i] <= 8'd0;
            end
            for (i = 0; i < 8; i = i + 1) begin
                local_spi_data[i] <= 24'd0;
            end
            for (i = 0; i < 2; i = i + 1) begin
                IFDSA_atten_reg[i] <= 6'd0;
            end
        end else begin
            // Process manual commands from host
            if (i_spi_listener_interrupt && board_id_match) begin
                case (cmd_addr)
                    // #0
                    // Manual Beamforming Control - write calculated PSBs to AC regs of PE44951
                    CMD_PHASE_ARRAY_CAL: begin
                        ang_pitch <= host_data[7:0];
                        ang_azimuth <= host_data[15:8];
                        beamform_state <= S_MBF_CAL;
                    end

                    // #1
                    // Write Calibration Values to All PE44951
                    CMD_INIT: begin
                        beam_scan_init_rst_n <= 0;
                            // 初始化所有通道的相位和幅度
                        if (init_state == S_INIT_IDLE)
                            init_state <= S_INIT_BF;
                    end
                    
                    // #2
                    // Arbitrary PE44951 Phase Control
                    CMD_WRITE_PHASE: begin
                        // 向指定的芯片和通道写入相位信息
                        if (init_state == S_INIT_IDLE && !local_spi_busy && PE44951_ready) begin
                            case (host_chip_id)
                                4'd0, 4'd1, 4'd2, 4'd3: begin
                                    local_spi_data[host_chip_id[2:0]] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, Channel_ID}, 8'h00, host_data[7:0]}; // 1chip TX 1channel AC or BF reg
                                    local_spi_chip_en <= (8'b1 << host_chip_id[2:0]);
                                    local_spi_start <= 1'b1;
                                end
                                4'd4, 4'd5, 4'd6, 4'd7: begin
                                    local_spi_data[host_chip_id[2:0]] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, ~Channel_ID}, 8'h00, host_data[7:0]}; // 1chip RX 1channel AC or BF reg
                                    local_spi_chip_en <= (8'b1 << host_chip_id[2:0]);
                                    local_spi_start <= 1'b1;
                                end
                                4'd8: begin
                                    for (i = 0; i < 4; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips TX 1channel AC or BF regs
                                    end
                                    for (i = 4; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, ~Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips RX 1channel AC or BF regs
                                    end
                                    local_spi_chip_en <= 8'hFF;
                                    local_spi_start <= 1'b1;
                                end
                                4'd9: begin
                                    for (i = 0; i < 4; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips TX 1channel AC or BF regs
                                    end
                                    local_spi_chip_en <= 8'h0F;
                                    local_spi_start <= 1'b1;
                                end
                                4'd10: begin
                                    for (i = 4; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {1'b0, pha_reg_sel, ~Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips RX 1channel AC or BF regs
                                    end
                                    local_spi_chip_en <= 8'hF0;
                                    local_spi_start <= 1'b1;
                                end
                                default: begin
                                    // 无效的chip_ID
                                    for (i = 0; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, 3'b111, 8'hFF, 8'hFF}; // dummy write
                                    end
                                    local_spi_chip_en <= 0;
                                    local_spi_start <= 0;
                                end
                            endcase
                        end
                    end
                    
                    // #3
                    // Arbitrary PE44951 Attenuation Control
                    CMD_WRITE_ATTEN: begin
                        // 向指定的芯片和通道写入衰减信息
                        if (init_state == S_INIT_IDLE && !local_spi_busy && PE44951_ready) begin
                            case (host_chip_id)
                                4'd0, 4'd1, 4'd2, 4'd3: begin
                                    local_spi_data[host_chip_id[2:0]] <= {2'b00, 3'b111, {2'b10, Channel_ID}, 8'h00, host_data[7:0]}; // 1chip TX 1channelDSA  reg
                                    local_spi_chip_en <= (8'b1 << host_chip_id[2:0]);
                                    local_spi_start <= 1'b1;
                                end
                                4'd4, 4'd5, 4'd6, 4'd7: begin
                                    local_spi_data[host_chip_id[2:0]] <= {2'b00, 3'b111, {2'b10, ~Channel_ID}, 8'h00, host_data[7:0]}; // 1chip RX 1channelDSA  reg
                                    local_spi_chip_en <= (8'b1 << host_chip_id[2:0]);
                                    local_spi_start <= 1'b1;
                                end
                                4'd8: begin
                                    for (i = 0; i < 4; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {2'b10, Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips TX 1channel DSA regs
                                    end
                                    for (i = 4; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {2'b10, ~Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips RX 1channel DSA regs
                                    end
                                    local_spi_chip_en <= 8'hFF;
                                    local_spi_start <= 1'b1;
                                end
                                4'd9: begin
                                    for (i = 0; i < 4; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {2'b10, Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips TX 1channel DSA regs
                                    end
                                    local_spi_chip_en <= 8'h0F;
                                    local_spi_start <= 1'b1;
                                end
                                4'd10: begin
                                    for (i = 4; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, {2'b10, ~Channel_ID}, 8'h00, host_data[7:0]}; // 4 chips RX 1channel DSA regs
                                    end
                                    local_spi_chip_en <= 8'hF0;
                                    local_spi_start <= 1'b1;
                                end
                                default: begin
                                    // 无效的chip_ID
                                    for (i = 0; i < 8; i = i + 1) begin
                                        local_spi_data[i] <= {2'b00, 3'b111, 3'b111, 8'hFF, 8'hFF}; // dummy write
                                    end
                                    local_spi_chip_en <= 0;
                                    local_spi_start <= 0;
                                end
                            endcase
                        end
                    end
                    
                    // #4
                    // Arbitrary FEM Control
                    CMD_SWITCH_TXRX: begin
                        // 通过SPI指令切换指定通道的TX或RX状态，只允许在DEV_MODE下执行该操作
                        if (i_DEV_MODE == 1) begin
                            case (host_chip_id)
                                4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7: begin
                                    o_TX_ON[host_chip_id[2:0]] <= host_data[9];
                                    o_RX_ON[host_chip_id[2:0]] <= host_data[8];
                                end
                                4'd8: begin
                                    o_TX_ON[7:0] <= {8{host_data[9]}};
                                    o_RX_ON[7:0] <= {8{host_data[8]}};
                                end
                                default: begin
                                    o_TX_ON <= 0;
                                    o_RX_ON <= 0;
                                end
                            endcase
                        end
                    end

                    // #5
                    // Trigger Soft Phase Latch
                    CMD_UPDATE_PHASE: begin
                        // Trigger LP pulse if not busy with other operations
                        if (!local_spi_busy && !beam_scan_active_internal && 
                            init_state == S_INIT_IDLE && beamform_state == S_MBF_IDLE) begin
                            lp_state <= S_LP_HIGH;
                            lp_cnt <= 4'd0;
                            local_lp_pulse <= 2'b11;
                        end
                    end

                    // #6
                    // Soft Power Down All Channels
                    CMD_POWER_DOWN: begin
                        beam_scan_init_rst_n <= 0;
                        // 关闭所有通道
                        o_TX_ON <= 0;
                        o_RX_ON <= 0;
                    end

                    // #7
                    // Modify Local ID
                    CMD_RECV_BOARD_ID: begin
                        Module_ID <= host_data[7:4];
                        Board_ID <= host_data[3:0];
                    end
                
                    // #8
                    // Store phase calibration values
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
                                BF_phase_reg[{host_chip_id[2:0], Channel_ID}] <= host_data[7:0];
                            end
                        endcase
                    end

                    // #9
                    // Store attenuation calibration values
                    CMD_RECV_ATTEN_INIT: begin
                        // 修改初始化幅度衰减值
                        case (host_chip_id)
                            4'd8: begin
                                // 给所有16个寄存器赋值
                                for (i = 0; i < 16; i = i + 1) begin
                                    atten_reg_init[i] <= host_data[7:0];
                                end
                            end
                            4'd9: begin
                                // 给TX(前8个寄存器)赋值
                                for (i = 0; i < 8; i = i + 1) begin
                                    atten_reg_init[i] <= host_data[7:0];
                                end
                            end
                            4'd10: begin
                                // 给RX(后8个寄存器)赋值
                                for (i = 8; i < 16; i = i + 1) begin
                                    atten_reg_init[i] <= host_data[7:0];
                                end
                            end
                            default: begin
                                atten_reg_init[{host_chip_id[2:0], Channel_ID}] <= host_data[7:0];
                            end
                        endcase
                    end

                    // #10
                    // IF DSA control
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
                                for (i = 0; i < 2; i = i + 1) begin
                                    IFDSA_atten_reg[i] <= 0;
                                end
                        endcase
                        load_IFDSA <= host_data[8];
                        IFDSA_ID <= host_chip_id[1:0];
                    end


                    // #11
                    // Beam scan commands
                    CMD_BEAM_SCAN_CONFIG: begin
                        beam_cfg_valid <= 1'b1;
                        beam_cfg_cmd <= CMD_BEAM_SCAN_CONFIG;
                        beam_cfg_num_dirs <= host_data[15:8];
                        beam_cfg_scan_mode <= host_data[5:4];
                    end
                    
                    CMD_BEAM_SCAN_ADD_DIR: begin
                        beam_cfg_valid <= 1'b1;
                        beam_cfg_cmd <= CMD_BEAM_SCAN_ADD_DIR;
                        beam_cfg_dir_index <= host_chip_id[3:0];
                        beam_cfg_azimuth <= host_data[15:8];
                        beam_cfg_pitch <= host_data[7:0];
                    end
                    
                    CMD_BEAM_SCAN_ARM: begin
                        beam_cfg_valid <= 1'b1;
                        beam_cfg_cmd <= CMD_BEAM_SCAN_ARM;
                        beam_cfg_timeout_us <= host_data;
                    end
                    
                    CMD_BEAM_SCAN_DISARM: begin
                        beam_cfg_valid <= 1'b0;
                        beam_cfg_cmd <= CMD_BEAM_SCAN_DISARM;
                    end
                endcase
            end


<<<<<<< Updated upstream
            // load IF DSA
=======
            //==================================================================
            // IF DSA Control
            //==================================================================
>>>>>>> Stashed changes
            if (load_IFDSA == 1) begin
                IFDSA_LE_psflag <= 1;
                case (IFDSA_ID)
                    2'b00: begin
                        o_IFDSA_DIN[5:0] <= IFDSA_atten_reg[0];
                        load_IFDSA <= 0;
                    end
                    2'b01: begin
                        o_IFDSA_DIN[11:6] <= IFDSA_atten_reg[1];
                        load_IFDSA <= 0;
                    end
                    2'b10: begin
                        for (i = 0; i < 2; i = i + 1) begin
                            o_IFDSA_DIN[i*6 +: 6] <= IFDSA_atten_reg[i];
                        end
                        load_IFDSA <= 0;
                    end
                    default: begin
                        for (i = 0; i < 2; i = i + 1) begin
                            o_IFDSA_DIN[i*6 +: 6] <= 0;
                        end
                        load_IFDSA <= 0;
                    end
                endcase
            end

            if (IFDSA_LE_psflag == 1'b1) begin
                IFDSA_LE_psflag <= 0;
                case (IFDSA_ID)
                    2'b00: begin
                        o_IFDSA_LE <= 2'b01;
                    end
                    2'b01: begin
                        o_IFDSA_LE <= 2'b10;
                    end
                    2'b10: begin
                        o_IFDSA_LE <= 2'b11;
                    end
                    default: begin
                        o_IFDSA_LE <= 0;
                    end
                endcase
            end

            // Auto-release IFDSA_LE
            if (|o_IFDSA_LE) begin
                o_IFDSA_LE <= 0;
            end

            // Clear local_spi_start after one cycle
            if (local_spi_start) begin
                local_spi_start <= 1'b0;
            end

<<<<<<< Updated upstream
=======
            // Auto-release RST of PE44951
            if (o_RsetB == 0)begin
                if (rst_cnt < 4'd10) begin
                    rst_cnt <= rst_cnt + 1;
                end
                else begin
                    o_RsetB <= 1;
                    rst_cnt <= 0;
                end
            end


>>>>>>> Stashed changes
            //==================================================================
            // Manual Beamforming State Machine
            //==================================================================
            case (beamform_state)
                S_MBF_IDLE: begin
                    // Idle - waiting for command
                end
              
                S_MBF_CAL: begin
                    // Store calculated phase values from shared phase_shift_calculator
                    // Note: Calculator uses ang_azimuth/ang_pitch when beam_calc_request is low
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
                    beamform_state <= S_MBF_LOAD;
                    beamform_cnt <= 0;
                end
              
                S_MBF_LOAD: begin
                    // Write all AC phase registers to all 8 chips via parallel SPI
                    if (PE44951_ready && !local_spi_busy && init_state == S_INIT_IDLE) begin
                        // TX chips (0-3): normal channel mapping
                        for (i = 0; i < 4; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b010, 3'b011, 
                                                  AC_phase_reg[2*i], AC_phase_reg[2*i+1]};
                        end
                        // RX chips (4-7): reversed channel mapping
                        for (i = 4; i < 8; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b011, 3'b010, 
                                                  AC_phase_reg[2*i], AC_phase_reg[2*i+1]};
                        end
                        local_spi_chip_en <= 8'hFF;
                        local_spi_start <= 1'b1;
                        local_spi_busy <= 1'b1;
                        beamform_state <= S_MBF_WAIT_SPI;
                    end
                end
                
                S_MBF_WAIT_SPI: begin
                    if (!local_spi_start && PE44951_ready) begin
                        // SPI complete, wait LP lead time before LP pulse
                        beamform_cnt <= 0;
                        beamform_state <= S_MBF_LP_LEAD;
                    end
                end
                
                S_MBF_LP_LEAD: begin
                    // Wait LP_LEAD_CYCLES (≥20ns) after SPI before LP rises
                    if (beamform_cnt >= LP_LEAD_CYCLES) begin
                        beamform_cnt <= 0;
                        beamform_state <= S_MBF_LP;
                        local_lp_pulse <= 2'b11;  // Both TX and RX LP high
                    end else begin
                        beamform_cnt <= beamform_cnt + 1;
                    end
                end
                
                S_MBF_LP: begin
                    // Generate LP pulse for LP_PULSE_CYCLES
                    if (beamform_cnt >= LP_PULSE_CYCLES) begin
                        local_lp_pulse <= 2'b00;  // LP low
                        local_spi_busy <= 1'b0;
                        beamform_state <= S_MBF_IDLE;
                    end else begin
                        beamform_cnt <= beamform_cnt + 1;
                    end
                end
            endcase

            //==================================================================
            // Initialization State Machine
            //==================================================================
            case (init_state)
                S_INIT_BF: begin
                    if (PE44951_ready && !local_spi_busy) begin
                        for (i = 0; i < 4; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b000, 3'b001, BF_phase_reg[2*i], BF_phase_reg[2*i+1]}; // load all TX BF regs
                        end
                        for (i = 4; i < 8; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b001, 3'b000, BF_phase_reg[2*i], BF_phase_reg[2*i+1]}; // load all RX BF regs
                        end
                        local_spi_chip_en <= 8'b11111111;
                        local_spi_start <= 1'b1;
                        local_spi_busy <= 1'b1;
                        init_state <= S_INIT_WAIT;
                    end
                    else begin
                        init_state <= S_INIT_BF;
                    end
                end

                S_INIT_WAIT: begin                    
                    case (init_cnt)
                        8'd2: begin
                            init_state <= S_INIT_AC;
                            init_cnt <= init_cnt + 1;
                        end
                        8'd4: begin
                            init_state <= S_INIT_ATT;
                            init_cnt <= init_cnt + 1;
                        end
                        8'd107: begin
                            init_state <= S_INIT_LP;
                            init_cnt <= 0;
                        end
                        default: begin
                            init_cnt <= init_cnt + 1;
                        end
                    endcase
                end
                
                S_INIT_AC: begin
                    if (PE44951_ready) begin
                        for (i = 0; i < 4; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b010, 3'b011, 8'h00, 8'h00}; // load all TX AC regs
                        end
                        for (i = 4; i < 8; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b011, 3'b010, 8'h00, 8'h00}; // load all RX AC regs
                        end
                        local_spi_chip_en <= 8'b11111111;
                        local_spi_start <= 1'b1;
                        init_state <= S_INIT_WAIT;
                    end
                    else begin
                        // waite for SPI ready
                        init_state <= S_INIT_AC;
                    end
                end
                
                S_INIT_ATT: begin
                    if (PE44951_ready) begin
                        for (i = 0; i < 4; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b010, 3'b011, atten_reg_init[2*i], atten_reg_init[2*i+1]}; // load all TX DSA regs
                        end
                        for (i = 4; i < 8; i = i + 1) begin
                            local_spi_data[i] <= {2'b00, 3'b011, 3'b010, atten_reg_init[2*i], atten_reg_init[2*i+1]}; // load all RX DSA regs
                        end
                        local_spi_chip_en <= 8'b11111111;
                        local_spi_start <= 1'b1;
                        init_state <= S_INIT_WAIT;
                    end
                    else begin
                        // waite for SPI ready
                        init_state <= S_INIT_ATT;
                    end
                end
                
                S_INIT_LP: begin
                    // Generate LP pulse after all registers written
                    // No need for lead time here since we're coming from SPI completion
                    case (init_cnt)
                        8'd0, 8'd1, 8'd2: begin
                            // Wait LP_LEAD_CYCLES for timing margin
                            init_cnt <= init_cnt + 1;
                        end
                        8'd3, 8'd4: begin
                            // LP pulse high for LP_PULSE_CYCLES
                            local_lp_pulse <= 2'b11;
                            init_cnt <= init_cnt + 1;
                        end
                        8'd5: begin
                            // LP pulse complete
                            local_lp_pulse <= 2'b00;
                            local_spi_busy <= 1'b0;
                            beam_scan_init_rst_n <= 1;  // Re-enable beam scan
                            init_cnt <= 0;
                            init_state <= S_INIT_IDLE;
                        end
                        default: init_cnt <= 0;
                    endcase
                end
            endcase
          
            //==================================================================
            // LP Pulse State Machine (software trigger)
            //==================================================================
            case (lp_state)
                S_LP_LOW: begin
                    // Idle
                end
                S_LP_HIGH: begin
                    if (lp_cnt >= LP_PULSE_CYCLES) begin
                        lp_state <= S_LP_LOW;
                        local_lp_pulse <= 2'b00;
                        lp_cnt <= 4'd0;
                    end else begin
                        lp_cnt <= lp_cnt + 1'b1;
                    end
                end
            endcase

            if (o_scan_done || o_scan_timeout) begin
                beam_cfg_valid <= 0;
            end
        end
    end

    // IF TX/RX control
    always @(*) begin
        o_IF_TX_ON = |o_TX_ON[7:0];
        o_IF_RX_ON = |o_RX_ON[7:0];
    end

endmodule