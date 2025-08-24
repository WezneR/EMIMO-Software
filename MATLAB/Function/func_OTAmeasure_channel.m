function [amp_init, phase_init] = func_OTAmeasure_channel(COM, Module_ID, isTX, varargin)
%FUNC_OTAMEASURE_CHANNEL 此处显示有关此函数的摘要
%       测量单个模组64通道的空口增益和各通道相位。
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口。
%       - Module_ID:整数，表示模组ID。从0计数，范围0至15。
%       - isTX:整数，1表示TX，0表示RX。
%       - varargin: 可选参数，包括 'vna_use'。
%   Output
%       void

% board0      board1      board2      ......      board7
%    #0          #0
%    #1
%     ...
%    #7

% 如果沒有指定VNA_USE，默認使用VNA_USE='P5005A'
VNA_USE = 'P5005A';
% 解析可选参数
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'vna_use'
            VNA_USE = varargin{i+1};
        otherwise
            error('Unknown optional parameter: %s', varargin{i});
    end
end

VNA_Init; %校准文件、频率范围、频点数在这里修改
numPoints=201; 
frequencyRange = [2.7e9 3.2e9];
freq_MK_range = 41:1:161;
freq_MK_center = 101; % 取2.95GHz处的值
freq_MK_lower = 41;
freq_MK_higher = 161;

loop = 1; % VNA连续测量的次数
phase_init = zeros(8,8,4);
amp_init = zeros(8,8,4);

VNA_Single_Sweep;%必须先运行这个，才可以运行fast
pause(0.1);


if isTX
    sp = 2;
else
    sp = 3;
end

for bi = 0:7 % from board 1 to board 8
    for i = 0:7
        a1 = zeros(1,loop);
        a2 = zeros(1,loop);
        a3 = zeros(1,loop);
        a4 = zeros(1,loop);
        p1 = zeros(1,loop);
        p2 = zeros(1,loop);
        p3 = zeros(1,loop);
        p4 = zeros(1,loop);

        func_channel_switch(COM, Module_ID, bi, i, isTX, 0);
        pause(0.1);

        VNA_Single_Sweep_Fast_loopIndicator.j=bi;
        VNA_Single_Sweep_Fast_loopIndicator.k=i;
        for j = 1:loop
            VNA_Single_Sweep_Fast;
            a1(j) = 20*log10(mean(sparamMag(freq_MK_range,sp)));
            a2(j) = 20*log10(mean(sparamMag(freq_MK_center,sp)));
            a3(j) = 20*log10(mean(sparamMag(freq_MK_lower,sp)));
            a4(j) = 20*log10(mean(sparamMag(freq_MK_higher,sp)));
            % p1(j) = sparamPhase(freq_MK_range,sp)/pi*180; % 相位不能简单相加
            p2(j) = sparamPhase(freq_MK_center,sp)/pi*180;
            p3(j) = sparamPhase(freq_MK_lower,sp)/pi*180;
            p4(j) = sparamPhase(freq_MK_higher,sp)/pi*180;
        end
            amp_init(i+1, bi+1, 1) = sum(a1)/loop;
            amp_init(i+1, bi+1, 2) = sum(a2)/loop;
            amp_init(i+1, bi+1, 3) = sum(a3)/loop;
            amp_init(i+1, bi+1, 4) = sum(a4)/loop;
            % phase_init(i+1, bi+1, 1) = sum(p1)/loop;
            phase_init(i+1, bi+1, 2) = sum(p2)/loop;
            phase_init(i+1, bi+1, 3) = sum(p3)/loop;
            phase_init(i+1, bi+1, 4) = sum(p4)/loop;
        % close all channels of all boards
        func_channel_switch(COM, 0, 8, 8, isTX, 1);
        pause(0.1);
    end
end

end

