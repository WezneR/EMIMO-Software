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

    // Inputs
    reg HOST_SCLK;
    reg HOST_SDI;
    reg HOST_LE;
    reg UPDATE;
    reg TX_ON;
    reg RX_ON;
    reg REV1;
    reg REV2;
    reg MCU_FCLK;
    reg MCU_DCLK;
    reg MCU_PLUG;
    reg MCU_DATA;
    reg MCU_INIT;
    reg MCU_LE;
    reg clk_in;
    reg DEV_MODE;


    // Outputs
    wire [7:0]   PE44951_CS;
    wire [1:0]   PE44951_SCLK;
    wire [7:0]   PE44951_MOSI;
    wire [1:0]   PE44951_LP;
    wire         PE44951_Rset;
    wire [7:0]   FEM_TX_ON;
    wire [7:0]   FEM_RX_ON;
    wire         FEM_LNA_BYPASS;
    wire         IF_TX_ON;
    wire         IF_RX_ON;
    wire [1:0]   IF_DSA_LE;
    wire [11:0]  IF_DSA_DIN;
    // Instantiate the Unit Under Test (UUT)
    top uut (
        .HOST_SCLK(HOST_SCLK),
        .HOST_SDI(HOST_SDI),
        .HOST_LE(HOST_LE),
        .UPDATE(UPDATE),
        .TX_ON(TX_ON),
        .RX_ON(RX_ON),
        .REV1(REV1),
        .REV2(REV2),
        .MCU_FCLK(MCU_FCLK),
        .MCU_DCLK(MCU_DCLK),
        .MCU_PLUG(MCU_PLUG),
        .MCU_DATA(MCU_DATA),
        .MCU_INIT(MCU_INIT),
        .MCU_LE(MCU_LE),
        .clk_in(clk_in),
        .DEV_MODE(DEV_MODE),
        .PE44951_CS(PE44951_CS),
        .PE44951_SCLK(PE44951_SCLK),
        .PE44951_MOSI(PE44951_MOSI),
        .PE44951_MISO(8'h00), // Assuming no input from MISO for simplicity
        .PE44951_Rset(PE44951_Rset),
        .PE44951_LP(PE44951_LP),
        .FEM_LNA_BYPASS(FEM_LNA_BYPASS),
        .FEM_TX_ON(FEM_TX_ON),
        .FEM_RX_ON(FEM_RX_ON),
        .IF_TX_ON(IF_TX_ON),
        .IF_RX_ON(IF_RX_ON),
        .IF_DSA_LE(IF_DSA_LE),
        .IF_DSA_DIN(IF_DSA_DIN)
    );

    // Clock generation
    // initial begin
    //     clk_in_P = 0;
    //     clk_in_N = 1;
    //     forever begin
    //         // 100MHz 差分时钟
    //         #5 clk_in_P = ~clk_in_P; 
    //         clk_in_N = ~clk_in_P; 
    //     end
    // end
    initial begin
        clk_in = 0;
        forever begin
            // 100MHz 差分时钟
            #5 clk_in = ~clk_in; 
        end
    end


    // // 生成100MHz时钟信号
    // always #5 clk_100M = ~clk_100M;

    // 任务用于发送SPI数据
    task send_spi_data(
        input [31:0] data,    // SPI数据，32位
        input [2:0] byte_cnt  // 数据字节数
    );
        integer i;
        
        begin
            // MCU_LE = 0;  // 拉低片选信号，开始传输
            for (i = byte_cnt*8-1; i >= 0; i = i - 1) begin
                // 从MSB到LSB逐位发送
                MCU_DATA = data[i];  // 发送当前字节
                // #20; //25MHz
                // #125; //4MHz
                #250; //2MHz
                // #1000; //500kHz
                // SPI时钟信号高电平
                MCU_DCLK = 1; 

                // #20; //25MHz
                // #125; //4MHz
                #250; //2MHz
                // #1000; //500kHz
                // SPI时钟信号低电平
                MCU_DCLK = 0;
            end
            // MCU_LE = 1;  // 拉高片选信号，结束传输
            // #20;
        end
    endtask

    // 初始化测试环境
    initial begin


        // Reset applied
        HOST_SCLK = 0;
        HOST_SDI = 0;
        HOST_LE = 1;
        UPDATE = 0;
        TX_ON = 0;
        RX_ON = 0;
        REV1 = 0;
        REV2 = 0;
        MCU_FCLK = 0;
        MCU_DCLK = 0;
        MCU_PLUG = 0;         // Simulate MCU plug high
        MCU_DATA = 0;
        MCU_LE = 1;
        DEV_MODE = 1;


        // 复位信号保持一段时间
        #1000;
        // MCU_LE = 0;#4200;MCU_PLUG = 1;#14200;
        // #12000;MCU_LE = 1;#4200;MCU_PLUG = 0;
        // // 修改ID为0xA5
        // send_spi_data(32'h08_07_00_A5, 4);

        // // 初始化

        // // 先向BF_phase_reg写初值
        // send_spi_data(32'hA5_08_00_00, 4);
        // send_spi_data(32'hA5_08_01_11, 4);
        // send_spi_data(32'hA5_18_00_22, 4);
        // send_spi_data(32'hA5_18_01_33, 4);
        // send_spi_data(32'hA5_28_00_44, 4);
        // send_spi_data(32'hA5_28_01_55, 4);
        // send_spi_data(32'hA5_38_00_66, 4);
        // send_spi_data(32'hA5_38_01_77, 4);
        // send_spi_data(32'hA5_48_00_88, 4);
        // send_spi_data(32'hA5_48_01_99, 4);
        // send_spi_data(32'hA5_58_00_AA, 4);
        // send_spi_data(32'hA5_58_01_BB, 4);
        // send_spi_data(32'hA5_68_00_CC, 4);
        // send_spi_data(32'hA5_68_01_DD, 4);
        // send_spi_data(32'hA5_78_00_EE, 4);
        // send_spi_data(32'hA5_78_01_FF, 4);
        // // 再向atten_reg_init写初值
        // send_spi_data(32'hA5_09_00_00, 4);
        // send_spi_data(32'hA5_09_01_11, 4);
        // send_spi_data(32'hA5_19_00_22, 4);
        // send_spi_data(32'hA5_19_01_33, 4);
        // send_spi_data(32'hA5_29_00_44, 4);
        // send_spi_data(32'hA5_29_01_55, 4);
        // send_spi_data(32'hA5_39_00_66, 4);
        // send_spi_data(32'hA5_39_01_77, 4);
        // send_spi_data(32'hA5_49_00_88, 4);
        // send_spi_data(32'hA5_49_01_99, 4);
        // send_spi_data(32'hA5_59_00_AA, 4);
        // send_spi_data(32'hA5_59_01_BB, 4);
        // send_spi_data(32'hA5_69_00_CC, 4);
        // send_spi_data(32'hA5_69_01_DD, 4);
        // send_spi_data(32'hA5_79_00_EE, 4);
        // send_spi_data(32'hA5_79_01_FF, 4);
        // // 对所有板子执行初始化
        // send_spi_data(32'h08_01_00_00, 4);
        // #17000
        // // 向TX的最后一个芯片(chip_id=3)的AC1写入0x00
        // send_spi_data(32'hA5_32_02_00, 4);
        // // 向RX的最后一个芯片(chip_id=7)的AC2写入0x55
        // send_spi_data(32'hA5_72_03_55, 4);


        // // 所有板子同步更新相位（方式1）
        // send_spi_data(32'h08_05_00_00, 4);
        
        // // 所有板子同步更新相位（方式2）
        // UPDATE = 1;
        // #50
        // UPDATE = 0;

        // #100;
        // // 写入中频衰减
        // send_spi_data(32'hA5_0A_00_05, 4); // 向IFDSA_ID为0的衰减器写入 6'h05
        // send_spi_data(32'hA5_1A_01_07, 4); // 向IFDSA_ID为1的衰减器写入 6'h07，并在完成后更新
        // #100;
        // // 打开所有通道（方式1）
        // send_spi_data(32'h08_84_02_00, 4);
        // // 打开所有通道（方式2）
        // DEV_MODE = 0;
        // TX_ON = 1;
        // RX_ON = 0;

        // #200;

        // // 关闭所有通道（方式1）
        // send_spi_data(32'h08_84_00_00, 4);


        // // 关闭所有通道（方式2）
        // TX_ON = 1;
        // RX_ON = 1;

        // // 关闭所有通道（方式3）
        // send_spi_data(32'h08_06_00_00, 4);

        // #200;

        // // 打开编号为0的RX通道（用于校准）
        // send_spi_data(32'hA5_04_01_00, 4);

        // #200;

        // // 关闭编号为0的RX通道（校准完毕）
        // send_spi_data(32'hA5_04_00_00, 4);

        // #200;


        // // 输入 ang_pitch = -8'd50, ang_azimuth = -8'd120
        // send_spi_data(32'h08_00_88_CE, 4);


        // 打开所有RX通道
        MCU_LE = 0;#4200;MCU_PLUG = 1;#14200;
        send_spi_data(16'h08_84, 2);
        #6800;
        send_spi_data(16'h01_00, 2);
        // send_spi_data(32'h08_84_02_00, 4);
        #12000;MCU_LE = 1;#4200;MCU_PLUG = 0;

        // 停止模拟
        #2000;
        $stop;
    end



endmodule

