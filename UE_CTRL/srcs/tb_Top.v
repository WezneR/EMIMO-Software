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

module top_tb;


    parameter clock_ = 1000000000/115200; // 115200 baud rate, 每个符号周期的时长

    // Inputs
    reg CLK_SYS;
    reg SPI_DATA;
    reg SPI_CLK;
    reg SPI_LE;
    reg UPDATE;
    reg TX_ON;
    reg RX_ON;
    reg MODE;
    reg REV;
    reg TXD_HOST;
    reg TXD_MCU;
    reg SPI_DATA_MCU;
    reg SPI_CLK_MCU;
    reg SPI_LE_MCU;
    reg UPDATE_MCU;
    reg TX_ON_MCU;
    reg RX_ON_MCU;
    reg MODE_MCU;
    reg REV1_MCU;
    reg REV2_MCU;
    reg PLUG_IN;


    // Outputs
    wire RXD_HOST;
    wire TX_ON_B1;
    wire RX_ON_B1;
    wire [5:0] TX_B1_DSA;
    wire [7:0] TX_B1_LE;
    wire [5:0] RX_B1_DSA;
    wire [7:0] RX_B1_LE;
    wire [7:0] RX_B1_LNA_BYPASS;
    wire TX_ON_B2;
    wire RX_ON_B2;
    wire [5:0] TX_B2_DSA;
    wire [7:0] TX_B2_LE;
    wire [5:0] RX_B2_DSA;   
    wire [7:0] RX_B2_LE;
    wire [7:0] RX_B2_LNA_BYPASS;


    // Instantiate the Unit Under Test (UUT)
    CTRL_TOP uut (
        .CLK_SYS(CLK_SYS),
        .SPI_DATA(SPI_DATA),
        .SPI_CLK(SPI_CLK),
        .SPI_LE(SPI_LE),
        .UPDATE(UPDATE),
        .TX_ON(TX_ON),
        .RX_ON(RX_ON),
        .MODE(MODE),
        .REV(REV),
        .TXD_HOST(TXD_HOST),
        .TXD_MCU(TXD_MCU),
        .SPI_DATA_MCU(SPI_DATA_MCU),
        .SPI_CLK_MCU(SPI_CLK_MCU),
        .SPI_LE_MCU(SPI_LE_MCU),
        .UPDATE_MCU(UPDATE_MCU),
        .TX_ON_MCU(TX_ON_MCU),
        .RX_ON_MCU(RX_ON_MCU),
        .MODE_MCU(MODE_MCU),
        .REV1_MCU(REV1_MCU),
        .REV2_MCU(REV2_MCU),
        .PLUG_IN(PLUG_IN),
        .RXD_HOST(RXD_HOST),
        .TX_ON_B1(TX_ON_B1),
        .RX_ON_B1(RX_ON_B1),
        .TX_B1_DSA(TX_B1_DSA),
        .TX_B1_LE(TX_B1_LE),
        .RX_B1_DSA(RX_B1_DSA),
        .RX_B1_LE(RX_B1_LE),
        .RX_B1_LNA_BYPASS(RX_B1_LNA_BYPASS),
        .TX_ON_B2(TX_ON_B2),
        .RX_ON_B2(RX_ON_B2),
        .TX_B2_DSA(TX_B2_DSA),
        .TX_B2_LE(TX_B2_LE),
        .RX_B2_DSA(RX_B2_DSA),
        .RX_B2_LE(RX_B2_LE),
        .RX_B2_LNA_BYPASS(RX_B2_LNA_BYPASS)
    );

    initial begin
        CLK_SYS = 0;
        forever begin
            // 100MHz 
            #5 CLK_SYS = ~CLK_SYS; 
        end
    end

    // 初始化测试环境
    initial begin


        // Reset applied
        SPI_DATA = 0;
        SPI_CLK = 0;
        SPI_LE = 0;

        SPI_DATA_MCU = 0;
        SPI_CLK_MCU = 0;
        SPI_LE_MCU = 0;

        UPDATE = 0;
        TX_ON = 0;
        RX_ON = 0;

        TXD_HOST = 1;
        PLUG_IN = 1;


        // 复位信号保持一段时间 

        #500;

        // // 打开 RF_Bank1 TX
        // send_multiple_bytes(48'h555D_00_04_02_00, 6);
        // #100000;

        // 打开 RF_Bank2 RX
        send_multiple_bytes(48'h555D_01_04_01_00, 6);
        #100000;

        // // 关闭所有 RF_Bank
        // send_multiple_bytes(48'h555D_02_04_00_00, 6);
        // #100000;

        // // 打开所有 RF_Bank TX
        // send_multiple_bytes(48'h555D_02_04_02_00, 6);
        // #100000;

        // 向所有 RF_Bank 的所有通道写入衰减码字 0x3A
        send_multiple_bytes(48'h555D_02_0A_01_3A, 6);
        #100000;

        // 向 RF_Bank1 的通道8（TX的最后一个通道）写入衰减码字 0x3F
        send_multiple_bytes(48'h555D_00_7A_00_3F, 6);
        #100000;

        // 向 RF_Bank2 的通道13（RX的第六个通道）写入衰减码字 0x28
        send_multiple_bytes(48'h555D_01_DA_00_28, 6);
        #100000;


        // 停止模拟
        #5000;
        $stop;
    end


// Task to send a byte via UART
task send_byte;
    input [7:0] byte;
    integer i;
    begin
        TXD_HOST = 0; // Start bit
        #clock_;
        for (i = 0; i < 8; i = i + 1) begin
            TXD_HOST = byte[i]; // Send LSB first
            #clock_;
        end
        TXD_HOST = 1; // Stop bit
        #clock_;
    end
endtask

// Task to send multiple bytes via UART
task send_multiple_bytes;
    input [71:0] data;
    input integer num_bytes;
    integer i;
    reg [7:0] byte;
    begin
        for (i = 0; i < num_bytes; i = i + 1) begin
            byte = data[((num_bytes -i -1) * 8) +: 8]; // Extract each byte
            send_byte(byte);
        end
    end
endtask

endmodule
