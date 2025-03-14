`timescale 1ns / 1ps

module CTRL_switch(
    input wire i_SEL,
    input wire [31:0] i_spi_data,
    input wire i_spi_interrupt,
    input wire [31:0] i_uart_data,
    input wire i_uart_interrupt,
    output reg [31:0] o_ctrl_data,
    output reg o_ctrl_interrupt
);

    always @(*) begin
        if (i_SEL) begin
            o_ctrl_data = i_uart_data;
            o_ctrl_interrupt = i_uart_interrupt;
        end else begin
            o_ctrl_data = i_spi_data;
            o_ctrl_interrupt = i_spi_interrupt;
        end
    end

endmodule