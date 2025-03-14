//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: ???
// Design Name: 
// Module Name: spi_listener
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
// 
// 2024年10月23日21:54:45
// Revision v3 （已弃用）：修改了帧格式定义，因此弃用
// 
// 
// 2024年10月24日13:46:46
// Revision v4（当前版本）：
//      接收4个字节并拼接成32位数据发送给process
// 
//////////////////////////////////////////////////////////////////////////////////
module spi_listener #(
    parameter listener_timeout=2000
)
(
    input clk,
    input spi_slave_data_valid,
    input [7:0] spi_slave_byte,
    output reg [31:0] spi_data,
    output reg spi_listener_interrupt=0
);

reg timeout=0;
reg [15:0] timeout_cnt=0;
reg [1:0] spi_byte_cnt=0;
reg [7:0] spi_slave_bytes [0:2];

always @(posedge clk)
begin
    if(spi_slave_data_valid)
    begin
        case(spi_byte_cnt)
        0:
        begin
            spi_slave_bytes[0]<=spi_slave_byte;
            spi_byte_cnt<=1;
        end
        1:
        begin
            spi_slave_bytes[1]<=spi_slave_byte;
            spi_byte_cnt<=2;
        end
        2:
        begin
            spi_slave_bytes[2]<=spi_slave_byte;
            spi_byte_cnt<=3;
        end
        3:
        begin
            spi_data<={spi_slave_bytes[0], spi_slave_bytes[1], spi_slave_bytes[2], spi_slave_byte};
            spi_listener_interrupt<=1;
            spi_byte_cnt<=0;
        end
        endcase
    end
    else
        spi_listener_interrupt<=0;

    if(timeout&&spi_byte_cnt!=0)
        spi_byte_cnt<=0;
end

always @(posedge clk)
begin
    if(spi_slave_data_valid)
    begin
        timeout<=0;
        timeout_cnt<=0;
    end
    else if(timeout_cnt==listener_timeout)
        timeout<=1;
    else
        timeout_cnt<=timeout_cnt+1;
end

endmodule