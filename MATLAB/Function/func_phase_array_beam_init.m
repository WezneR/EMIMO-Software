function func_phase_array_beam_init(COM)
%FUNC_PHASE_ARRAY_BEAM_INIT 
%   阵面波数初始化为校准状态。初始化完成后波数指向为法向。
%
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);
Parket = hex2dec(['08';'01';'00';'00']);
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

