

%% 加载幅度数据并绘图
addpath(genpath('mat/SubArrayTest'));
freqRange = linspace(2.7e9, 3.2e9, 201);
Freq_MK2_point = 1:201;
Freq_MK3_point = 21:181; % 2.75 ~ 3.15

faxis = freqRange(Freq_MK2_point);
f_inband = freqRange(Freq_MK3_point);

%% 幅度绘图

% load('M0B5_RX_amp_202601062324.mat')
% load('M0B5_TX_amp_202601070341.mat')
% load('M0B3_RX_amp_202601070501.mat')
% load('M0B3_TX_amp_202601070421.mat') % B3 TX Ob1 （怀疑是测试问题，重测问题消失）
% load('M0B3_TX_amp_202601070438.mat')
% load('M0B2_RX_amp_202601070709.mat') % B2 RX Ob1 （怀疑是测试问题，重测发现确实是通道有问题）
% load('M0B2_RX_amp_202601070728.mat')
% load('M0B2_TX_amp_202601070552.mat')
% load('M0B6_RX_amp_202601070757.mat')
% load('M0B6_TX_amp_202601070818.mat') % B6 TX Ob1 （与B3相同的异常，重测问题消失）
% load('M0B6_TX_amp_202601070836.mat')
% load('M0B4_RX_amp_202601080058.mat')
% load('M0B4_TX_amp_202601080037.mat')
% load('M0B1_RX_amp_202601080328.mat')
% load('M0B1_TX_amp_202601080352.mat')
% load('M0B0_RX_amp_202601090625.mat')
% load('M0B0_TX_amp_202601090606.mat')
% load('M0B7_RX_amp_202601090652.mat')
load('M0B7_TX_amp_202601090737.mat')



atten_ASB = uint8(0:4:255);

[N_freq_p, N_amp_test, N_channel] = size(amp)

if N_freq_p ~= length(Freq_MK2_point)
    error('矢网测量的频点数和绘图频点数不一致');
end

if N_amp_test ~= length(atten_ASB)
    error('幅度控制字的个数和绘图的样本数不一致');
end



figure;

for Channel_i = 0:7
    % 2行4列布局
    subplot(2,4,Channel_i+1)

    hold on;
    for atten_j = 1:N_amp_test
        plot(faxis, amp(:, atten_j, Channel_i+1));
    end
    title(['CH' num2str(Channel_i) '的不同衰减控制字下的增益'])
    xlabel('Freq(Hz)')
    ylabel('Phase(rad)')
end




amp_freqavg = mean(amp(Freq_MK3_point, :, :), 1);

figure('Position', [200, 100, 1200, 900]);

hold on;

legends = cell(1, N_channel);
for Channel_i = 0:7
    legends{Channel_i+1} = ['CH' num2str(Channel_i)];
    plot(atten_ASB, amp_freqavg(1,:,Channel_i+1))
end
title('不同通道的频带内平均增益随控制字的变化');
xlabel('ASB(uint8)');
ylabel('avg Gain(dB)');

lg = legend(legends, 'Location', 'bestoutside');
lg.ItemHitFcn=@HitCallbackFcn;

amp_attenfreqavg = mean(amp_freqavg, 2);

%% 相位绘图

% load('M0B5_RX_pha_202601062331.mat')
% load('M0B5_TX_pha_202601070348.mat')
% load('M0B3_RX_pha_202601070508.mat')
% load('M0B3_TX_pha_202601070428.mat') % B3 TX Ob1 （怀疑是测试问题，重测问题消失）
% load('M0B3_TX_pha_202601070445.mat')
% load('M0B2_RX_pha_202601070716.mat') % B2 RX Ob1 （怀疑是测试问题，重测发现确实是通道有问题）
% load('M0B2_RX_pha_202601070735.mat')
% load('M0B2_TX_pha_202601070559.mat')
% load('M0B6_RX_pha_202601070804.mat')
% load('M0B6_TX_pha_202601070825.mat') % B6 TX Ob1 （与B3相同的异常，重测问题消失）
% load('M0B6_TX_pha_202601070843.mat')
% load('M0B4_RX_pha_202601080105.mat')
% load('M0B4_TX_pha_202601080044.mat')
% load('M0B1_RX_pha_202601080335.mat')
% load('M0B1_TX_pha_202601080400.mat')
% load('M0B0_RX_pha_202601090632.mat')
% load('M0B0_TX_pha_202601090613.mat')
% load('M0B7_RX_pha_202601090659.mat')
load('M0B7_TX_pha_202601090744.mat')


phase_PSB = uint8(0:4:255);


[N_freq_p, N_phase_test, N_channel] = size(pha)


if N_phase_test ~= length(phase_PSB)
    error('幅度控制字的个数和绘图的样本数不一致');
end



figure('Position', [200, 100, 1200, 900]);
hold on;
for Channel_i = 0:7
    legends{Channel_i+1} = ['CH' num2str(Channel_i)];
    plot(phase_PSB, pha(ceil(N_freq_p/2), :, Channel_i+1))
end
title('不同通道中心频点处S参数相位与相位控制字的关系')
xlabel('PSB(uint8)')
ylabel('phase @fc (deg)')

lg = legend(legends, 'Location', 'bestoutside');
lg.ItemHitFcn=@HitCallbackFcn;



% 在'不同相位控制字下的S参数相位(解绕卷)'的基础上，补偿群延时
% 首先提取群延时：对不同相位控制字平均，得到 avg phase vs freq
phase_avgPSB = mean(unwrap(deg2rad(pha(:, :, 1))), 2); % 在计算群延时时以CH0为基准

% 左上角的起点位置
x1 = faxis(Freq_MK3_point(1));
y1 = phase_avgPSB(Freq_MK3_point(1));
% 右下角的终点位置
x2 = faxis(Freq_MK3_point(end));
y2 = phase_avgPSB(Freq_MK3_point(end));

groupDelay = -(y2-y1)/(x2-x1);

figure;
for Channel_i = 0:7
    % 2行4列布局
    subplot(2,4,Channel_i+1)

    hold on;
    
    for phase_j = 1:N_phase_test
        plot(faxis, unwrap(deg2rad(pha(:, phase_j, Channel_i+1))) + reshape((faxis-faxis(Freq_MK3_point(1))).*groupDelay, [N_freq_p, 1]));
    end
    title(['CH' num2str(Channel_i) '的不同相位控制字下的S参数相位(解绕卷&补偿群延时)'])
    xlabel('Freq(Hz)')
    ylabel('Phase(rad)')
end


%% 加载相位数据并绘图

function HitCallbackFcn(src,evnt) % 当点击图例后执行的自定义函数
    if strcmp(evnt.Peer.Visible,'on')
        evnt.Peer.Visible = 'off';
    else
        evnt.Peer.Visible = 'on';
    end
end