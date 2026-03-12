`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Beam Scan Controller with Parallel SPI Support
// Outputs all 8 phase codes simultaneously for minimal beam switch time
// TODO: This module needs to be modified for proper LP control
//      When LP pulse is triggered by physical signal from digital baseband,
//      SPI data of AC regs should be writen in advance so that enough 'LP lead SPI command'
//      in timing constraint can be meet for sure.
//
// added 2025-12-11 16:57:28
//
// Beam Scan Controller v2 - Optimized for Shared Phase Calculator
// 
// Changes from v1:
// - Removed internal phase_shift_calculator instance
// - Added external calculator interface (request/response signals)
// - Calculator is now shared with manual beamforming in parent module
//////////////////////////////////////////////////////////////////////////////////

module beam_scan_controller_v2 #(
    parameter CLK_FREQ = 100_000_000,
    parameter MAX_SCAN_DIRECTIONS = 16,
    parameter SPI_DATA_LEN = 24,
    parameter TIMEOUT_US_DEFAULT = 10000
)(
    input wire i_clk,
    input wire i_rst_n,
    
    // Configuration interface
    input wire i_cfg_valid,
    input wire [3:0] i_cfg_cmd,
    input wire [3:0] i_cfg_dir_index,
    input wire [7:0] i_cfg_num_dirs,
    input wire [1:0] i_cfg_scan_mode,
    input wire signed [7:0] i_cfg_azimuth,
    input wire signed [7:0] i_cfg_pitch,
    input wire [15:0] i_cfg_timeout_us,
    
    // External trigger
    input wire i_lp_trigger,
    
    // =========================================================================
    // External Phase Calculator Interface (NEW - replaces internal calculator)
    // =========================================================================
    output reg o_calc_request,                    // Request calculation
    output reg signed [7:0] o_calc_azimuth,       // Azimuth angle for calculation
    output reg signed [7:0] o_calc_pitch,         // Pitch angle for calculation
    input wire [7:0] i_calc_PSB0,                 // Calculated phase shifts
    input wire [7:0] i_calc_PSB1,
    input wire [7:0] i_calc_PSB2,
    input wire [7:0] i_calc_PSB3,
    input wire [7:0] i_calc_PSB4,
    input wire [7:0] i_calc_PSB5,
    input wire [7:0] i_calc_PSB6,
    input wire [7:0] i_calc_PSB7,
    
    // Parallel SPI interface - 8 independent 24-bit data outputs
    output reg o_spi_start,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_0,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_1,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_2,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_3,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_4,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_5,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_6,
    output reg [SPI_DATA_LEN-1:0] o_spi_data_7,
    output reg [7:0] o_spi_chip_en,
    input wire i_spi_ready,
    
    // LP control
    output reg [1:0] o_lp_pulse,
    
    // Status outputs
    output reg [5:0] o_current_dir_index,
    output reg [2:0] o_scan_state,
    output reg o_scan_armed,
    output reg o_scan_active,
    output reg o_scan_done,
    output reg o_scan_timeout
);

    // Command codes
    localparam CMD_SCAN_CONFIG   = 4'hB;
    localparam CMD_SCAN_ADD_DIR  = 4'hC;
    localparam CMD_SCAN_ARM      = 4'hD;
    localparam CMD_SCAN_DISARM   = 4'hE;
    
    // Scan modes
    localparam SCAN_MODE_TX      = 2'd0;
    localparam SCAN_MODE_RX      = 2'd1;
    localparam SCAN_MODE_TXRX    = 2'd2;
    
    // machine parameters
    localparam S_IDLE            = 3'd0;
    localparam S_PRELOAD_FIRST   = 3'd1;  // Preload first direction's SPI
    localparam S_WAIT_FIRST_SPI  = 3'd2;  // Wait for first SPI complete
    localparam S_ARMED           = 3'd3;  // Armed, LP enabled, wait for trigger
    localparam S_LP_LAG_WAIT     = 3'd4;  // Wait 20ns after LP falls before SPI
    localparam S_LOAD_NEXT       = 3'd5;  // Load next direction's SPI
    localparam S_WAIT_SPI        = 3'd6;  // Wait for SPI complete
    localparam S_DONE            = 3'd7;
    
    // LP timing parameters
    localparam LP_LAG_CYCLES     = 3;     // 30ns > 20ns requirement
    
    // LP enable register
    reg lp_enable;
    
    // Pre-computed phase shift code storage
    reg [7:0] precomputed_phase_0 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant0
    reg [7:0] precomputed_phase_1 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant1
    reg [7:0] precomputed_phase_2 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant2
    reg [7:0] precomputed_phase_3 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant3
    reg [7:0] precomputed_phase_4 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant4
    reg [7:0] precomputed_phase_5 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant5
    reg [7:0] precomputed_phase_6 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant6
    reg [7:0] precomputed_phase_7 [0:MAX_SCAN_DIRECTIONS-1]; // analog beamforming PSBs for ant7
    
    // Configuration registers
    reg [7:0] num_directions;
    reg [1:0] scan_mode;
    reg [31:0] timeout_cycles;
    
    // State machine registers
    reg [2:0] state;
    reg [5:0] dir_index;
    reg [4:0] timing_cnt; // for LP lag control 
    reg [31:0] timeout_cnt;
    
    // Edge detection for i_lp_trigger
    reg update_pha_d1, update_pha_d2;
    wire update_pha_posedge;
    
    // Pipeline registers for configuration commands
    reg cfg_valid_d1, cfg_valid_d2;
    reg [3:0] cfg_cmd_d1, cfg_cmd_d2;
    reg [3:0] cfg_dir_index_d1, cfg_dir_index_d2;
    
    // Edge detection
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            update_pha_d1 <= 1'b0;
            update_pha_d2 <= 1'b0;
        end else begin
            update_pha_d1 <= i_lp_trigger;
            update_pha_d2 <= update_pha_d1;
        end
    end
    assign update_pha_posedge = update_pha_d1 & ~update_pha_d2;
    
    // Status output assignments
    always @(*) begin
        o_current_dir_index = dir_index;
        o_scan_state = state;
    end
    
    // Configuration handling - request external calculation
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            num_directions <= 8'd0;
            scan_mode <= SCAN_MODE_TXRX;
            timeout_cycles <= TIMEOUT_US_DEFAULT * (CLK_FREQ / 1_000_000);
            o_calc_request <= 1'b0;
            o_calc_azimuth <= 8'd0;
            o_calc_pitch <= 8'd0;
        end else begin
            o_calc_request <= 1'b0;  // Default: no request
            
            if (i_cfg_valid && state == S_IDLE) begin
                case (i_cfg_cmd)
                    CMD_SCAN_CONFIG: begin
                        num_directions <= i_cfg_num_dirs;
                        scan_mode <= i_cfg_scan_mode;
                    end
                    
                    CMD_SCAN_ADD_DIR: begin
                        // Request external calculation
                        o_calc_request <= 1'b1;
                        o_calc_azimuth <= i_cfg_azimuth;
                        o_calc_pitch <= i_cfg_pitch;
                    end
                    
                    CMD_SCAN_ARM: begin
                        if (i_cfg_timeout_us > 0)
                            timeout_cycles <= i_cfg_timeout_us * (CLK_FREQ / 1_000_000);
                    end
                endcase
            end
        end
    end
    
    // Pipeline for storing calculated phases
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            cfg_valid_d1 <= 1'b0;
            cfg_valid_d2 <= 1'b0;
            cfg_cmd_d1 <= 4'd0;
            cfg_cmd_d2 <= 4'd0;
            cfg_dir_index_d1 <= 4'd0;
            cfg_dir_index_d2 <= 4'd0;
        end else begin
            cfg_valid_d1 <= i_cfg_valid;
            cfg_valid_d2 <= cfg_valid_d1;
            cfg_cmd_d1 <= i_cfg_cmd;
            cfg_cmd_d2 <= cfg_cmd_d1;
            cfg_dir_index_d1 <= i_cfg_dir_index;
            cfg_dir_index_d2 <= cfg_dir_index_d1;
        end
    end
    
    // Store computed phases TWO cycles after ADD_DIR command
    // (one cycle for request, one cycle for calculator to produce output)
    always @(posedge i_clk) begin
        if (cfg_valid_d2 && cfg_cmd_d2 == CMD_SCAN_ADD_DIR && state == S_IDLE) begin
            precomputed_phase_0[cfg_dir_index_d1] <= i_calc_PSB0;
            precomputed_phase_1[cfg_dir_index_d1] <= i_calc_PSB1;
            precomputed_phase_2[cfg_dir_index_d1] <= i_calc_PSB2;
            precomputed_phase_3[cfg_dir_index_d1] <= i_calc_PSB3;
            precomputed_phase_4[cfg_dir_index_d1] <= i_calc_PSB4;
            precomputed_phase_5[cfg_dir_index_d1] <= i_calc_PSB5;
            precomputed_phase_6[cfg_dir_index_d1] <= i_calc_PSB6;
            precomputed_phase_7[cfg_dir_index_d1] <= i_calc_PSB7;
        end
    end

    // LP pulse generation - combinational for immediate response
    always @(*) begin
        if (o_scan_active && lp_enable) begin
            case (scan_mode)
                SCAN_MODE_TX:   o_lp_pulse = {1'b0, i_lp_trigger};
                SCAN_MODE_RX:   o_lp_pulse = {i_lp_trigger, 1'b0};
                SCAN_MODE_TXRX: o_lp_pulse = {i_lp_trigger, i_lp_trigger};
                default:        o_lp_pulse = 2'b00;
            endcase
        end else begin
            o_lp_pulse = 2'b00;
        end
    end

    // Main state machine
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            state <= S_IDLE;
            dir_index <= 6'd0;
            timing_cnt <= 5'd0;
            timeout_cnt <= 32'd0;
            o_scan_armed <= 1'b0;
            o_scan_active <= 1'b0;
            o_scan_done <= 1'b0;
            o_scan_timeout <= 1'b0;
            o_spi_start <= 1'b0;
            o_spi_data_0 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_1 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_2 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_3 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_4 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_5 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_6 <= {SPI_DATA_LEN{1'b0}};
            o_spi_data_7 <= {SPI_DATA_LEN{1'b0}};
            o_spi_chip_en <= 8'd0;
            lp_enable <= 1'b0;
        end else begin
            o_spi_start <= 1'b0;
            
            case (state)
                S_IDLE: begin
                    o_scan_armed <= 1'b0;
                    o_scan_active <= 1'b0;
                    o_scan_done <= 1'b0;
                    lp_enable <= 1'b0;
                    
                    if (i_cfg_valid && i_cfg_cmd == CMD_SCAN_ARM && num_directions > 0 && timeout_cnt < timeout_cycles) begin
                        state <= S_PRELOAD_FIRST;
                        o_scan_timeout <= 1'b0;
                        o_scan_armed <= 1'b1;
                        dir_index <= 6'd0;
                        timeout_cnt <= 32'd0;
                    end
                end
                
                S_PRELOAD_FIRST: begin
                    // Load first direction's SPI data before waiting for trigger
                    o_scan_active <= 1'b1;
                    
                    // Prepare SPI data for direction 0
                    o_spi_data_0 <= {2'b00, 3'b010, 3'b011, precomputed_phase_0[0], precomputed_phase_1[0]}; 
                    o_spi_data_1 <= {2'b00, 3'b010, 3'b011, precomputed_phase_2[0], precomputed_phase_3[0]};
                    o_spi_data_2 <= {2'b00, 3'b010, 3'b011, precomputed_phase_4[0], precomputed_phase_5[0]};
                    o_spi_data_3 <= {2'b00, 3'b010, 3'b011, precomputed_phase_6[0], precomputed_phase_7[0]};
                    o_spi_data_4 <= {2'b00, 3'b010, 3'b011, precomputed_phase_1[0], precomputed_phase_0[0]};
                    o_spi_data_5 <= {2'b00, 3'b010, 3'b011, precomputed_phase_3[0], precomputed_phase_2[0]};
                    o_spi_data_6 <= {2'b00, 3'b010, 3'b011, precomputed_phase_5[0], precomputed_phase_4[0]};
                    o_spi_data_7 <= {2'b00, 3'b010, 3'b011, precomputed_phase_7[0], precomputed_phase_6[0]};

                    case (scan_mode)
                        SCAN_MODE_TX:   o_spi_chip_en <= 8'b00001111;
                        SCAN_MODE_RX:   o_spi_chip_en <= 8'b11110000;
                        SCAN_MODE_TXRX: o_spi_chip_en <= 8'b11111111;
                        default:        o_spi_chip_en <= 8'd0;
                    endcase
                    
                    o_spi_start <= 1'b1;
                    state <= S_WAIT_FIRST_SPI;
                end
                
                S_WAIT_FIRST_SPI: begin
                    if (i_spi_ready) begin
                        // SPI complete, now arm and enable LP
                        state <= S_ARMED;
                        lp_enable <= 1'b1;  // Enable combinational LP pass-through
                        timing_cnt <= 5'd0;
                        timeout_cnt <= 32'd0;
                    end
                end
                
                S_ARMED: begin
                    // Waiting for i_UPDATE trigger
                    // LP is enabled and will follow i_UPDATE combinationally
                    o_scan_armed <= 1'b1;
                    

                    // Detect falling edge of i_UPDATE (LP just completed)
                    if (update_pha_d2 && !update_pha_d1) begin
                        // i_UPDATE just fell, LP pulse completed
                        // Now wait LP_LAG_CYCLES before starting next SPI
                        lp_enable <= 1'b0;  // Disable LP until next direction ready
                        timing_cnt <= 5'd0;
                        state <= S_LP_LAG_WAIT;
                    end
                    
                    // Timeout check
                    if (dir_index >= 1) begin
                        if (timeout_cnt >= timeout_cycles) begin
                            state <= S_IDLE;
                            o_scan_timeout <= 1'b1;
                            o_scan_armed <= 1'b0;
                            o_scan_active <= 1'b0;
                            lp_enable <= 1'b0;
                        end else begin
                            if (update_pha_posedge) begin
                                timeout_cnt <= 0;
                            end else begin
                                timeout_cnt <= timeout_cnt + 1'b1;                                
                            end
                        end                        
                    end
                end
                
                S_LP_LAG_WAIT: begin
                    if (timing_cnt >= LP_LAG_CYCLES) begin
                        if (dir_index >= num_directions - 1) begin
                            state <= S_DONE;
                            o_scan_done <= 1'b1;
                            o_scan_active <= 1'b0;
                        end else begin
                            dir_index <= dir_index + 1'b1;
                            state <= S_LOAD_NEXT;
                        end
                    end else begin
                        timing_cnt <= timing_cnt + 1'b1;
                    end
                end
                
                S_LOAD_NEXT: begin
                    // Load next direction's SPI data
                    o_spi_data_0 <= {2'b00, 3'b010, 3'b011, precomputed_phase_0[dir_index], precomputed_phase_1[dir_index]}; 
                    o_spi_data_1 <= {2'b00, 3'b010, 3'b011, precomputed_phase_2[dir_index], precomputed_phase_3[dir_index]};
                    o_spi_data_2 <= {2'b00, 3'b010, 3'b011, precomputed_phase_4[dir_index], precomputed_phase_5[dir_index]};
                    o_spi_data_3 <= {2'b00, 3'b010, 3'b011, precomputed_phase_6[dir_index], precomputed_phase_7[dir_index]};
                    o_spi_data_4 <= {2'b00, 3'b010, 3'b011, precomputed_phase_1[dir_index], precomputed_phase_0[dir_index]};
                    o_spi_data_5 <= {2'b00, 3'b010, 3'b011, precomputed_phase_3[dir_index], precomputed_phase_2[dir_index]};
                    o_spi_data_6 <= {2'b00, 3'b010, 3'b011, precomputed_phase_5[dir_index], precomputed_phase_4[dir_index]};
                    o_spi_data_7 <= {2'b00, 3'b010, 3'b011, precomputed_phase_7[dir_index], precomputed_phase_6[dir_index]};
                    
                    o_spi_start <= 1'b1;
                    state <= S_WAIT_SPI;
                end
                
                S_WAIT_SPI: begin
                    if (i_spi_ready) begin
                        // SPI complete, re-enable LP and wait for next trigger
                        lp_enable <= 1'b1;
                        timeout_cnt <= 32'd0;
                        state <= S_ARMED;
                    end
                end
                
                S_DONE: begin
                    o_scan_active <= 1'b0;
                    o_scan_done <= 1'b1;
                    o_scan_armed <= 1'b0;
                    lp_enable <= 1'b0;
                    
                    if (i_cfg_valid && i_cfg_cmd == CMD_SCAN_DISARM) begin
                        state <= S_IDLE;
                    end
                end
                
                default: state <= S_IDLE;
            endcase
            
            // Disarm from any state
            if (cfg_valid_d1 && i_cfg_cmd == CMD_SCAN_DISARM) begin
                state <= S_IDLE;
                o_scan_armed <= 1'b0;
                o_scan_active <= 1'b0;
                o_scan_timeout <= 1'b0;
                timeout_cnt <= 0;
                lp_enable <= 1'b0;
            end
            
            // // Timeout during active scan (except in lag wait or done)
            // if (o_scan_active && state != S_DONE && state != S_LP_LAG_WAIT) begin
            //     if (timeout_cnt >= timeout_cycles) begin
            //         state <= S_IDLE;
            //         o_scan_timeout <= 1'b1;
            //         o_scan_armed <= 1'b0;
            //         o_scan_active <= 1'b0;
            //         lp_enable <= 1'b0;
            //     end
            // end
            
        end // end of non-rst_n
    end

endmodule