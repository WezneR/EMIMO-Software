function func_plot_calibration_results(sparam_before, sparam_after, Module_ID)
%FUNC_PLOT_CALIBRATION_RESULTS 绘制校准前后的S参数对比图
%   本函数用于绘制校准前后64通道的幅度/相位分布图及箱型图
%   Input
%       - sparam_before : 结构体，校准前的S参数数据（来自func_calibration_amp的sparam_save）
%           包含字段: freq, Freq_band, Freq_center, mag_before, phase_before, isTX, Sp_label
%       - sparam_after  : 结构体，全部校准后的S参数数据（来自func_calibration_phase的sparam_save）
%           包含字段: freq, Freq_band, Freq_center, mag_after, phase_after, isTX, Sp_label
%       - Module_ID     : 整数，模组ID，用于标题标注
%
%   Output
%       void（生成Figure 1 ~ Figure 8）

%% 提取公共参数
freq       = sparam_before.freq;             % 频率向量 (Hz)
freq_GHz   = freq / 1e9;                     % 转换为GHz
Freq_band  = sparam_before.Freq_band;        % 带内频率索引
Freq_center = sparam_before.Freq_center;     % 中心频率索引
Sp_label   = sparam_before.Sp_label;         % S参数标签 (S21或S12)
isTX       = sparam_before.isTX;

if isTX
    TXRX_str = 'TX';
else
    TXRX_str = 'RX';
end

% 提取带内频率
freq_band_GHz = freq_GHz(Freq_band);

% 校准前数据（来自幅度校准函数的第一次测量）
mag_before_lin   = sparam_before.mag_before;    % (numPoints, 8, 8), 线性
phase_before_rad = sparam_before.phase_before;  % (numPoints, 8, 8), 弧度

% 全部校准后数据（来自相位校准函数的最终测量）
mag_after_lin    = sparam_after.mag_after;      % (numPoints, 8, 8), 线性
phase_after_rad  = sparam_after.phase_after;    % (numPoints, 8, 8), 弧度

% 转换为dB和度
mag_before_dB  = 20 * log10(mag_before_lin);   % (numPoints, 8, 8)
mag_after_dB   = 20 * log10(mag_after_lin);

phase_before_deg = phase_before_rad / pi * 180; % 绕卷相位 (度)
phase_after_deg  = phase_after_rad / pi * 180;

% 解绕卷相位：对每个通道沿频率方向进行unwrap
phase_before_unwrap_deg = zeros(size(phase_before_rad));
phase_after_unwrap_deg  = zeros(size(phase_after_rad));
for bi = 1:8
    for ci = 1:8
        phase_before_unwrap_deg(:, ci, bi) = unwrap(phase_before_rad(:, ci, bi)) / pi * 180;
        phase_after_unwrap_deg(:, ci, bi)  = unwrap(phase_after_rad(:, ci, bi)) / pi * 180;
    end
end

% 定义颜色映射，用于区分不同板子的通道
board_colors = lines(8);

%% ========== Figure 1: 校准前 64通道带内增益幅度 vs 频率 ==========
figure('Name', 'Fig1_Amp_Before', 'NumberTitle', 'off');
hold on;
h_legend = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, mag_before_dB(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}|' Sp_label '| \fontname{宋体}幅度 \fontname{Times New Roman}(dB)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准前 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益幅度'], 'Interpreter', 'tex', 'FontSize', 13);
legend_str = cell(8, 1);
for bi = 1:8
    legend_str{bi} = ['Board ' num2str(bi-1)];
