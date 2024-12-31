function amp_delta = func_compute_amp_delta(amp_init, old_amp_delta)
%FUNC_COMPUTE_AMP_DELTA 此处显示有关此函数的摘要
% 根据测量的通道增益，上次校准的通道衰减以及衰减器精度，计算出每个通道需要的衰减码字
%   此处显示详细说明

amp_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        amp_delta(i,j) = round((amp_init(i,j)-min(amp_init(:)))./0.12);
    end
end

amp_delta = amp_delta + old_amp_delta;

amp_delta = amp_delta - min(amp_delta(:));

if max(max(amp_delta)) > 127
    warndlg('通道增益差值超出校准范围！');
end

