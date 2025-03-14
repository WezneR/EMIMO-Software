`timescale 1ns / 1ps

module LED_control(
    input  TX_ON_B1,
    input  RX_ON_B1,
    output TX_LED,
    output RX_LED
);

// TX逻辑：任一Bank使能则点亮 
assign TX_LED = TX_ON_B1;

// RX逻辑：任一Bank使能则点亮 
assign RX_LED = RX_ON_B1;

endmodule