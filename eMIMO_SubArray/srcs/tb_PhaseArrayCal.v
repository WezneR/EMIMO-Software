`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 16:31:00
// Design Name: 
// Module Name: tb_PhaseArrayCal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_phase_shift_calculator();

    // Inputs
    reg signed [7:0] ang_pitch;
    reg signed [7:0] ang_azimuth;
    reg [7:0] General_BID;

    // Outputs
    wire signed [7:0] PSB0;
    wire signed [7:0] PSB1;
    wire signed [7:0] PSB2;
    wire signed [7:0] PSB3;
    wire signed [7:0] PSB4;
    wire signed [7:0] PSB5;
    wire signed [7:0] PSB6;
    wire signed [7:0] PSB7;

    // Instantiate the Unit Under Test (UUT)
    phase_shift_calculator uut (
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

    initial begin
        // Initialize Inputs
        // ang_pitch = 8'd30;       // 
        ang_pitch = -8'd50;       // 1100_1110

        // ang_azimuth = 8'd60;     // 
        // ang_azimuth = 8'd60;     // 
        ang_azimuth = -8'd120;     // 1000_1000

        General_BID = 8'd150;    // 广义Board编号

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add additional stimulus here if necessary
        // For example, you might want to test different angles or BID values.
    end
      
endmodule
