`timescale 1ns / 1ps

module UART_Listener#(
    //一次UART通信的最大数据字节数
    parameter uart_max_byte_len = 36
)(
    input wire clk,
    input wire rst_n,
    input wire i_RX_interrupt,
    input wire [5:0] i_receive_data_bytes,
    input wire [uart_max_byte_len*8-1:0] i_receive_data_,
    output reg o_RX_interrupt_clear,
    output reg o_uart_interrupt,
    output reg [31:0] o_uart_data
);

    reg rx_int_pulsed;
    reg uart_int_pulsed;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_RX_interrupt_clear <= 0;
            o_uart_interrupt <= 0;
            o_uart_data <= 0;
            rx_int_pulsed <= 0;
            uart_int_pulsed <= 0;
        end else begin
            // 检测脉冲信号
            rx_int_pulsed <= i_RX_interrupt && !rx_int_pulsed;
            uart_int_pulsed <= rx_int_pulsed && (i_receive_data_bytes == 6) && (i_receive_data_ [uart_max_byte_len*8-1-:16] == 16'h555D);

            // 数据截取
            if (uart_int_pulsed)
                o_uart_data <= i_receive_data_ [(uart_max_byte_len-2)*8-1-:32]; // 取不包含UART_HEAD的32位数据

            // 输出信号
            o_RX_interrupt_clear <= rx_int_pulsed;
            o_uart_interrupt <= uart_int_pulsed;
        end
    end

endmodule