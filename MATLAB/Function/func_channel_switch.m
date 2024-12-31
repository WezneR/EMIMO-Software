function func_channel_switch(COM, Module_ID, Board_ID, FEM_Chip_ID, isTX, PD)
%FUNC_CHANNEL_SWITCH 此处显示有关此函数的摘要
%   选中模组和板子中特定的通道，控制其工作状态：TX,RX,关闭。
%   此处显示详细说明
%   
%   调用此函数前：
%       - 确认已经连接到设备串口，确认串口指令是可用的。
%       - 确认进入开发者模式(DEV_MODE=1)，FPGA只允许在开发者模式下使用软件控制通道状态。
%           否则，只能通过硬件上的TX_ON和RX_ON连线的电平来控制通道状态。
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - Module_ID:整数，表示模组ID。从0计数，范围0至15。
%       - Board_ID:整数，表示板子ID。从0计数，范围0至8。为8表示选中所有模组的所有板子。
%       - FEM_Chip_ID:整数， 通道ID，从0计数，范围0至8。为8表示选中所有通道。
%       - isTX:整数，发射或者接收。1表示设备为发射端，0表示设备为接收端。
%       - PD:整数，待机。1表示关闭选中的通道，0表示正常（不进行额外的操作）。
%
%   Output
%       void


UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

genernal_BID = bitshift(Module_ID, 4) + Board_ID;
Byte2 = dec2hex(genernal_BID, 2);

Byte3 = dec2hex(bitshift(FEM_Chip_ID, 4) + 4, 2);

if PD
    Parket = hex2dec([Byte2; Byte3 ;'00';'00']);
else
    if isTX
        Parket = hex2dec([Byte2; Byte3 ;'02';'00']);
    else
        Parket = hex2dec([Byte2; Byte3;'01';'00']);
    end
end

Frame = [UART.Head; Parket; UART.End];

% 判断 COM 是单个串口对象还是多个串口组成的结构体
if isstruct(COM)  % 如果 COM 是结构体，说明有多个串口
    % 使用 serial_hub_write 向每个串口发送数据
    serial_hub_write(COM, Frame);
elseif isobject(COM)  % 如果 COM 是单个串口对象
    % 直接向该串口发送数据
    fwrite(COM, Frame);
else
    % COM 既不是结构体也不是串口对象，抛出错误
    error('COM 应该是串口对象或包含多个串口对象的结构体');
end

end

