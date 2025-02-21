clear all;
close all;
clc;
addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。
addpath(genpath('VNA'));
addpath(genpath('Script')); 
addpath(genpath('Function'));


%%
CloseSerial;
clear COM;

%% 识别 设备串口号 和 Far field 串口号 并载入
% 注意确认COM号的具体对应关系

baudrate = 115200;
tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
toc

COM_VT = sprintf('com%d',devices{1,2});
COM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);

NET.addAssembly('F:\MATLAB\EMIMO\MCC4DLL.dll');%加载一个dll程序集
classObj = SerialPortLibrary.SPLibClass();
% 注意修改成转台的串口，名为 Prolific USB-to-Serial Comm Port
COM_ZT = sprintf('com%d',devices{2,2});
classObj.MoCtrCard_Initial(COM_ZT);

%% 设备模式
isTX = 1;

ang_azimuth = 0;

ang_pitch = 0;

IF_gain_list = [0 8 16];

IFDSA_step = 0.5;

att_byte_list = dec2hex(IF_gain_list./IFDSA_step, 2);

Start_Angle = -90;
Stop_Angle = 90;
AStep = 1;
Angle = Start_Angle:AStep:Stop_Angle;

numPoints = 201; % 与校准集一致！
index_list = 1:numPoints;
freq_list = linspace(2.7e9, 3.2e9, numPoints);
freq_MK_center = 101;
freq_MK_lower = 41;
freq_MK_higher = 161;
ang_MK_center = 91;

%% 初始化设备和转台 

% 打开设备的所有通道
func_channel_switch(COM, 0, 8, 8, isTX, 0);
pause(0.1);

% 初始化
func_phase_array_beam_init(COM);
pause(0.1);

% 指定波束指向
func_phase_array_beam_direct_to(COM, ang_azimuth, ang_pitch);
pause(0.1);

% 更新相位
func_ps_lacth_phase(COM);
pause(0.1);


% 转台归零
%set normal
classObj.MoCtrCard_MCrlAxisAbsMove(1,0,10,0.1);
pause(1);

%% 转到Start位置
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,5,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
pause(1);

%% 

Nrun = length(IF_gain_list);

Gain_atCenterFreq = zeros(Nrun, length(Angle));

for i=1:Nrun

    % 改变中频增益
    func_IFDSA_write(COM, isTX, att_byte_list(i,:))
    
    Far_dB = func_rotary_start(classObj, Angle, isTX, 'loop_indicator_j', i);
    
    Gain_atCenterFreq(i, : ) = Far_dB(freq_MK_center, : );

end

%%

i=Nrun;
% 改变中频增益
func_IFDSA_write(COM, isTX, att_byte_list(i,:))

Far_dB = func_rotary_start(classObj, Angle, isTX, 'loop_indicator_j', i);

Gain_atCenterFreq(i, : ) = Far_dB(freq_MK_center, : );

%% 保存文件

fileName=['mat\Gain_atCenterFreq' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'Gain_atCenterFreq');


%% 绘制 增益-角度 图（方向图）
figure;
plt_line = plot(Angle, Gain_atCenterFreq);
legend(plt_line, att_byte_list)
