function [amp_init, phase_init] = func_OTAmeasure_module(isTX)
%FUNC_OTAMEASURE_MODULE 
% 使用VNA采集一次空口增益和相位。返回的幅度和相位是 numPoints x 1 列向量，包含所有频点上的值。
%   在调用此函数前：
%       - 矢网和设备已经正确连接，确保可以正常控制。
%       - 设备（模组）连接矢网端口1，以确保S21为isTX=1时的设备增益。
%   此处显示详细说明
%   Input
%       - isTX:整数，1表示TX，0表示RX。
%   Output
%       - amp_init: numPoints x 1 列向量，表示各个频点上的S参数幅值
%       - phase_init: numPoints x 1 列向量，表示各个频点上的S参数相位


% modlue0       modlue1       module2       module3

% modlue4       modlue5       module6       module7

% modlue8       modlue9       module10      module11

% modlue12      modlue13      module14      module15


VNA_Init_3672E; %校准文件、频率范围、频点数在这里修改
numPoints=201; 
% frequencyRange = [2.7e9 3.2e9];
% freq_MK_range = 41:1:161;
% freq_MK_center = 101; % 取2.95GHz处的值
% freq_MK_lower = 41;
% freq_MK_higher = 161;

loop = 1; % VNA连续测量的次数

VNA_Single_Sweep_3672E;%必须先运行这个，才可以运行fast
pause(0.1);


if isTX
    sp = 2;
else
    sp = 3;
end

a = zeros(numPoints, loop);
p = zeros(numPoints, loop);

for j = 1:loop
    VNA_Single_Sweep_3672E_Fast;
    a(:, j) = 20*log10(sparamMag(:, sp));
    p(:, j) = sparamPhase(:, sp)./pi*180;
end

% 每一行求一个平均值（loop列 -> 1列）
amp_init = sum(a, 2)/loop;
phase_init = func_cal_avg_phase(p);

end