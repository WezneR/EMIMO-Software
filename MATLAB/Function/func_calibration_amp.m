function [amp_delta, amp_init, sparam_save] = func_calibration_amp(COM, Module_ID, isTX, loop, cal_times, varargin)
%FUNC_CALIBRATION_AMP 设备幅度校准函数
%   本函数用于执行设备通道的幅度校准流程，支持多次迭代校准并记录校准历史数据
%   Input
%       - COM:OpenSerial返回的串口类型，表示设备端口。
%       - Module_ID:整数，表示模组ID。从0计数，范围0至15。
%       - isTX:整数，1表示TX，0表示RX。
%       - loop:整数，选择每次测量读取的次数,取平均值
%       - cal_times:整数，表示连续校准的次数。
%       - varargin:可选参数对，支持'vna_use'参数指定矢量网络分析仪型号
%           - 'vna_use' : 字符串，指定VNA型号（默认'P5005A'）
%   Output
%       - amp_delta : 8x8矩阵，最终幅度校准码字
%       - amp_init  : 三维数组，各次校准前后的初始幅度测量值
%       - sparam_save : 结构体，包含校准前后的完整S参数数据
%           .freq          : 频率向量 (Hz)
%           .Freq_band     : 带内频率索引
%           .Freq_center   : 中心频率索引
%           .mag_before    : 校准前各通道S参数幅度 (线性, numPoints x 8 x 8)
%           .phase_before  : 校准前各通道S参数相位 (弧度, numPoints x 8 x 8)
%           .mag_after     : 校准后各通道S参数幅度 (线性, numPoints x 8 x 8)
%           .phase_after   : 校准后各通道S参数相位 (弧度, numPoints x 8 x 8)
%           .isTX          : TX/RX标志
%           .Sp_label      : S参数标签字符串


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

UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

VNA_Init; %校准文件、频率范围、频点数在这里修改

Freq_MK2_point = 41:161;
Freq_MK_point = 101; % 中心频点索引

% 构建频率向量
freq_vec = linspace(frequencyRange(1), frequencyRange(2), numPoints);

% S12, S21 在 rawData 中的列索引，请在 VNA_Single_Sweep 中检查。
S12_index = 3;
S21_index = 2;
% 转台上的设备接矢网端口1，因此当 isTX = True 时，S21表示增益。否则 S12表示增益。
if isTX
    Sp_index = S21_index;
    Sp_label = 'S21';
else
    Sp_index = S12_index;
    Sp_label = 'S12';
end

VNA_Single_Sweep;%必须先运行一次这个，才可以运行fast

amp_init = zeros(8,8, cal_times + 1);

% ====== 新增：初始化S参数存储数组 ======
sparam_mag_before  = zeros(numPoints, 8, 8);
sparam_phase_before = zeros(numPoints, 8, 8);
sparam_mag_after   = zeros(numPoints, 8, 8);
sparam_phase_after  = zeros(numPoints, 8, 8);
% ==========================================

