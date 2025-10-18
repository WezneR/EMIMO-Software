function func_clk_sysrefpulse(COM, cnt)
%FUNC_CLK_SYSREFPULSE 控制时钟板发送指定数量的SYSREF脉冲
%   该命令只有在SYSREF模式设置为Pulse模式（mode=2）时才会被时钟板响应。
%   
%   Input
%       - COM: OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - cnt: 整数，脉冲数量控制寄存器值。取值范围0~3，对应实际脉冲数2^cnt个。
%              cnt=0,1,2,3对应1,2,4,8个脉冲。
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

% 验证cnt参数范围
if ~ismember(cnt, 0:3)
    error('cnt参数错误：取值范围应为0~3');
end

% 构造数据包
% Byte2: 00, Byte3: 13, Byte4: 00, Byte5: cnt (十六进制)
cnt_hex = dec2hex(cnt, 2);
Parket = hex2dec(['00'; '13'; '00'; cnt_hex]);

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