function func_clk_sysrefmode(COM, mode)
%FUNC_CLK_SYSREFMODE 控制时钟板的SYSREF逻辑模式
%   此处显示详细说明
%   Input
%       - COM: OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - mode: 整数，SYSREF模式选择。2表示Pulse模式，3表示连续SYSREF模式。
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

% 根据mode参数构造数据包
switch mode
    case 2  % SYSREF Pulse模式
        Parket = hex2dec(['00'; '03'; '00'; '02']);
    case 3  % 连续SYSREF模式
        Parket = hex2dec(['00'; '03'; '00'; '03']);
    otherwise
        error('mode参数错误：应为2（Pulse模式）或3（连续SYSREF模式）');
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