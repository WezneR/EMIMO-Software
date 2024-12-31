module spi_mux
(
    input debug_mode,
    input ext_clk,
    input ext_mosi,
    input ext_cs,
    input usb_clk,
    input usb_mosi,
    input usb_cs,
    output reg int_clk,
    output reg int_mosi,
    output reg int_cs
);

always @(*)
begin
    if(!debug_mode)
    begin
        int_clk=usb_clk;
        int_mosi=usb_mosi;
        int_cs=usb_cs;
    end
    else
    begin
        int_clk=ext_clk;
        int_mosi=ext_mosi;
        int_cs=ext_cs;
    end
end

endmodule