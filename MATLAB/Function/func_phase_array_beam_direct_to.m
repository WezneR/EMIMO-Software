function func_phase_array_beam_direct_to(COM, ang_azimuth, ang_pitch)
%FUNC_PHASE_ARRAY_BEAM_DIRECT_TO 
%   控制阵面波束指向。
%   此处显示详细说明
%   
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - ang_azimuth:整数，阵面波束指向的方位角。范围-90至90。以偏向0号板子的方向为负。
%       - ang_pitch:整数，阵面波束指向的俯仰角。范围-90至90。以偏向0号阵元的方向为负。
%   
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

Byte4 = dec2hex(round(ang_azimuth/(180/256)),2);
Byte5 = dec2hex(round(ang_pitch/(180/256)),2);
Parket = hex2dec(['08';'00';Byte4;Byte5]);
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

