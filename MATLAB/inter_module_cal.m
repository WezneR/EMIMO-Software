clear ;
close all;
clc;
addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。
addpath(genpath('VNA'));
addpath(genpath('Script'));
addpath(genpath('Function'));
addpath(genpath('mat'));

%%
CloseSerial;
clear COM;

% Choose the connected VNA 
VNA_USE = 'P5005A';

%% 识别串口号
baudrate = 115200;

tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
toc

hub = open_serial_hub(baudrate, @ReadFcn_Com)


%% 检查 mod_a mod_b 与实物模组的对应关系
func_dev_mode(hub, 1);
fprintf('已打开开发者模式。')
% 发送打开所有RX，观察是谁收到了
func_channel_switch(hub, 0, 8, 8, 0, 0)
%% 

isTX = 1;

func_channel_switch(hub, 0, 8, 8, isTX, 1)
    
%%

COM = hub;
Module_ID = 1;


func_dev_mode(COM, 1);
fprintf('已打开开发者模式。')

func_phase_array_beam_init(COM);
fprintf('已执行阵面初始化。')
pause(0.1);

%% 打开模组a全部通道，测相位
COM = hub;
Module_ID = 1;

for bi = 0:7
    func_channel_switch(COM, Module_ID, bi, 8, isTX, 0)
end
fprintf('已打开所有通道。')
pause(0.1);

[amp_init_a, phase_init_a] = func_OTAmeasure_module(isTX);

func_channel_switch(COM, 0, 8, 8, isTX, 1)
fprintf('已关闭所有通道。')
%%
COM = hub;
Module_ID = 3;


func_dev_mode(COM, 1);
fprintf('已打开开发者模式。')

func_phase_array_beam_init(COM);
fprintf('已执行阵面初始化。')
pause(0.1);

%% 打开模组b全部通道，测相位
COM = hub;
Module_ID = 2;

for bi = 0:7
    func_channel_switch(COM, Module_ID, bi, 8, isTX, 0)
end
fprintf('已打开所有通道。')
pause(0.1);

[amp_init_b, phase_init_b] = func_OTAmeasure_module(isTX);

func_channel_switch(COM, Module_ID, 8, 8, isTX, 1)
fprintf('已关闭所有通道。')

%% 补偿模组间相位差
COM = hub;
Module_ID = 1;

compen_psb = dec2hex(round((phase_init_a - phase_init_b)./1.41), 2);

func_ps_phase_write(COM, 0, 8, 8, 1, 0, compen_psb)
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)
func_ps_phase_write(COM, 0, 8, 8, 1, 1, compen_psb)
pause(0.1)
func_ps_lacth_phase(COM);

%% 补偿模组间相位差
COM = hub;
Module_ID = 3;

chip_id_list = double(~isTX) * 4 + (0:3);

for i = 0:7
    for j = chip_id_list
        for ci = 0:1
            func_ps_phase_write(COM, Module_ID, i, j, 0, ci, compen_psb);
            pause(0.04);
            func_ps_lacth_phase(COM);
            pause(0.04);
        end
    end
end


% func_ps_phase_write(COM, Module_ID, 8, 8, 1, 0, compen_psb)
%%
CloseSerial;
clear COM;

%% 识别串口号 Far field 转台载入
baudrate = 115200;
tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出位devices
toc


hub = OpenSerial(sprintf('com%d',devices{1,2}), baudrate, @ReadFcn_Com);

hub = OpenSerial(sprintf('com%d',devices{2,2}), baudrate, @ReadFcn_Com);


NET.addAssembly('F:\MATLAB\EMIMO\MCC4DLL.dll');%加载一个dll程序集
classObj = SerialPortLibrary.SPLibClass();
% 注意修改成转台的串口，名为 Prolific USB-to-Serial Comm Port
COM_ZT = sprintf('com%d',devices{3,2});
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
func_IFDSA_write(hub, isTX, att_byte_list(2,:))
func_IFDSA_write(hub, isTX, att_byte_list(2,:))

%% 打开开发者模式，所有通道打开
func_dev_mode(hub, 1);
func_dev_mode(hub, 1);
fprintf('已打开开发者模式。')

func_channel_switch(hub, 0, 8, 8, isTX, 0)
func_channel_switch(hub, 0, 8, 8, isTX, 0)
fprintf('已打开所有通道。')
pause(0.1);

%% 阵面波束初始化
func_phase_array_beam_init(hub);
func_phase_array_beam_init(hub);
fprintf('已执行阵面初始化。')
pause(0.1);


%%

ang = 60;
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


