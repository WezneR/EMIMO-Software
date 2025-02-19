clear all;
close all;
clc;
cd 'F:\MATLAB\EMIMO' %设置当前文件夹路径
addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。
addpath(genpath('VNA'));
addpath(genpath('Script'));
addpath(genpath('Function'));


%%
CloseSerial;
clear COM;

% Choose the connected VNA 
VNA_USE = 'P5005A';
%% 识别串口号 Far field 转台载入
baudrate = 115200;
tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出位devices
toc


COM = open_serial_hub(baudrate, @ReadFcn_Com)

NET.addAssembly('F:\MATLAB\EMIMO\MCC4DLL.dll');%加载一个dll程序集
classObj = SerialPortLibrary.SPLibClass();
% 找到转台的串口并打开
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'Prolific USB-to-Serial Comm Port')
        COM_ZT = sprintf('com%d',devices{i,2});
        break;
    end
end

classObj.MoCtrCard_Initial(COM_ZT);

%% 转台归零
%set normal
classObj.MoCtrCard_MCrlAxisAbsMove(1,0,10,0.1);
pause(1);
%%

Module_ID = 2;

isTX = 1;


Start_Angle = -90;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;


numPoints = 201;
index_list = 1:numPoints;
freq_list = linspace(2.7e9, 3.2e9, numPoints);
freq_MK_center = 101;
freq_MK_lower = 41;
freq_MK_higher = 161;
ang_MK_center = 101;

%% 转到Start位置
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,5,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，

pause(1);

%%

IF_gain_list = [0 8 16 24 31.5];

IFDSA_step = 0.5;

att_byte_list = dec2hex(IF_gain_list./IFDSA_step, 2);


% 改变中频增益
att_byte_list(2,:)
func_IFDSA_write(COM, isTX, att_byte_list(2,:))

%% 打开开发者模式，所有通道打开
func_dev_mode(COM, 1);
fprintf('已打开开发者模式。')

func_channel_switch(COM, 0, 8, 8, isTX, 0)
fprintf('已打开所有通道。')
pause(0.1);

%% 阵面波束初始化
func_phase_array_beam_init(COM);
fprintf('已执行阵面初始化。')
pause(0.1);


%%

ang = 45;
func_phase_array_beam_direct_to(COM, ang, 0);
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)

fprintf('已改变波束方向角。')
pause(2)


%%

S12_index = 3; %第三列是 S12，根据连线情况修改
S21_index = 2; %第二列是 S21，根据连线情况修改
% 转台上的设备接矢网端口1，因此当 isTX = True 时，S21表示增益。否则 S12表示增益。
if isTX
    Sp_index = S21_index;
else
    Sp_index = S12_index;
end


VNA_Pause = 0.1;

% 运行 VNA_Init 前，VNA窗口不得新建任何轨迹
VNA_Init; %校准文件、频率范围、频点数在这里修改


%% 开转
% 行表示频点，列表示角度
Far_Mag = zeros(numPoints,length(Angle));
Far_Rad = zeros(numPoints,length(Angle));
Far_dB = zeros(numPoints,length(Angle));
% Far_Deg = zeros(numPoints,length(Angle));


VNA_Single_Sweep;

for ii=1:length(Angle)

    classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 2, 0.1);
    pause(0.02);
    index = ii;
    VNA_Single_Sweep_Fast;
    Far_Mag(:,ii) = sparamMag(:,Sp_index);
    Far_Rad(:,ii) = sparamPhase(:,Sp_index);
    Far_dB(:,ii)  = 20 * log10(abs(Far_Mag(:,ii)));
    
end
% 转台回到Start位置
classObj.MoCtrCard_MCrlAxisAbsMove(1, Start_Angle, 5, 0.1);

Far_GaindB = Far_dB - repmat(max(Far_dB'), length(Angle), 1)';


Far_realizedGain_atAng = Far_dB(ang_MK_center, :)
Far_realizedGain_atFreqCenter = Far_dB(freq_MK_center, :);
Far_realizedGain_atFreqLower = Far_dB(freq_MK_lower, :);
Far_realizedGain_atFreqHigher = Far_dB(freq_MK_higher, :);

%% Close all
func_channel_switch(COM, Module_ID, 8, 8, isTX, 1);
%% 保存文件

fileName=['mat\Far_dB_TX' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'Far_dB');

fileName=['mat\Far_dB_RX' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'Far_dB');


%% 绘制 增益-频率 图
figure;
plot(freq_list, smooth(Far_realizedGain_atAng,1));

legend;

%% 绘制 增益-角度 图（方向图）
figure;
plot(Angle, Far_realizedGain_atFreqCenter);
hold on;
plot(Angle, Far_realizedGain_atFreqLower);
plot(Angle, Far_realizedGain_atFreqHigher);
legend("中心频率", "低频侧(2.8G)", "高频侧(3.1G)");

