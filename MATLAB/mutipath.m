% 定义示例频率和S参数
isTX = 1;
numPoints = 201;
freq_start = 2.7e9; % 起始频率 (Hz)
freq_stop = 3.2e9;  % 终止频率 (Hz)
freq = linspace(freq_start, freq_stop, numPoints)'; % 频率向量，确保为列向量

[amp_init, phase_init] = func_OTAmeasure_module(isTX);

% 构造复数S参数
S_complex = 10.^(amp_init / 20) .* exp(1j * phase_init); % 201x1 列向量

% 时域转换
bandwidth = freq_stop - freq_start;
time = linspace(0, 1 / bandwidth, numPoints); % 时域采样点
time_domain = ifft(S_complex, 'symmetric'); % 时域信号

% 解环绕相位
phase_unwrapped = unwrap(phase_init * pi / 180) * 180 / pi; % 解环绕并转为度

% 绘制原始相位和解环绕后的相位
figure;

% 原始相位
subplot(2, 2, 4);
plot(freq / 1e9, phase_unwrapped, '-o');
xlabel('Frequency (GHz)');
ylabel('Phase (°)');
title('Phase');
grid on;

% 频域响应
subplot(2, 2, 1);
plot(freq / 1e9, 20 * log10(abs(S_complex)));
xlabel('Frequency (GHz)');
ylabel('Magnitude (dB)');
title('Frequency Domain Response');

% 时域响应
subplot(2, 2, 2);
plot(time * 1e9, abs(time_domain));
xlabel('Time (ns)');
ylabel('Amplitude');
title('Time Domain Response (Single Path)');
grid on;

% 极坐标绘图
subplot(2, 2, 3);
polarplot(angle(S_complex), abs(S_complex), '-o');
title('S\_complex in Polar Coordinates');
