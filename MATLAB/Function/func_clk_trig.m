function func_clk_trig(COM, dist, argin)
%FUNC_CLK_TRIG 发送trig_out电平或者发送trig_in正脉冲
%   此处显示详细说明
%   Input
%       - COM: OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - dist: 整数，0表示控制trig_out；1表示控制trig_in。
%       - argin: 字符串，控制命令。'ON'表示高电平，'OFF'表示低电平，'Pulse'表示正脉冲。
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

% 根据dist和argin参数构造数据包
switch dist
    case 0  % 控制trig_out
        switch upper(argin)
            case 'ON'
                Parket = hex2dec(['00'; '01'; '00'; '01']);
            case 'OFF'
                Parket = hex2dec(['00'; '01'; '00'; '00']);
            otherwise
                error('argin参数错误：对于trig_out，argin应为''ON''或''OFF''');
        end
        
    case 1  % 控制trig_in
        if strcmpi(argin, 'Pulse')
            Parket = hex2dec(['00'; '12'; '00'; '00']);
        else
            error('argin参数错误：对于trig_in，argin应为''Pulse''');
        end
        
    otherwise
        error('dist参数错误：应为0（trig_out）或1（trig_in）');
end

% 构造完整帧
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