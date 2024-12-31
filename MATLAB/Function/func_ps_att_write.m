function func_ps_att_write(COM, Module_ID, Board_ID, PS_Chip_ID, Channel_id, att)
%FUNC_PS_ATT_WRITE 此处显示有关此函数的摘要
%  调用此函数前：
%       - 确认已经连接到设备串口，确认串口指令是可用的。
%
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - Module_ID:整数，表示模组ID。从0计数，范围0至15。
%       - Board_ID:整数，表示板子ID。从0计数，范围0至8。为8表示选中所有模组的所有板子。
%       - PS_Chip_ID:移相器芯片ID，从0计数，范围0至8。0至3被用于TX0至TX7通道的幅相控制，4至7被用于RX0至RX7通道的幅相控制，8表示选中所有通道。
%       - Channel_id:整数，按顺序是0或者1，每个PS_Chip_ID有两个Channel。
%       - att: 1x2 char数组，相移的控制字。 
%   Output
%       void


UART.Head = hex2dec(['55';'5D']); 
UART.End = hex2dec(['0D';'0A']);

genernal_BID = bitshift(Module_ID, 4) + Board_ID;
Byte2 = dec2hex(genernal_BID, 2);

Byte3 = dec2hex(bitshift(PS_Chip_ID, 4) + 3, 2);

Byte4 = dec2hex(Channel_id,2);

Byte5 = att;
Parket = hex2dec([Byte2; Byte3; Byte4; Byte5]);
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

fprintf("UART已发送十六进制: %s\n", ['55' '5D' Byte2 Byte3 Byte4 Byte5 '0D' '0A'])
end
