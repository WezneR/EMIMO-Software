%%% 用于演示基本功能的脚本
%
% 2024年12月5日17:02:14
%
% 当前演示脚本在不同的计算机上运行前，可能有以下代码需要更改：
%   1. 当前代码所在的工作区路径；
%   2. 赋值COM_VT时，所取的devices的行号。
%
%


%% 工作区初始化
clear ;
close all;
clc;
cd 'F:\MATLAB\EMIMO' %设置当前文件夹路径
addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。
addpath(genpath('VNA'));
addpath(genpath('Script'));
addpath(genpath('Function'));
addpath(genpath('mat'));


%% 关闭已经打开的串口
% 需要先使用 CloseSerial ，再掉电设备或断开连线，否则可能导致MATLAB崩溃
CloseSerial;
clear COM;

%% 识别设备的串口号并打开
baudrate = 115200;

tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
toc

% 根据 "CH340" 实际在 devices 中的行号来修改下面一行代码 "devices{1,2}"中的"1"。
COM_VT = sprintf('com%d',devices{1,2});
COM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);

%% 打开开发者模式
% 开发者模式允许使用软件指令来控制射频通道的开关状态（打开或关闭）和工作方向（TX或RX）
% 如果使用背板上的硬件连线(TX_ON和RX_ON)的电平控制射频通道的开关状态和工作方向，那么应该关闭开发者模式


% func_dev_mode(COM, 0);
% fprintf('已关闭开发者模式。')


func_dev_mode(COM, 1);
fprintf('已打开开发者模式。')


%% 阵面波束初始化
% 重新读取ROM中保存的射频通道移相器和衰减器的校准值信息，并自动加载、自动更新相位，使波束方向回到阵面法向。
% 设备上电后MCU会将EEPROM中的初始幅相码字发送给阵面FPGA锁存，但是不会主动装载到射频移相器和衰减器中，所以这里需要手动执行一次。
func_phase_array_beam_init(COM);
pause(0.1);

%% 设备参数

% 模组ID
Module_ID = 0;

% 射频通道是否为发射状态。1为TX，0为RX。
isTX = 1;

%% 设置中频增益

% 中频增益(衰减)控制字。"00"表示增益0dB, "3F"表示增益31.5dB
att_byte = '20';

% 写入中频增益
func_IFDSA_write(COM, isTX, att_byte);


%% 通道开关和TR切换
% TR切换由变量 isTX控制


% 打开 0号板0通道 
func_channel_switch(COM, 0, 0, 0, isTX, 0);
pause(2);

% 关闭所有通道
%（可以用func_channel_switch()实现，也可以用func_power_down()实现）
func_power_down(COM);
pause(0.1);

% 打开所有通道
func_channel_switch(COM, 0, 8, 8, isTX, 0);
pause(0.1);


%% 波束控制

% 例1：改变水平方向角为-45°
ang = -45;
func_phase_array_beam_direct_to(COM, ang, 0);
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)

fprintf('已改变波束方向角。')
pause(2)


% 例2：改变俯仰角为-60°
ang = -60;
func_phase_array_beam_direct_to(COM, 0, ang);
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)

fprintf('已改变波束俯仰角。')
pause(2)

% 例3：任意改变波束
azimuth = -42.52;
pitch = 10.29;
func_phase_array_beam_direct_to(COM, azimuth, pitch)
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)

fprintf('已改变波束指向。')
pause(2)

