function [time_domain, delays, multipath_gains] = func_multipath_analysis(freq, amp_init, phase_init)
%FUNC_MULTIPATH_ANALYSIS 对空口S参数进行时域多径分析
% Input:
%   - freq: numPoints x 1 列向量，频率点，单位Hz。
%   - amp_init: numPoints x 1 列向量，表示各频点上的S参数幅值，单位dB。
%   - phase_init: numPoints x 1 列向量，表示各频点上的S参数相位，单位度。
% Output:
%   - time_domain: numPoints x 1 列向量，时域信号。
%   - delays: 多径分量的时延（单位：ns）。
%   - multipath_gains: 多径分量的增益（单位：dB）。

% 转换S参数为复数形式
S_complex = 10.^(amp_init / 20) .* exp(1j * phase_init * pi / 180);

% 计算带宽和时域采样
freq_start = freq(1);
freq_stop = freq(end);
bandwidth = freq_stop - freq_start; % 总带宽
numPoints = length(freq);
time = linspace(0, 1 / bandwidth, numPoints); % 时域采样点

% 对S参数进行iFFT
time_domain = ifft(S_complex, 'symmetric'); % 时域信号

% 分析多径分量
[multipath_gains, peak_indices] = findpeaks(abs(time_domain), 'MinPeakHeight', 0.1 * max(abs(time_domain)));
delays = (peak_indices - 1) * (1 / bandwidth) * 1e9; % 转换为时延（ns）

% 绘制时域响应
figure;
plot(time * 1e9, abs(time_domain));
hold on;
scatter(delays, multipath_gains, 'r', 'filled');
xlabel('Time (ns)');
ylabel('Amplitude');
title('Time Domain Response (Multipath Analysis)');
grid on;

end
