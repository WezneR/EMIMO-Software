`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Parallel SPI Master for PE44951 Phase Shifters
// Sends independent 24-bit data on 8 MOSI lines simultaneously
//////////////////////////////////////////////////////////////////////////////////

module SPI_Master_PE44951_Parallel #(
    parameter clk_div = 2,
    parameter spi_data_len = 24
)(
    input i_clk,
    input i_rst_n,
    
    // Parallel data input: 8 chips x 24 bits = 192 bits
    input [spi_data_len-1:0] i_spi_data_0,
    input [spi_data_len-1:0] i_spi_data_1,
    input [spi_data_len-1:0] i_spi_data_2,
    input [spi_data_len-1:0] i_spi_data_3,
    input [spi_data_len-1:0] i_spi_data_4,
    input [spi_data_len-1:0] i_spi_data_5,
    input [spi_data_len-1:0] i_spi_data_6,
    input [spi_data_len-1:0] i_spi_data_7,
    
    input i_spi_start,
    input [7:0] i_chip_en,              // Which chips to enable (active high)
    
    // SPI outputs
    output reg [7:0] o_cs,              // Directly active low chip selects
    output reg [7:0] o_mosi,            // 8 independent MOSI lines
    output reg [1:0] o_sclk,            // Shared SCLK (directly active)
    output reg o_spi_ready
);

    // Bit counter width
    localparam BIT_CNT_WIDTH = 5;  // Up to 32 bits
    
    // Internal registers for shift data
    reg [spi_data_len-1:0] shift_reg_0;
    reg [spi_data_len-1:0] shift_reg_1;
    reg [spi_data_len-1:0] shift_reg_2;
    reg [spi_data_len-1:0] shift_reg_3;
    reg [spi_data_len-1:0] shift_reg_4;
    reg [spi_data_len-1:0] shift_reg_5;
    reg [spi_data_len-1:0] shift_reg_6;
    reg [spi_data_len-1:0] shift_reg_7;
    
    reg [7:0] chip_en_reg;
    reg [BIT_CNT_WIDTH-1:0] bit_cnt;
    reg [15:0] clk_div_cnt;
    
    // State machine
    reg [1:0] spi_state;
    localparam S_IDLE       = 2'd0;
    localparam S_CLOCK_LOW  = 2'd1;
    localparam S_CLOCK_HIGH = 2'd2;
    localparam S_DONE       = 2'd3;

    always @(posedge i_clk) begin
        if (!i_rst_n) begin
            o_cs <= 8'b11111111;
            o_sclk <= 2'b00;
            o_mosi <= 8'b00000000;
            spi_state <= S_IDLE;
            o_spi_ready <= 1'b1;
            bit_cnt <= 0;
            clk_div_cnt <= 0;
            shift_reg_0 <= 0;
            shift_reg_1 <= 0;
            shift_reg_2 <= 0;
            shift_reg_3 <= 0;
            shift_reg_4 <= 0;
            shift_reg_5 <= 0;
            shift_reg_6 <= 0;
            shift_reg_7 <= 0;
            chip_en_reg <= 8'b00000000;
        end
        else begin
            case (spi_state)
                S_IDLE: begin
                    o_cs <= 8'b11111111;
                    o_sclk <= 2'b00;
                    o_mosi <= 8'b00000000;
                    o_spi_ready <= 1'b1;
                    
                    if (i_spi_start) begin
                        o_spi_ready <= 1'b0;
                        // Latch all data
                        shift_reg_0 <= i_spi_data_0;
                        shift_reg_1 <= i_spi_data_1;
                        shift_reg_2 <= i_spi_data_2;
                        shift_reg_3 <= i_spi_data_3;
                        shift_reg_4 <= i_spi_data_4;
                        shift_reg_5 <= i_spi_data_5;
                        shift_reg_6 <= i_spi_data_6;
                        shift_reg_7 <= i_spi_data_7;
                        chip_en_reg <= i_chip_en;
                        // Assert CS for enabled chips (active low)
                        o_cs <= ~i_chip_en;
                        bit_cnt <= 0;
                        clk_div_cnt <= 0;
                        spi_state <= S_CLOCK_LOW;
                    end
                end
                
                S_CLOCK_LOW: begin
                    if (clk_div_cnt < clk_div - 1) begin
                        clk_div_cnt <= clk_div_cnt + 1'b1;
                    end
                    else begin
                        clk_div_cnt <= 0;
                        o_sclk <= 2'b00;
                        // Output MSB of each shift register on corresponding MOSI
                        o_mosi[0] <= chip_en_reg[0] ? shift_reg_0[spi_data_len-1] : 1'b0;
                        o_mosi[1] <= chip_en_reg[1] ? shift_reg_1[spi_data_len-1] : 1'b0;
                        o_mosi[2] <= chip_en_reg[2] ? shift_reg_2[spi_data_len-1] : 1'b0;
                        o_mosi[3] <= chip_en_reg[3] ? shift_reg_3[spi_data_len-1] : 1'b0;
                        o_mosi[4] <= chip_en_reg[4] ? shift_reg_4[spi_data_len-1] : 1'b0;
                        o_mosi[5] <= chip_en_reg[5] ? shift_reg_5[spi_data_len-1] : 1'b0;
                        o_mosi[6] <= chip_en_reg[6] ? shift_reg_6[spi_data_len-1] : 1'b0;
                        o_mosi[7] <= chip_en_reg[7] ? shift_reg_7[spi_data_len-1] : 1'b0;
                        spi_state <= S_CLOCK_HIGH;
                    end
                end
                
                S_CLOCK_HIGH: begin
                    if (clk_div_cnt < clk_div - 1) begin
                        clk_div_cnt <= clk_div_cnt + 1'b1;
                    end
                    else begin
                        clk_div_cnt <= 0;
                        o_sclk <= 2'b11;
                        
                        // Shift all registers left
                        shift_reg_0 <= {shift_reg_0[spi_data_len-2:0], 1'b0};
                        shift_reg_1 <= {shift_reg_1[spi_data_len-2:0], 1'b0};
                        shift_reg_2 <= {shift_reg_2[spi_data_len-2:0], 1'b0};
                        shift_reg_3 <= {shift_reg_3[spi_data_len-2:0], 1'b0};
                        shift_reg_4 <= {shift_reg_4[spi_data_len-2:0], 1'b0};
                        shift_reg_5 <= {shift_reg_5[spi_data_len-2:0], 1'b0};
                        shift_reg_6 <= {shift_reg_6[spi_data_len-2:0], 1'b0};
                        shift_reg_7 <= {shift_reg_7[spi_data_len-2:0], 1'b0};
                        
                        bit_cnt <= bit_cnt + 1'b1;
                        
                        if (bit_cnt == spi_data_len - 1) begin
                            spi_state <= S_DONE;
                        end
                        else begin
                            spi_state <= S_CLOCK_LOW;
                        end
                    end
                end
                
                S_DONE: begin
                    o_sclk <= 2'b00;
                    o_mosi <= 8'b00000000;
                    o_spi_ready <= 1'b1;
                    spi_state <= S_IDLE;
                end
                
                default: spi_state <= S_IDLE;
            endcase
        end
    end

endmodule