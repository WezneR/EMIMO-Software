`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/15 16:53:06
// Design Name: 
// Module Name: tb_SPI_Master_PE44951
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

module SPI_Master_PE44951_tb;
  // SPI_Master_PE44951 Parameters
  parameter PERIOD = 10; // 10ns (100MHz时钟)
  parameter clk_div = 2;
  parameter spi_max_data_len = 24;
  parameter spi_bits_cnt_width  = (
        spi_max_data_len <= 2    ? 1 :
        spi_max_data_len <= 4    ? 2 :
        spi_max_data_len <= 8    ? 3 :
        spi_max_data_len <= 16   ? 4 :
        spi_max_data_len <= 32   ? 5 :
        spi_max_data_len <= 64   ? 6 :
        spi_max_data_len <= 128  ? 7 :
                                8)
          ;
  parameter spi_data_depth = spi_max_data_len;
  parameter rx_head_depth = spi_data_depth - 16;
  parameter slave_num = 8;

  // SPI_Master_PE44951 Inputs
  reg  [spi_max_data_len-1:0] i_spi_data_tx = 0;
  reg                         i_spi_start = 0;
  reg                         i_spi_dir = 0;
  reg  [                 3:0] i_chip_id = 0;
  reg                         i_spi_all = 0;
  reg  [       slave_num-1:0] i_miso = 0;

  // SPI_Master_PE44951 Outputs
  wire [spi_max_data_len-1:0] o_spi_data_rx;
  wire [       slave_num-1:0] o_cs;
  wire [       slave_num-1:0] o_mosi;
  wire [       slave_num-1:0] o_sclk;
  wire                        o_spi_ready;



  reg                         clk = 0;

  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  reg rst_n = 0;

  initial begin
    #(PERIOD * 2) rst_n = 1;
  end

  SPI_Master_PE44951 #(
      .clk_div         (2),
      .spi_max_data_len(24)
  ) u_SPI_Master_PE44951 (
      .i_clk        (clk),
      .i_rst_n      (rst_n),
      .i_spi_data_tx(i_spi_data_tx[spi_max_data_len-1:0]),
      .i_spi_start  (i_spi_start),
      .i_spi_dir    (i_spi_dir),
      .i_chip_id    (i_chip_id[3:0]),
      .i_spi_all    (i_spi_all),
      .i_miso       (i_miso),

      .o_spi_data_rx(o_spi_data_rx[spi_max_data_len-1:0]),
      .o_cs         (o_cs),
      .o_mosi       (o_mosi),
      .o_sclk       (o_sclk),
      .o_spi_ready  (o_spi_ready)
  );

  initial begin

    #500
    i_spi_data_tx <= 24'hAA_BB_CC;
    i_spi_start <= 1;
    i_chip_id <= 3;

    #PERIOD 
    i_spi_start <= 0;
    
    #3000
    
    $finish;
  end

endmodule
