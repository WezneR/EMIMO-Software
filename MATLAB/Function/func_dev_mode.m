function func_dev_mode(COM, DEV_MODE_on)
%FUNC_DEV_MODE 此处显示有关此函数的摘要
%   控制所有模组打开或关闭开发者模式
%   此处显示详细说明
%   
%   调用此函数前：
%       - 确认已经连接到设备串口，确认串口指令是可用的。
% 
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - DEV_MODE_on:整数，打开或者关闭开发者模式。1表示进入开发者模式，0表示设退出开发者模式。
%
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);

if DEV_MODE_on
    Byte5 = '01';
else
    Byte5 = '00';
end

Parket = hex2dec(['08';'00';'00';Byte5;'0A';'0D']);
Frame = [UART.Head; Parket];

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