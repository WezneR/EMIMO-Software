`timescale 1ns / 1ps

module LED_control(
    input  TX_ON_B1,
    input  RX_ON_B1,
    output reg TX_LED,
    output reg RX_LED
);

always @* begin
    // TX逻辑：任一Bank使能则点亮 
    if (TX_ON_B1 == 1) begin
        TX_LED = 1;
    end else begin
        TX_LED = 0;
    end

    // RX逻辑：任一Bank使能则点亮 
    if (RX_ON_B1 == 1) begin
        RX_LED = 1;
    end else begin
        RX_LED = 0;
    end
end

endmodule