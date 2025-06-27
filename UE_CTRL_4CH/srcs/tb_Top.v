`timescale 1ns / 1ps


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
    wire [3:0] TX_B1_LE;
    wire [5:0] RX_B1_DSA;
    wire [3:0] RX_B1_LE;
    wire [3:0] RX_B1_LNA_BYPASS;
    wire TX_LED;
    wire RX_LED;

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
        .TX_LED(TX_LED),
        .RX_LED(RX_LED)
    );

    initial begin
        CLK_SYS = 0;
        forever begin
            // 100MHz 
            #5 CLK_SYS = ~CLK_SYS; 
        end
    end


////////////////////////////////////////////////////////////////////////////////
// 测试 USB插入时使用UART的控制流
////////////////////////////////////////////////////////////////////////////////

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

        // 打开 TX
        send_multiple_bytes(48'h555D_00_04_02_00, 6);
        #100000;

        // 关闭所有通道 
        send_multiple_bytes(48'h555D_00_04_00_00, 6);
        #100000;

        // 打开 RX
        send_multiple_bytes(48'h555D_00_04_01_00, 6);
        #100000;

        // 待机 
        send_multiple_bytes(48'h555D_00_06_00_00, 6);
        #100000;

        // 向所有通道写入衰减码字 0x3A
        send_multiple_bytes(48'h555D_00_0A_03_3A, 6);
        #100000;

        // 向所有RX通道写入衰减码字 0x1F
        send_multiple_bytes(48'h555D_00_0A_01_1F, 6);
        #100000;

        // 向所有TX通道写入衰减码字 0x0E
        send_multiple_bytes(48'h555D_00_0A_02_0E, 6);
        #100000;

        // 向RX1通道写入衰减码字 0x28
        send_multiple_bytes(48'h555D_00_5A_00_28, 6);
        #100000;

        // 停止模拟
        #5000;
        $stop;
    end


////////////////////////////////////////////////////////////////////////////////
// 测试 USB未插入时使用外部SPI的控制流
////////////////////////////////////////////////////////////////////////////////
    // // 初始化测试环境
    // initial begin


    //     // Reset applied
    //     SPI_DATA = 0;
    //     SPI_CLK = 0;
    //     SPI_LE = 0;

    //     SPI_DATA_MCU = 0;
    //     SPI_CLK_MCU = 0;
    //     SPI_LE_MCU = 0;

    //     UPDATE = 0;
    //     TX_ON = 0;
    //     RX_ON = 0;

    //     TXD_HOST = 1;
    //     PLUG_IN = 0;


    //     // 复位信号保持一段时间 
    //     #500;

    //     // // 打开 RF_Bank1 TX
    //     // send_spi_data(32'h00_04_02_00, 4);
    //     // #100000;

    //     // 打开 RF_Bank2 RX
    //     // send_spi_data(32'h01_04_01_00, 4);
    //     send_spi_data(16'h01_04, 2);
    //     send_spi_data(16'h01_00, 2);
    //     #100000;

    //     // // 关闭所有 RF_Bank
    //     // send_spi_data(32'h02_04_00_00, 4);
    //     // #100000;

    //     // // 打开所有 RF_Bank TX
    //     // send_spi_data(32'h02_04_02_00, 4);
    //     // #100000;

    //     // 向所有 RF_Bank 的所有通道写入衰减码字 0x3A
    //     // send_spi_data(32'h02_0A_01_3A, 4);
    //     send_spi_data(16'h02_0A, 2);
    //     send_spi_data(16'h01_3A, 2);
    //     #100000;

    //     // 向 RF_Bank1 的通道8（TX的最后一个通道）写入衰减码字 0x3F
    //     // send_spi_data(32'h00_7A_00_3F, 4);
    //     send_spi_data(16'h00_7A, 2);
    //     send_spi_data(16'h00_3F, 2);
    //     #100000;

    //     // 向 RF_Bank2 的通道13（RX的第六个通道）写入衰减码字 0x28
    //     // send_spi_data(32'h01_DA_00_28, 4);
    //     send_spi_data(16'h01_DA, 2);
    //     send_spi_data(16'h00_28, 2);
    //     #100000;

    //     // 开启 RF_Bank2 编号0的 LNA 的 Bypass
    //     send_spi_data(32'h01_0B_00_01, 4);
    //     #100000;

    //     // 开启 RF_Bank1和2 所有 LNA 的 Bypass
    //     send_spi_data(32'h02_0B_01_01, 4);
    //     #100000;
        
    //     // 关闭 RF_Bank1和2 所有 LNA 的 Bypass
    //     send_spi_data(32'h02_0B_01_00, 4);
    //     #100000;

    //     // 停止模拟 
    //     #5000;
    //     $stop;
    // end


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

// Task to send `byte_cnt` bytes via SPI
task send_spi_data(
    input [31:0] data,
    input [2:0] byte_cnt
);
    integer i;
    
    begin
        SPI_LE = 0;
        for (i = byte_cnt*8-1; i >= 0; i = i - 1) begin
            // MSB ->LSB
            SPI_DATA = data[i];
            // #20; //25MHz
            // #125; //4MHz
            #250; //2MHz
            // #1000; //500kHz
            SPI_CLK = 1; 

            // #20; //25MHz
            // #125; //4MHz
            #250; //2MHz
            // #1000; //500kHz
            SPI_CLK = 0;
        end
        SPI_LE = 1;
        #100;
    end
endtask
endmodule

