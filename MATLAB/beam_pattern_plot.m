%%
CloseSerial;
clear COM;
fclose(SAObj);

%%
CloseSerial;
clear COM_ZT;
clear COM_VT;

clear COM_EM;
clear classObj;

%%
close all;
clear all;
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
NET.addAssembly('F:\202409_EMIMO\EMIMO-Software\MATLAB\MCC4DLL.dll');  %加载一个dll程序集,记得修改文件位置
classObj = SerialPortLibrary.SPLibClass();
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'Prolific USB-to-Serial Comm Port')
        COM_ZT = sprintf('com%d',devices{i,2});   % 查找转台的串口
        break;
    end
end
classObj.MoCtrCard_Initial(COM_ZT);  %连接转台


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

%打开开发者模式
Parket = hex2dec(['08';'00';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM_EM,Frame);
fprintf('已打开开发者模式。')
%打开通道
Parket = hex2dec(['08';'04';'02';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM_EM,Frame);
%法相波束
Parket = hex2dec(['08';'01';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM_EM,Frame);
fprintf('阵面已初始化为法相波束。')
%%
Parket = hex2dec(['08';'04';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM_EM,Frame);
fprintf('已关闭通道。\n')
%%
att_byte = '20'

func_IFDSA_write(COM_EM, isTX, att_byte);

%% 使用LAN口连接频谱仪，并完成初始化
SA_Init_SVA1075X(); 


%% 循环转圈，三个频率，6.8，6.95，7.1GHz，每个频率的波束从-60到+60°，每隔10°转一圈
%测试的频点
% measfreq = [6.8 6.95 7.1];
% measfreq = [6.95];
% measfreq = [6.75];
measfreq = [7.15];
%波束偏转角度
Beamdirect = -60:10:60;
%转台角度
Start_Angle = -90;
% Start_Angle = 0;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;

%初始化转台在-90°
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
pause(1);

%% 转到指定角度
speci_ang = 0
classObj.MoCtrCard_MCrlAxisAbsMove(1,speci_ang,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，


%% 循环测试
% 初始化矩阵来存储数据，假设每个频点旋转角度从-90到90度，步进1度
% 每1度，都读取频谱仪此时测量的信道的所有频率的功率值
% 每个频点有181个角度测量
recv_pw_peak = zeros(length(Angle),length(Beamdirect));

for i = 1:length(measfreq)
    % 每个频点画一幅图
    figure;
    legends = cell(8,1);
    for j = 1:length(Beamdirect)
        func_phase_array_beam_direct_to(COM_EM, Beamdirect(j), 0);%偏转水平角
        pause(0.5);
        if(j ~= 1) % 除了首次启动转台，其他情况都需要等待转台回到开始位置
            classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
            pause(11); % 速度20时，转90°大约耗时4.9s。
            fprintf("转台已回到起始位置。下一个波束号%d(角度%d°)\n", j, Beamdirect(j));
        end
        for ii = 1:length(Angle)
                classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 5, 0.1);
                pause(0.45);
                fprintf(SAObj, 'CALC:MARK1:Y?');  % 读取Marker 1的幅度（Y轴）
                markerAmplitude = fscanf(SAObj, '%f');  % 幅度值
                recv_pw_peak(ii, j) = markerAmplitude;  % 将数据存储在矩阵中，-90°对应矩阵中的第1行
        end
        %保存数据
        fileName=['mat\chan_power' num2str(measfreq(i)) 'GHz' num2str(Beamdirect(j)) 'angle' char(datetime('now','Format','yMdHHmm')) '.mat'];
        save(fileName,'recv_pw_peak');
        
        plot(Angle, recv_pw_peak(:,j));
        legends{j} = sprintf('%d°', Beamdirect(j));
        hold on;
    end
    hold off;    
    lg = legend(legends, 'Location', 'bestoutside');
    lg.ItemHitFcn=@HitCallbackFcn;
    grid on;

    input('手动切换下一个频率...（完成后按Enter）')
end

% 此时需要对表格中的数据的每一行取最大值，即是此时的测量的频率的功率值，得到一个181*1的表格
% 就是某频点下，某个波束偏转角下，的方向图数据，即-90~90度每1度的功率，画图可以得到方向图



%% 读取保存的mat文件，重新画图

% load("f:\WPS_Sync\202409_eMIMO\Software\MATLAB\mat\chan_power6.95GHz60angle20258251524.mat")
% load("f:\WPS_Sync\202409_eMIMO\Software\MATLAB\mat\chan_power6.75GHz60angle20258251627.mat")
load("f:\WPS_Sync\202409_eMIMO\Software\MATLAB\mat\chan_power7.15GHz60angle20258251658.mat")


[lenRotAng, lenBeamDir] = size(recv_pw_peak);
% maxGain = getMaxGainFromMat("f:\WPS_Sync\202409_eMIMO\Software\MATLAB\mat\chan_power6.95GHz60angle20258261058.mat")
%波束偏转角度
Beamdirect = -60:10:60;
if lenBeamDir ~= length(Beamdirect)
    error('检查波束个数');
end
maxPw = max(recv_pw_peak(:));
if maxPw == 0
    error('数据可能不完整，请检查');
end

% 归一化
recv_pw_peak = recv_pw_peak - maxPw;

% 生成横轴
Start_Angle = -90;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;

legends = cell(lenBeamDir + 1, 1);
figure;
hold on;
for i=1:lenBeamDir
    plot(Angle, recv_pw_peak(:,i), LineStyle="-", LineWidth=1);
    legends{i} = sprintf('%d°', Beamdirect(i));
end
Angle4bl = -72:72;
baseLine = 10*log10(cos(deg2rad(Angle4bl)));
plot(Angle4bl, baseLine, LineStyle="--", LineWidth=1.5, Color=[0.1 0.1 0.1]);
legends{end} = '10lg(cos\theta)';

set(gca,'FontName','Times New Roman','FontSize', 14);
xlabel('\fontname{宋体}\fontsize{14}扫描角度\fontname{Times New Roman}\theta\fontsize{14}(°)');
ylabel('\fontname{宋体}\fontsize{14}归一化增益\fontname{Times New Roman}\fontsize{14}(dB)');

lg = legend(legends, 'Location', 'best');
lg.ItemHitFcn=@HitCallbackFcn;
grid on;

% function maxVal = getMaxGainFromMat(MatFileName)
% recv_pw_peak = load(MatFileName);
% % 假定MatFileName中只有所需的recv_pw_peak变量
%     maxVal = max(recv_pw_peak(:));
%     if maxVal == 0
%         error('数据不完整');
%     end
% end


function HitCallbackFcn(src,evnt) % 当点击图例后执行的自定义函数
    if strcmp(evnt.Peer.Visible,'on')
        evnt.Peer.Visible = 'off';
    else
        evnt.Peer.Visible = 'on';
    end
end
