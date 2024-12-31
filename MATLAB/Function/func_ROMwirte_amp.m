function func_ROMwirte_amp(COM, Module_ID, isTX, amp_delta)
%FUNC_ROMWIRTE_AMP 此处显示有关此函数的摘要
%   此处显示详细说明
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口对象；或者包含多个串口对象的结构体。
%       - Module_ID:整数，表示模组ID。从0计数，范围0至15。
%       - isTX:整数，发射或者接收。1表示设备为发射端，0表示设备为接收端。
%       - amp_delta: 8x8矩阵，元素为十进制整数，表示各通道的射频衰减码字。这个矩阵对应一个模组的幅度校准的衰减初值。
% 
%   Output
%       void

UART.Head = hex2dec(['55';'5D']);  
UART.End_mcu = hex2dec(['0A';'0D']);

chip_id_list = double(~isTX) * 4 + (0:3);

for i = 0:7
    for j = chip_id_list
        for ci = 0:1
            Byte2 = [num2str(Module_ID) num2str(i)];
            Byte3 = [num2str(j) '9'];
            Byte4 = ['0' num2str(ci)];
            Byte5 = dec2hex(amp_delta(j*2+ci+1 - 8*double(~isTX), i+1), 2);
            Parket = hex2dec([Byte2; Byte3; Byte4; Byte5]);
            Frame = [UART.Head; Parket; UART.End_mcu];
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
            fprintf("UART已发送十六进制: %s\n", ['55' '5D' Byte2 Byte3 Byte4 Byte5 '0A' '0D'])
            pause(0.1);
        end
    end
end

if isTX
    fprintf('已将TX幅度写入ROM。')
else
    fprintf('已将RX幅度写入ROM。')
end

end

