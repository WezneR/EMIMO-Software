function avg_phase = func_cal_avg_phase(phase)
% FUNC_CAL_AVG_PHASE 计算给定相位的平均值，避免360°环绕问题
% Input:
%   - phase: 浮点数行向量或矩阵，表示需要取平均值的一组相位值，单位为度，范围为(-180, 180]。
% Output:
%   - avg_phase: 浮点数，若输入为行向量则返回一个值，若输入为矩阵则返回列向量，每个元素为对应行的平均相位值，单位为度，范围为(-180, 180]。

% 检查输入是否为空或非数值类型
if isempty(phase) || ~isnumeric(phase)
    error('输入必须是一个非空的数值类型');
end

% 将相位值从度转换为弧度
phase_rad = deg2rad(phase);

% 计算每个相位对应的复数表示 (cos(θ) + j*sin(θ))
complex_vals = cos(phase_rad) + 1i * sin(phase_rad);

% 按行计算复数的平均值
avg_complex = mean(complex_vals, 2);

% 从复数的平均值中提取相位 (使用atan2函数得到[-pi, pi]范围的角度)
avg_phase_rad = angle(avg_complex);

% 将弧度转换为度，并确保返回的结果在(-180, 180]范围内
avg_phase = mod(rad2deg(avg_phase_rad) + 180, 360) - 180;
end
