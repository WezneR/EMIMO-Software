clear ;
close all;
clc;
addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。
addpath(genpath('VNA'));
addpath(genpath('Script')); 
addpath(genpath('Function'));
addpath(genpath('mat'));

vna_use = '3672E';
%%
CloseSerial;
clear COM;

%% 识别串口号
baudrate = 115200;

tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
toc

COM_VT = sprintf('com%d',devices{1,2});
COM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);

%% 帧格式
UART.Head = hex2dec(['55';'5D']);  
UART.Pause_Sec = 0.1; % Between each frame
UART.End = hex2dec(['0D';'0A']);
UART.End_mcu = hex2dec(['0A';'0D']);

Parket = hex2dec(['08';'00';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM,Frame);
fprintf('已打开开发者模式。');

%% 设备
Module_ID = 0;
isTX = 0;
%% Open
func_channel_switch(COM, Module_ID, 8, 8, isTX, 0);
%% Close all
func_channel_switch(COM, Module_ID, 8, 8, isTX, 1);
%% 阵面波束初始化
func_phase_array_beam_init(COM);
pause(0.1);

%% 设置中频增益

att_byte = '20'

func_IFDSA_write(COM, isTX, att_byte);

%% 设置移相器幅度衰减和相移（主要用于校准前，清零，保证此时没有写入衰减和移相）

%清除衰减
att = '00';
func_ps_att_write(COM, 0, 8, 8, 0, att);%清除所有移相器的第0个channel的衰减
pause(0.1);
func_ps_att_write(COM, 0, 8, 8, 1, att);%清除所有移相器的第1个channel的衰减
pause(0.1);


%清除相位
pbs = '00';
func_ps_phase_write(COM, 0, 8, 8, 0, 0, pbs); %清除所有移相器的第0个channel的BF寄存器
pause(0.1);
func_ps_phase_write(COM, 0, 8, 8, 1, 0, pbs); %清除所有移相器的第0个channel的AC寄存器
pause(0.1);
func_ps_phase_write(COM, 0, 8, 8, 0, 1, pbs); %清除所有移相器的第1个channel的BF寄存器
pause(0.1);
func_ps_phase_write(COM, 0, 8, 8, 1, 1, pbs); %清除所有移相器的第1个channel的AC寄存器
pause(0.1); 
func_ps_lacth_phase(COM);
pause(0.1);
%% 单个module ,读取每个通道初始相位和初始幅度
%每个module 有 8个board ,每个board 有8个天线的单元
% board0      board1      board2      ......      board7
%    #0          #0
%    #1
%     ...
%    #7

loop = 1; 

[amp_delta, amp_init, sparam_save_amp] = func_calibration_amp(COM, Module_ID, isTX, loop, 5, 'vna_use', vna_use)

%% 写入EEPROM
func_ROMwirte_amp(COM, Module_ID, isTX, amp_delta);

%% 校准相位
[phase_delta, phase_init, sparam_save_phase] = func_calibration_phase(COM, Module_ID, isTX, 6, 'vna_use', vna_use)

%% 写入EEPROM
func_ROMwirte_phase(COM, Module_ID, isTX, phase_delta);

%% 测量通道
[amp_init, phase_init] = func_OTAmeasure_channel(COM, Module_ID, isTX, 'vna_use', vna_use)

%% ====== 新增：保存校准前后的完整S参数数据 ======
% sparam_save_amp  包含校准前(第一次幅度测量)和幅度校准后的S参数
% sparam_save_phase 包含相位校准前(幅度校准后)和全部校准后的S参数
%
% 对于绘图：
%   "校准前" = sparam_save_amp 的 before 数据（幅度校准前，即未施加任何校准）
%   "校准后" = sparam_save_phase 的 after 数据（幅度+相位校准完成后）

% 保存综合S参数数据到mat文件
if isTX
    save_filename = ['mat\calibration\history\M' num2str(Module_ID, '%02d') ...
        '_TX_sparam_full_' char(datetime('now','Format','yMdHHmm')) '.mat'];
else
    save_filename = ['mat\calibration\history\M' num2str(Module_ID, '%02d') ...
        '_RX_sparam_full_' char(datetime('now','Format','yMdHHmm')) '.mat'];
end
save(save_filename, 'sparam_save_amp', 'sparam_save_phase', 'amp_delta', 'phase_delta', 'amp_init', 'phase_init');
fprintf('已保存完整S参数数据至: %s\n', save_filename);

%% ====== 新增：绘制校准前后对比图 ======
func_plot_calibration_results(sparam_save_amp, sparam_save_phase, Module_ID);

%% 清空相位EEPROM
func_ROMwirte_phase(COM, Module_ID, isTX, zeros(8,8));
