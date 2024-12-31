function [phase_delta, phase_init] = func_calibration_phase(COM, Module_ID, isTX, cal_times)
%FUNC_CALIBRATION_PHASE 校准相位
%   此处显示详细说明


UART.Head = hex2dec(['55';'5D']);  
UART.End = hex2dec(['0D';'0A']);

VNA_Init_3672E; %校准文件、频率范围、频点数在这里修改

Freq_MK_point = 101; %取2.95GHz处的值

loop = 1;%选择每次测量读取的次数,取平均值

history_delta = struct();

% S12, S21 在 rawData 中的列索引，请在 VNA_Single_Sweep_3672E 中检查。
S12_index = 3;
S21_index = 2;
% 转台上的设备接矢网端口1，因此当 isTX = True 时，S21表示增益。否则 S12表示增益。
if isTX
    Sp_index = S21_index;
else
    Sp_index = S12_index;
end

VNA_Single_Sweep_3672E;%必须先运行一次这个，才可以运行fast

phase_init = zeros(8,8, cal_times + 1);

for t = 1:cal_times
    for bi = 0:7 % from board 1 to board 8
        for i = 0:7
            p = zeros(1,loop);
            % 打开该通道
            func_channel_switch(COM, Module_ID, bi, i, isTX, 0);
            pause(0.02);
            VNA_Single_Sweep_3672E_Fast_loopIndicator.i=t;
            VNA_Single_Sweep_3672E_Fast_loopIndicator.j=bi;
            VNA_Single_Sweep_3672E_Fast_loopIndicator.k=i;
            % 多次采集取平均
            for j = 1:loop
                VNA_Single_Sweep_3672E_Fast;
                p(j) = sparamPhase(Freq_MK_point, Sp_index)/pi*180;
            end
    
            phase_init(i+1,bi+1, t) = mean(p);
    
            % 关闭通道
            func_power_down(COM);
            pause(0.02);
        end
    end
    disp(phase_init(:,:,t));

    fieldName_TX_last = sprintf('phase_TX_delta_%d', t-1);
    fieldName_TX_new = sprintf('phase_TX_delta_%d', t);
    fieldName_RX_last = sprintf('phase_RX_delta_%d', t-1);
    fieldName_RX_new = sprintf('phase_RX_delta_%d', t);
    
    if t == 1
            old_phase_data = zeros(8,8);
    else
        if isTX
            old_phase_data = history_delta.(fieldName_TX_last);
        else
            old_phase_data = history_delta.(fieldName_RX_last);
        end
    end

    phase_delta = func_compute_phase_delta(phase_init(:,:,t), old_phase_data);

    if isTX
        history_delta.(fieldName_TX_new) = phase_delta;
    else
        history_delta.(fieldName_RX_new) = phase_delta;
    end


    chip_id_list = double(~isTX) * 4 + (0:3);

    for i = 0:7
        for j = chip_id_list
            for ci = 0:1
                func_ps_phase_write(COM, Module_ID, i, j, 0, ci, dec2hex(phase_delta(j*2+ci+1 - 8*double(~isTX), i+1),2));
                pause(0.04);
                func_ps_lacth_phase(COM);
                pause(0.04);
            end
        end
    end

% 循环，下一次校准
end

% 校准完测试一次
for bi = 0:7 % from board 1 to board 8
    for i = 0:7
        p = zeros(1,loop);
        % 打开该通道
        func_channel_switch(COM, Module_ID, bi, i, isTX, 0);
        pause(0.1);
        VNA_Single_Sweep_3672E_Fast_loopIndicator.i= cal_times + 1;
        VNA_Single_Sweep_3672E_Fast_loopIndicator.j=bi;
        VNA_Single_Sweep_3672E_Fast_loopIndicator.k=i;
        % 多次采集取平均
        for j = 1:loop
            VNA_Single_Sweep_3672E_Fast;
            p(j) = sparamPhase(Freq_MK_point, Sp_index)/pi*180;
        end

        phase_init(i+1,bi+1, cal_times + 1) = mean(p);

        % 关闭通道
        func_power_down(COM);
        pause(0.1);
    end
end
%% 保存文件

if isTX
    fileName=['mat\calibration\history\M' num2str(Module_ID, '%02d') '_phase_TX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
else
    fileName=['mat\calibration\history\M' num2str(Module_ID, '%02d') '_phase_RX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
end

save(fileName,'history_delta');

% Function end
end


