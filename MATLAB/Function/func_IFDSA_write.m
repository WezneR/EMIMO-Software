function func_IFDSA_write(COM, isTX, att_byte)
%FUNC_IFDSA_WRITE 同步控制所有模组的中频增益
%   此处显示详细说明
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - isTX:整数，1表示TX，0表示RX。
%       - att_byte: 1x2 char数组，增益控制字。范围为'00'~'7F'，映射到 0dB ~ 31.5dB。
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

Byte2 = '08';

% TX下为0A，RX下为1A
Byte3 = dec2hex(bitshift(double(~isTX), 4) + 10, 2);

Byte4 = att_byte;

Parket = hex2dec([Byte2; Byte3; '01'; Byte4]);

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

