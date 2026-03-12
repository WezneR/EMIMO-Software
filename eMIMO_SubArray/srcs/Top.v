`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: hyq
//
// Create Date: 2025-12-07
// Design Name:
// Module Name: top_v3
// Project Name: 1x8 Analog Beamforming ULA
// Target Devices: Spartan-6
// Tool versions: ISE 14.7
// Description:
//     Updated top module with beam scan controller integration.
//     
//     Key additions:
//     - REV1 input used as beam scan trigger from digital baseband
//     - Beam scan status outputs for monitoring
//     - Support for synchronized beam scanning across multiple ULAs
//
// Dependencies:
//     - spi_process_v2
//     - beam_scan_controller
//     - SPI_Slave
//     - spi_listener
//     - SPI_Master_PE44951
//     - host_spi_mux
//     - FEM_TR_switch
//     - rst
//
// Revision:
// Revision v2 - Added beam scan support
//
// added Date: 2025-12-11
// 
// Description:
//     Optimized top module with shared phase calculator.
//     
//     Key changes from v2:
//     - Uses spi_process_v4 which shares a single phase_shift_calculator
//       between manual beamforming and beam scanning
//     - Reduces LUT usage by eliminating duplicate lookup table
//
// Dependencies:
//     - spi_process_v4
//     - beam_scan_controller_v2
//     - SPI_Slave
//     - spi_listener
//     - SPI_Master_PE44951_Parallel
//     - host_spi_mux
//     - FEM_TR_switch
//     - rst
//     - phase_shift_calculator
//
// Revision:
// Revision v3 - Optimized for reduced LUT usage
//
//////////////////////////////////////////////////////////////////////////////////

module top_v3(
    // Host SPI Interface
    input  HOST_SCLK,
    input  HOST_SDI,
    input  HOST_LE,
    
    // Control signals from baseband
    input  UPDATE,          // Phase update trigger from baseband
    input  TX_ON,           // TX enable (hardware mode)
    input  RX_ON,           // RX enable (hardware mode)
    input  REV1,            // Reserved
    input  REV2,            // Reserved
    
    // MCU Interface
    input  MCU_FCLK,
    input  MCU_DCLK,
    input  MCU_PLUG,
    input  MCU_DATA,
    input  MCU_INIT,
    input  MCU_LE,
    // Device mode (DEV_MODE = 1 for software control)
    input  DEV_MODE,    

    // System clock
    input  clk_in,
    
    // PE44951 Phase Shifter Interface
    output [7:0]   PE44951_CS,
    output [1:0]   PE44951_SCLK,
    output [7:0]   PE44951_MOSI,
    input  [7:0]   PE44951_MISO,
    output         PE44951_Rset,
    output [1:0]   PE44951_LP,

    // FEM Control
    output FEM_LNA_BYPASS,
    output [7:0]   FEM_TX_ON,
    output [7:0]   FEM_RX_ON,
    
    // IF Switch and DSA
    output IF_TX_ON,
    output IF_RX_ON,
    output [1:0] IF_DSA_LE,
    output [11:0] IF_DSA_DIN,
    
    // Status LEDs
    output TX_ON_LED,
    output RX_ON_LED
);

    // Parameters
    parameter clk_frq = 100000000;
    parameter spi_clk_div = 2;
    parameter spi_listener_data_len = 32;
    parameter spi_master_data_len = 24;
    parameter spi_bits_cnt_width = $clog2(spi_master_data_len);
    
    wire clk = clk_in;
    wire rst_n;

    //==========================================================================
    // Internal Signals
    //==========================================================================
    
    // SPI Slave signals
    wire spi_slave_data_valid;
    wire [7:0] spi_slave_byte;
    wire [31:0] spi_listener_data;
    wire spi_listener_interrupt;

    // Host SPI mux signals
    wire selected_SCLK;
    wire selected_SDI;
    wire selected_LE;

    // TR switch signals
    wire [7:0] TX_on_spi;
    wire [7:0] RX_on_spi;
    wire IF_TX_on_spi;
    wire IF_RX_on_spi;

    // IF DSA signals
    wire [1:0] IFDSA_LE;
    wire [11:0] IFDSA_DIN;

    //==========================================================================
    // SPI Slave Module
    //==========================================================================
    parameter SPI_MODE = 0;
    
    SPI_Slave #(
        .SPI_MODE(SPI_MODE)
    ) SPI_Slave_inst (
        .i_Rst_L(rst_n),
        .i_Clk(clk),
        .o_RX_DV(spi_slave_data_valid),
        .o_RX_Byte(spi_slave_byte),
        .i_SPI_Clk(selected_SCLK),
        .i_SPI_MOSI(selected_SDI),
        .i_SPI_CS_n(selected_LE)
    );

    //==========================================================================
    // SPI Listener Module
    //==========================================================================
    spi_listener SPI_Listener_inst (
        .clk(clk),
        .spi_slave_data_valid(spi_slave_data_valid),
        .spi_slave_byte(spi_slave_byte),
        .spi_data(spi_listener_data),
        .spi_listener_interrupt(spi_listener_interrupt)
    );

    //==========================================================================
    // Process Module v4 (Optimized with Shared Phase Calculator)
    //==========================================================================
    spi_process_v4 #(
        .spi_listener_data_len(spi_listener_data_len),
        .spi_master_data_len(spi_master_data_len)
    ) process_inst (
        .clk_100M(clk),
        .rst_n(rst_n),
        .i_DEV_MODE(DEV_MODE),
        .i_UPDATE(UPDATE),
        .i_spi_listener_interrupt(spi_listener_interrupt),
        .i_spi_data(spi_listener_data),
        
        // PE44951 SPI and control
        .o_PS_CS(PE44951_CS),
        .o_PS_MOSI(PE44951_MOSI),
        .o_PS_SCLK(PE44951_SCLK),
        .o_RsetB(PE44951_Rset),
        .o_LP_Pulse(PE44951_LP),
        
        // FEM control
        .o_TX_ON(TX_on_spi),
        .o_RX_ON(RX_on_spi),
        .o_LNA_BYPASS(FEM_LNA_BYPASS),

        // IF switch and DSA control
        .o_IF_TX_ON(IF_TX_on_spi),
        .o_IF_RX_ON(IF_RX_on_spi),
        .o_IFDSA_LE(IFDSA_LE),
        .o_IFDSA_DIN(IFDSA_DIN),
        
        // Beam scan status
        .o_scan_dir_index(SCAN_DIR_INDEX),
        .o_scan_state(SCAN_STATE),
        .o_scan_armed(SCAN_ARMED),
        .o_scan_active(SCAN_ACTIVE),
        .o_scan_done(SCAN_DONE),
        .o_scan_timeout(SCAN_TIMEOUT)
    );

    // IF DSA output assignments
    assign IF_DSA_LE = IFDSA_LE;
    assign IF_DSA_DIN = IFDSA_DIN;

    //==========================================================================
    // Host SPI Mux
    //==========================================================================
    host_spi_mux spi_mux_inst (
        .i_SEL(MCU_PLUG),
        .i_SCLK_1(HOST_SCLK),
        .i_SDI_1(HOST_SDI),
        .i_LE_1(HOST_LE),
        .i_SCLK_2(MCU_DCLK),
        .i_SDI_2(MCU_DATA),
        .i_LE_2(MCU_LE),
        .o_SCLK_mux_out(selected_SCLK),
        .o_SDI_mux_out(selected_SDI),
        .o_LE_mux_out(selected_LE)
    );

    //==========================================================================
    // FEM TR Switch Control
    //==========================================================================
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

    //==========================================================================
    // Reset Module
    //==========================================================================
    parameter delay_cnt = 10;
    
    rst #(
        .delay_cnt(delay_cnt)
    ) rst_inst (
        .clk(clk),
        .rst_n(rst_n)
    );

endmodule