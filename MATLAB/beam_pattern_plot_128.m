%
% 同时连接两个基带机箱并使用串口发送'uramPlay'命令
% 需要自行对照设备管理器识别串口号（每个FT4232有4个串口，其中3个会显示在设备管理器的'端口'中，最低的那个被用来UART通信）
baudrate = 115200;

BB1_COM = 'com23';
BB2_COM = 'com27';

ft1 = OpenSerial(BB1_COM, baudrate, @ReadFcn_Com)
ft2 = OpenSerial(BB2_COM, baudrate, @ReadFcn_Com)

%%
cmd = 'uramPlay\n';
% cmd = 'rfdcStartup\n';
% cmd = 'dacMTS 0xf\n'
fwrite(ft1,cmd)
fwrite(ft2,cmd)

%%
fclose(ft1)
fclose(ft2)

%%
CloseSerial;
clear COM;
fclose(SAObj);

%%
CloseSerial;
clear COMHUB_EM;
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

COMHUB_EM = open_serial_hub(baudrate,@ReadFcn_Com);  %连接多个EMIMO模组（这里会打开所有CH340串口，所以不要连接非EMIMO模组的CH340设备）

devices = IdentifySerialComs();
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


%打开开发者模式
func_dev_mode(COMHUB_EM,1);
fprintf('已打开开发者模式。')

%打开通道
func_channel_switch(COMHUB_EM,0,8,8,isTX,0);
fprintf('已打开射频通道。')

%法相波束
func_phase_array_beam_init(COMHUB_EM);
fprintf('阵面已初始化为法相波束。')
%%
func_channel_switch(COMHUB_EM,0,8,8,isTX,1);
fprintf('已关闭通道。\n')
%%
att_byte = '10'
func_IFDSA_write(COMHUB_EM, isTX, att_byte);

%% 使用LAN口连接频谱仪，并完成初始化
SA_Init_SVA1075X(); 


%% 循环转圈，三个频率，6.8，6.95，7.1GHz，每个频率的波束从-60到+60°，每隔10°转一圈
%测试的频点
% measfreq = [6.8 6.95 7.1];
measfreq = [6.95];
% measfreq = [6.75];
% measfreq = [7.15];
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
classObj.MoCtrCard_MCrlAxisAbsMove(1,speci_ang,10,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，


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
        func_phase_array_beam_direct_to(COMHUB_EM, Beamdirect(j), 0);%偏转水平角
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

function HitCallbackFcn(src,evnt) % 当点击图例后执行的自定义函数
    if strcmp(evnt.Peer.Visible,'on')
        evnt.Peer.Visible = 'off';
    else
        evnt.Peer.Visible = 'on';
    end
end