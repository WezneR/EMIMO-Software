close all;
clc;
addpath(genpath('UART'));
addpath(genpath('SA'));
addpath(genpath('Function'));
addpath(genpath('mat'));

%% 识别 EMIMO 设备串口号 和 转台（ZT） 串口号 并载入
% 注意确认COM号的具体对应关系
baudrate = 115200;
%tic
devices = IdentifySerialComs();  %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
%toc
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'USB-SERIAL CH340')
        COM_VT = sprintf('com%d',devices{i,2});   % 查找EMIMO的串口
        break;
    end
end
COM_EM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);  %连接EMIMO设备，准备控制波束

% 注意修改成转台的串口，名为 Prolific USB-to-Serial Comm Port
NET.addAssembly('F:\MATLAB\EMIMO\MCC4DLL.dll');  %加载一个dll程序集,记得修改文件位置
classObj = SerialPortLibrary.SPLibClass();
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'Prolific USB-to-Serial Comm Port')
        COM_ZT = sprintf('com%d',devices{i,2});   % 查找转台的串口
        break;
    end
end
classObj.MoCtrCard_Initial(COM_ZT);  %连接转台

%% 使用LAN口连接频谱仪，并完成初始化
SA_Init_SVA1075X(); 

%% 控制EMIMO相位

isTX = 1;

ang_azimuth = 0; %水平方向角

ang_pitch = 0; %俯仰角

% 初始化，波束回到无偏转状态。重新将接收的初始相位写入各通道BF寄存器；各通道AC寄存器置0；
% 将接收的初始衰减幅度写入各通道DSA；
% 完成后自动产生LP脉冲更新相位
UART.Head = hex2dec(['55';'5D']);  
UART.Pause_Sec = 0.1; %Between each frame
UART.End = hex2dec(['0D';'0A']);
UART.End_mcu = hex2dec(['0A';'0D']);
% 待机状态
init_Parket = hex2dec(['08';'06';'00';'00']);
init_Frame = [UART.Head; init_Parket;UART.End];
fwrite(COM_EM,init_Frame);
%打开开发者模式
Parket = hex2dec(['08';'00';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM_EM,Frame);
fprintf('已打开开发者模式。')
%打开通道
Parket = hex2dec(['10';'04';'02';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM_EM,Frame);
%法相波束
Parket = hex2dec(['08';'01';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM_EM,Frame);
fprintf('阵面已初始化为法相波束。')


%% 循环转圈，三个频率，6.8，6.95，7.1GHz，每个频率的波束从-60到+60°，每隔10°转一圈
%测试的频点
measfreq = [6.8 6.95 7.1] ;
%波束偏转角度
Beamdirect = -60:10:60;
%转台角度
Start_Angle = -90;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;
%初始化转台在-90°
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,5,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
pause(1);

%% 循环测试
% 初始化矩阵来存储数据，假设每个频点旋转角度从-90到90度，步进1度
% 每1度，都读取频谱仪此时测量的信道的所有频率的功率值
% 每个频点有181个角度测量
recv_pw_peak = zeros(length(Angle),400);%频谱仪初始化的分辨率带宽是1M，400M的带宽，所以每次读取共有400个频点的功率值

for i = 1:length(measfreq)
    for j = 1:length(Beamdirect)

        func_phase_array_beam_direct_to(COM_EM, Beamdirect(j), 0);%偏转水平角
        pause(0.5);

        for ii = 1:length(Angle)

                classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 2, 0.1);
                pause(0.1);
                fprintf(SAObj, 'CALC:MARK1:Y?');  % 读取Marker 1的幅度（Y轴）
                markerAmplitude = fscanf(SAObj, '%f');  % 幅度值
                recv_pw_peak(ii,:) = markerAmplitude;  % 将数据存储在矩阵中，-90°对应矩阵中的第1行

        end
    %保存数据
    fileName=['mat\chan_power' num2str(measfreq(i)) 'GHz' num2str(Beamdirect(j)) 'angle' char(datetime('now','Format','yMdHHmm')) '.mat'];
    save(fileName,'recv_pw_peak');
    end
    input('手动切换下一个频率...（完成后按Enter）')
end

% 此时需要对表格中的数据的每一行取最大值，即是此时的测量的频率的功率值，得到一个181*1的表格
% 就是某频点下，某个波束偏转角下，的方向图数据，即-90~90度每1度的功率，画图可以得到方向图

fclose(specObj);