for t = 1:cal_times
    
    for bi = 0:7 % from board 1 to board 8
        for i = 0:7
            a = zeros(1,loop);
            
            % 打开该通道
            func_channel_switch(COM, Module_ID, bi, i, isTX, 0);
            pause(0.1);
            VNA_Single_Sweep_Fast_loopIndicator.i=t;
            VNA_Single_Sweep_Fast_loopIndicator.j=bi;
            VNA_Single_Sweep_Fast_loopIndicator.k=i;
            % 多次采集取平均
            for j = 1:loop

                VNA_Single_Sweep_Fast;
                a(j) = 20*log10(mean(sparamMag(Freq_MK2_point, Sp_index)));
            end
    
            amp_init(i+1, bi+1, t) = mean(a);
    
            % ====== 新增：保存校准前（第一次迭代）的完整S参数数据 ======
            if t == 1
                sparam_mag_before(:, i+1, bi+1) = sparamMag(:, Sp_index);
                sparam_phase_before(:, i+1, bi+1) = sparamPhase(:, Sp_index);
            end
            % ===========================================================

            % 关闭通道
            func_power_down(COM);
            pause(0.04);
    
        end
    end

    disp(amp_init(:,:, t))
    
    fieldName_TX_last = sprintf('amp_TX_delta_%d', t-1);
    fieldName_TX_new = sprintf('amp_TX_delta_%d', t);
    fieldName_RX_last = sprintf('amp_RX_delta_%d', t-1);
    fieldName_RX_new = sprintf('amp_RX_delta_%d', t);
    
    if t == 1
            old_amp_data = zeros(8,8);
    else
        if isTX
            old_amp_data = history_delta.(fieldName_TX_last);
        else
            old_amp_data = history_delta.(fieldName_RX_last);
        end
    end

    amp_delta = func_compute_amp_delta(amp_init(:,:, t), old_amp_data);

    if isTX
        history_delta.(sprintf(fieldName_TX_new)) = amp_delta;
    else
        history_delta.(sprintf(fieldName_RX_new)) = amp_delta;
    end


    chip_id_list = double(~isTX) * 4 + (0:3);

    for i = 0:7
        for j = chip_id_list
            for ci = 0:1
                func_ps_att_write(COM, Module_ID, i, j, ci, dec2hex(amp_delta(j*2+ci+1 - 8*double(~isTX), i+1), 2));
                pause(0.04);
            end
        end
    end

% 循环下一次校准
end

% 校准完测试一次
for bi = 0:7 % from board 1 to board 8
    for i = 0:7
        a = zeros(1,loop);
        
        % 打开该通道
        func_channel_switch(COM, Module_ID, bi, i, isTX, 0);
        pause(0.1);
        VNA_Single_Sweep_Fast_loopIndicator.i= cal_times + 1;
        VNA_Single_Sweep_Fast_loopIndicator.j=bi;
        VNA_Single_Sweep_Fast_loopIndicator.k=i;
        % 多次采集取平均
        for j = 1:loop

            VNA_Single_Sweep_Fast;
            a(j) = 20*log10(mean(sparamMag(Freq_MK2_point, Sp_index)));
        end

        amp_init(i+1, bi+1, cal_times + 1) = mean(a);

        % ====== 新增：保存幅度校准后的完整S参数数据 ======
        sparam_mag_after(:, i+1, bi+1) = sparamMag(:, Sp_index);
        sparam_phase_after(:, i+1, bi+1) = sparamPhase(:, Sp_index);
        % ===================================================

        % 关闭通道
        func_power_down(COM);
        pause(0.2);
    end
end

% ====== 新增：构建S参数保存结构体 ======
sparam_save.freq         = freq_vec;
sparam_save.Freq_band    = Freq_MK2_point;
sparam_save.Freq_center  = Freq_MK_point;
sparam_save.mag_before   = sparam_mag_before;
sparam_save.phase_before = sparam_phase_before;
sparam_save.mag_after    = sparam_mag_after;
sparam_save.phase_after  = sparam_phase_after;
sparam_save.isTX         = isTX;
sparam_save.Sp_label     = Sp_label;
% ==========================================

%% 保存文件

if isTX
    fileName=['mat\calibration\history\M' num2str(Module_ID, '%02d') '_amp_TX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
else
    fileName=['mat\calibration\history\M' num2str(Module_ID, '%02d') '_amp_RX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
end

save(fileName,'history_delta');

% ====== 新增：保存完整S参数数据 ======
if isTX
    sparam_fileName = ['mat\calibration\history\M' num2str(Module_ID, '%02d') '_amp_TX_sparam' char(datetime('now','Format','yMdHHmm')) '.mat'];
else
    sparam_fileName = ['mat\calibration\history\M' num2str(Module_ID, '%02d') '_amp_RX_sparam' char(datetime('now','Format','yMdHHmm')) '.mat'];
end
save(sparam_fileName, 'sparam_save');
% ======================================

% Function end
end