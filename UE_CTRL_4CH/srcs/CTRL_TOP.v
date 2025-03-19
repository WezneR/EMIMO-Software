`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:59:05 10/27/2024 
// Design Name: 
// Module Name:    CTRL_TOP 
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
//////////////////////////////////////////////////////////////////////////////////
module CTRL_TOP(CLK_SYS,SPI_DATA,SPI_CLK,SPI_LE,UPDATE,TX_ON,RX_ON,MODE,REV,TXD_HOST,RXD_HOST,
						SPI_DATA_MCU,SPI_CLK_MCU,SPI_LE_MCU,UPDATE_MCU,TX_ON_MCU,RX_ON_MCU,
                                    MODE_MCU,REV1_MCU,REV2_MCU,PLUG_IN,TXD_MCU,TX_LED,RX_LED,
						TX_ON_B1,RX_ON_B1,TX_B1_DSA,TX_B1_LE,RX_B1_DSA,RX_B1_LE,RX_B1_LNA_BYPASS
    );
input CLK_SYS;
input SPI_DATA;
input SPI_CLK;
input SPI_LE;
input UPDATE;
input TX_ON;
input RX_ON;
input MODE;
input REV;
input TXD_HOST;
input TXD_MCU;
input SPI_DATA_MCU;
input SPI_CLK_MCU;
input SPI_LE_MCU;
input UPDATE_MCU;
input TX_ON_MCU;
input RX_ON_MCU;
input MODE_MCU;
input REV1_MCU;
input REV2_MCU;
input PLUG_IN;
output RXD_HOST;
output TX_ON_B1;
output RX_ON_B1;
output wire [5:0] TX_B1_DSA;
output wire [3:0] TX_B1_LE;
output wire [5:0] RX_B1_DSA;
output wire [3:0] RX_B1_LE;
output wire [3:0] RX_B1_LNA_BYPASS;
output TX_LED;
output RX_LED;

wire CLK_B1;
wire clk;
wire rst_n; 


IBUFG #(
      .IBUF_DELAY_VALUE("0"), // Specify the amount of added input delay for 
                              //   the buffer: "0"-"16" (Spartan-3A)
      .IOSTANDARD("DEFAULT")
  ) IBUFG_inst (
      .O(CLK_B1), // Clock buffer output
      .I(CLK_SYS)  // Clock buffer input (connect directly to top-level port)
);

BUFG BUFG_inst (
      .O(clk),     // Clock buffer output
      .I(CLK_B1)      // Clock buffer input
);

// 主机的SPI状态和数据
wire spi_slave_data_valid;
wire [7:0] spi_slave_byte;
wire [31:0] spi_listener_data;
wire spi_listener_interrupt;
// ============================== spi_slave ==============================
parameter SPI_MODE = 0; // CPOL = 0, CPHA = 0
SPI_Slave #(
      .SPI_MODE(SPI_MODE)
)
SPI_Slave_test    
(
      .i_Rst_L(rst_n),
      .i_Clk(clk),
      .o_RX_DV(spi_slave_data_valid), 
      .o_RX_Byte(spi_slave_byte),
      .i_SPI_Clk(SPI_CLK),
      .i_SPI_MOSI(SPI_DATA),
      .i_SPI_CS_n(SPI_LE)
);
// ============================== spi_listener ==============================
spi_listener SPI_Listener_test
(
      .clk(clk),
      .spi_slave_data_valid(spi_slave_data_valid),
      .spi_slave_byte(spi_slave_byte),
      .spi_data(spi_listener_data),
      .spi_listener_interrupt(spi_listener_interrupt)
);

// ============================== RX模块 ==============================
// UART RX/TX模块输入时钟的频率 
parameter clk_frq = 100000000;
// 默认数据深度为36，单次支持最大data_depth的接收和发送 建议最大不超过63，如果超过63，请改变下面的 send_data_bytes和receive_data_bytes
parameter  uart_max_byte_len = 10;
// 默认波特率=9600  支持 4800 9600 19200 57600 115200 230400 460800 921600
parameter  Baud_rate = 115200;
// 数据位数
parameter  data_bits = 4'd8;
// 停止位，00=1位停止位，01=1.5位停止位，10=2位停止位
parameter  stop_bits = 2'b00;
// 校验位，00=无校验位， 01=偶校，10=奇校验
parameter  parity = 2'b00;


wire [uart_max_byte_len*8-1:0] receive_data;
wire [uart_max_byte_len*8-1:0] receive_data_;
wire [5:0] receive_data_bytes;
wire [uart_max_byte_len-1:0] receive_data_check;
wire receive_data_check_all;
wire RX_interrupt;
wire RX_interrupt_clear;

UART_RX #(
      // 默认波特率=9600  支持 4800 9600 19200 57600 115200 230400 460800 921600
      .Baud_rate(Baud_rate),
      // 输入时钟的频率（单位Hz） 默认时钟频率100MHz 请大于100MHz 并且小于250MHz 
      .clk_frq(clk_frq),
      // 默认数据深度为36，单次支持最大data_depth的接收和发送 建议最大不超过63，如果超过63，请改变下面的 send_data_bytes和receive_data_bytes
      .uart_max_byte_len(uart_max_byte_len)
)
UART_RX_inst(
      // 输入时钟
      .clk(clk),
      // 复位，低电平复位
      .rst(rst_n),

      // 数据bit 支持5 6 7 8
      .data_bits(data_bits),
      // 停止位，00=1位停止位，01=1.5位停止位，10=2位停止位
      .stop_bits(stop_bits),
      // 校验位，00=无校验位， 01=偶校，10=奇校验
      .parity(parity),

      // 接收的数据  数据靠近低位
      .receive_data(receive_data),
      // 接收的数据  数据靠近高位
      .receive_data_(receive_data_),
      // 接收的数据的字节数
      .receive_data_bytes(receive_data_bytes),
      // 接收的数据是否满足奇偶校验（如果启用了奇偶校验功能，1表示正确数据，0表示不正确数据），每个bit表征该字节的正确度
      .receive_data_check(receive_data_check),
      // 接收的数据串正确度 1表示正确，0表示错误
      .receive_data_check_all(receive_data_check_all),

      // 接收完一次的中断标志
      .RX_interrupt(RX_interrupt),
      // 清除接收中断标志
      .RX_interrupt_clear(RX_interrupt_clear),
      // 串口RX线
      .RX(TXD_HOST)
);

// ============================== TX模块 ==============================
wire [uart_max_byte_len*8-1:0] send_data;
wire [5:0] send_data_bytes;
wire TX_ready;
wire start_TX;

UART_TX #(
      // 默认波特率=115200  支持 4800 9600 19200 57600 115200 230400 460800 921600
      .Baud_rate(Baud_rate),
      // 默认时钟频率100MHz 请大于100MHz 并且小于250MHz
      .clk_frq(clk_frq),
      // 默认数据深度为36，单次支持最大data_depth的接收和发送 建议最大不超过63，如果超过63，请改变下面的 send_data_bytes和receive_data_bytes
      .uart_max_byte_len(uart_max_byte_len)
)
UART_TX_inst (
      // 总体时钟 与clk_frq相匹配
      .clk(clk),
      // 复位，低电平复位
      .rst(rst_n),

      // 数据bit 支持5 6 7 8
      .data_bits(data_bits),
      // 停止位，00=1位停止位，01=1.5位停止位，10=2位停止位
      .stop_bits(stop_bits),
      // 校验位，00=无校验位， 01=偶校，10=奇校验
      .parity(parity),

      // 将要发送的数据
      .send_data(send_data),
      // 将要发送的数据的字节数
      .send_data_bytes(send_data_bytes),

      // 可以进行发送的标志,高电平表示TX模块可以使用。可以进行发送
      .TX_ready(TX_ready),
      // 进行一次发送进程，高电平脉冲信号，高电平持续时间不小于clk的两个时钟周期
      .start_TX(start_TX),

      // 串口TX线
      .TX(RXD_HOST)
);

// =============================== uart listener ==============================
wire [31:0] uart_data;
wire uart_interrupt;

UART_Listener #(
      .uart_max_byte_len(uart_max_byte_len)
)
uart_listener_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_RX_interrupt(RX_interrupt),
    .i_receive_data_bytes(receive_data_bytes),
    .i_receive_data_(receive_data_),
    .o_RX_interrupt_clear(RX_interrupt_clear), // 连接至UART_RX的输出
    .o_uart_interrupt(uart_interrupt),
    .o_uart_data(uart_data)
);

// ============================== ctrl switch ==============================
wire [31:0] ctrl_data;
wire ctrl_interrupt;
CTRL_switch CTRL_switch_inst (
    .i_SEL(PLUG_IN), // 根据PLUG_IN选择控制源
    .i_spi_data(spi_listener_data), // 从SPI.Listener获取数据
    .i_spi_interrupt(spi_listener_interrupt),
    .i_uart_data(uart_data),
    .i_uart_interrupt(uart_interrupt),
    .o_ctrl_data(ctrl_data),
    .o_ctrl_interrupt(ctrl_interrupt)
);

// ============================== process ==============================
wire TX_on_soft;
wire RX_on_soft;

ctrl_process process_inst (
      .clk_100M(clk),
      .rst_n(rst_n),

      .ctrl_data(ctrl_data),
      .ctrl_interrupt(ctrl_interrupt),

      // TR切换
      .o_TX_ON(TX_on_soft),
      .o_RX_ON(RX_on_soft),
      // 衰减控制
      .TX_B1_DSA(TX_B1_DSA),
      .TX_B1_LE(TX_B1_LE),
      .RX_B1_DSA(RX_B1_DSA),
      .RX_B1_LE(RX_B1_LE),
      // LNA bypass
      .o_B1_LNA_BYPASS(RX_B1_LNA_BYPASS)
);

// ============================== TR开关控制 ==============================
FEM_TR_switch FEM_TR_switch_inst (
      .i_soft_EN(PLUG_IN),
      .i_TX_ON(TX_ON),
      .i_RX_ON(RX_ON),
      .i_TX_ON_soft(TX_on_soft),
      .i_RX_ON_soft(RX_on_soft),
      .o_TX_ON_B1(TX_ON_B1),
      .o_RX_ON_B1(RX_ON_B1)
);

// ============================== LED控制模块 ==============================
LED_control LED_control_inst (
    .TX_ON_B1(TX_ON_B1),
    .RX_ON_B1(RX_ON_B1),
    .TX_LED(TX_LED),
    .RX_LED(RX_LED)
);

// ============================== rst模块 ==============================
parameter delay_cnt = 10;

rst #(
      .delay_cnt(delay_cnt)
)
rst_test (
      .clk(clk),
      .rst_n(rst_n)
);

endmodule