end
legend(h_legend, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 2: 校准前 64通道带内增益相位（绕卷）vs 频率 ==========
figure('Name', 'Fig2_Phase_Wrapped_Before', 'NumberTitle', 'off');
hold on;
h_legend2 = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, phase_before_deg(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend2(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}\angle' Sp_label ' \fontname{宋体}相位 \fontname{Times New Roman}(deg)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准前 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益相位（绕卷）'], 'Interpreter', 'tex', 'FontSize', 13);
legend(h_legend2, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 3: 校准前 64通道带内增益相位（解绕卷）vs 频率 ==========
figure('Name', 'Fig3_Phase_Unwrapped_Before', 'NumberTitle', 'off');
hold on;
h_legend3 = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, phase_before_unwrap_deg(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend3(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}\angle' Sp_label ' \fontname{宋体}相位 \fontname{Times New Roman}(deg)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准前 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益相位（解绕卷）'], 'Interpreter', 'tex', 'FontSize', 13);
legend(h_legend3, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 4: 校准后 64通道带内增益幅度 vs 频率 ==========
figure('Name', 'Fig4_Amp_After', 'NumberTitle', 'off');
hold on;
h_legend4 = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, mag_after_dB(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend4(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}|' Sp_label '| \fontname{宋体}幅度 \fontname{Times New Roman}(dB)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准后 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益幅度'], 'Interpreter', 'tex', 'FontSize', 13);
legend(h_legend4, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 5: 校准后 64通道带内增益相位（绕卷）vs 频率 ==========
figure('Name', 'Fig5_Phase_Wrapped_After', 'NumberTitle', 'off');
hold on;
h_legend5 = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, phase_after_deg(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend5(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}\angle' Sp_label ' \fontname{宋体}相位 \fontname{Times New Roman}(deg)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准后 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益相位（绕卷）'], 'Interpreter', 'tex', 'FontSize', 13);
legend(h_legend5, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 6: 校准后 64通道带内增益相位（解绕卷）vs 频率 ==========
figure('Name', 'Fig6_Phase_Unwrapped_After', 'NumberTitle', 'off');
hold on;
h_legend6 = gobjects(8, 1);
for bi = 1:8
    for ci = 1:8
        h_tmp = plot(freq_band_GHz, phase_after_unwrap_deg(Freq_band, ci, bi), ...
            'Color', board_colors(bi, :), 'LineWidth', 0.8);
        if ci == 1
            h_legend6(bi) = h_tmp;
        end
    end
end
hold off;
grid on;
xlabel(['\fontname{宋体}频率 \fontname{Times New Roman}(GHz)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}\angle' Sp_label ' \fontname{宋体}相位 \fontname{Times New Roman}(deg)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{宋体}校准后 \fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— 64\fontname{宋体}通道带内增益相位（解绕卷）'], 'Interpreter', 'tex', 'FontSize', 13);
legend(h_legend6, legend_str, 'Location', 'best', 'FontName', 'Times New Roman', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 11);

%% ========== Figure 7: 幅度箱型图 —— 校准前后子阵对比 ==========
% 计算每个通道的带内平均增益幅度 (dB)
amp_avg_before = squeeze(mean(mag_before_dB(Freq_band, :, :), 1)); % (8 channels, 8 boards)
amp_avg_after  = squeeze(mean(mag_after_dB(Freq_band, :, :), 1));  % (8 channels, 8 boards)

figure('Name', 'Fig7_Amp_Boxplot', 'NumberTitle', 'off');
hold on;

% 校准前箱型图（蓝色实线）
bp1 = boxplot(amp_avg_before, ...
    'Positions', (1:8) - 0.18, ...
    'Widths', 0.28, ...
    'Colors', [0 0.447 0.741], ...  % 蓝色
    'Symbol', 'o');
set(bp1, 'LineWidth', 1.2);

% 校准后箱型图（红色虚线）
bp2 = boxplot(amp_avg_after, ...
    'Positions', (1:8) + 0.18, ...
    'Widths', 0.28, ...
    'Colors', [0.850 0.325 0.098], ...  % 红色
    'Symbol', 's');
set(bp2, 'LineWidth', 1.2);
% 将校准后的箱型图设置为虚线
h_bp2_lines = findobj(bp2, 'Tag', 'Box');
set(h_bp2_lines, 'LineStyle', '--');
h_bp2_whiskers = findobj(bp2, 'Tag', 'Whisker');
set(h_bp2_whiskers, 'LineStyle', '--');
h_bp2_median = findobj(bp2, 'Tag', 'Median');
set(h_bp2_median, 'LineStyle', '--');

hold off;
grid on;

% 创建图例用的虚拟线条
h_leg_before = plot(NaN, NaN, '-', 'Color', [0 0.447 0.741], 'LineWidth', 1.5);
hold on;
h_leg_after  = plot(NaN, NaN, '--', 'Color', [0.850 0.325 0.098], 'LineWidth', 1.5);
hold off;
legend([h_leg_before, h_leg_after], ...
    {'\fontname{宋体}校准前', '\fontname{宋体}校准后'}, ...
    'Interpreter', 'tex', 'FontSize', 11, 'Location', 'best');

xlabel(['\fontname{宋体}子阵板编号 \fontname{Times New Roman}(Board ID)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{宋体}带内平均 \fontname{Times New Roman}|' Sp_label '| (dB)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ' \fontname{宋体}— \fontname{宋体}各子阵板通道幅度分布箱型图'], 'Interpreter', 'tex', 'FontSize', 13);

% 设置x轴刻度
set(gca, 'XTick', 1:8, 'FontName', 'Times New Roman', 'FontSize', 11);
xticklabel_str = cell(1, 8);
for bi = 1:8
    xticklabel_str{bi} = ['Board ' num2str(bi-1)];
end
set(gca, 'XTickLabel', xticklabel_str);
xlim([0.4 8.6]);

%% ========== Figure 8: 相位箱型图 —— 校准前后子阵对比 ==========
% 取中心频点处的增益相位 (度)
phase_center_before = squeeze(phase_before_deg(Freq_center, :, :));  % (8 channels, 8 boards)
phase_center_after  = squeeze(phase_after_deg(Freq_center, :, :));

figure('Name', 'Fig8_Phase_Boxplot', 'NumberTitle', 'off');
hold on;

% 校准前箱型图（蓝色实线）
bp3 = boxplot(phase_center_before, ...
    'Positions', (1:8) - 0.18, ...
    'Widths', 0.28, ...
    'Colors', [0 0.447 0.741], ...
    'Symbol', 'o');
set(bp3, 'LineWidth', 1.2);

% 校准后箱型图（红色虚线）
bp4 = boxplot(phase_center_after, ...
    'Positions', (1:8) + 0.18, ...
    'Widths', 0.28, ...
    'Colors', [0.850 0.325 0.098], ...
    'Symbol', 's');
set(bp4, 'LineWidth', 1.2);
% 将校准后的箱型图设置为虚线
h_bp4_lines = findobj(bp4, 'Tag', 'Box');
set(h_bp4_lines, 'LineStyle', '--');
h_bp4_whiskers = findobj(bp4, 'Tag', 'Whisker');
set(h_bp4_whiskers, 'LineStyle', '--');
h_bp4_median = findobj(bp4, 'Tag', 'Median');
set(h_bp4_median, 'LineStyle', '--');

hold off;
grid on;

% 创建图例用的虚拟线条
h_leg_before2 = plot(NaN, NaN, '-', 'Color', [0 0.447 0.741], 'LineWidth', 1.5);
hold on;
h_leg_after2  = plot(NaN, NaN, '--', 'Color', [0.850 0.325 0.098], 'LineWidth', 1.5);
hold off;
legend([h_leg_before2, h_leg_after2], ...
    {'\fontname{宋体}校准前', '\fontname{宋体}校准后'}, ...
    'Interpreter', 'tex', 'FontSize', 11, 'Location', 'best');

freq_center_GHz = freq_GHz(Freq_center);
xlabel(['\fontname{宋体}子阵板编号 \fontname{Times New Roman}(Board ID)'], 'Interpreter', 'tex', 'FontSize', 12);
ylabel(['\fontname{Times New Roman}\angle' Sp_label ' \fontname{宋体}相位 \fontname{Times New Roman}(deg)'], 'Interpreter', 'tex', 'FontSize', 12);
title(['\fontname{Times New Roman}' TXRX_str ' Module ' num2str(Module_ID) ...
    ' \fontname{宋体}— \fontname{宋体}各子阵板通道中心频点（\fontname{Times New Roman}' ...
    sprintf('%.2f', freq_center_GHz) ' GHz\fontname{宋体}）相位分布箱型图'], ...
    'Interpreter', 'tex', 'FontSize', 13);

% 设置x轴刻度
set(gca, 'XTick', 1:8, 'FontName', 'Times New Roman', 'FontSize', 11);
set(gca, 'XTickLabel', xticklabel_str);
xlim([0.4 8.6]);

%% 打印校准效果统计摘要
fprintf('\n========== 校准效果统计摘要 ==========\n');
fprintf('校准前：\n');
fprintf('  幅度(带内均值): 最大 %.2f dB, 最小 %.2f dB, 极差 %.2f dB\n', ...
    max(amp_avg_before(:)), min(amp_avg_before(:)), max(amp_avg_before(:)) - min(amp_avg_before(:)));
fprintf('  相位(中心频点): 最大 %.1f°, 最小 %.1f°, 极差 %.1f°\n', ...
    max(phase_center_before(:)), min(phase_center_before(:)), ...
    max(phase_center_before(:)) - min(phase_center_before(:)));
fprintf('校准后：\n');
fprintf('  幅度(带内均值): 最大 %.2f dB, 最小 %.2f dB, 极差 %.2f dB\n', ...
    max(amp_avg_after(:)), min(amp_avg_after(:)), max(amp_avg_after(:)) - min(amp_avg_after(:)));
fprintf('  相位(中心频点): 最大 %.1f°, 最小 %.1f°, 极差 %.1f°\n', ...
    max(phase_center_after(:)), min(phase_center_after(:)), ...
    max(phase_center_after(:)) - min(phase_center_after(:)));
fprintf('==========================================\n');

end