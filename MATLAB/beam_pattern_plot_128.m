%% 测试128单元（双模组）阵列的方向图
% 1. 数字基带同步并校准
% （测试TX，方位角）
% 2. 连接MIMO模组TX和基带的DAC，阵列水平放置，检查连线，打开电源，打开本振，初始化MIMO前端，转台归位。
% （注意，执行"%% 识别 EMIMO 设备串口号 和 转台（ZT） 串口号 并载入" 节时，不要插入时钟板的CH340串口，等这里运行结束之后，再插入）
% 
% 3. 基带trig_out ON
% 4. 开转，每转一度记录频谱仪峰值
% 5. 切换下一个扫描的方位角，重复3,4
% 6. 切换下一个频率，然后重复3,4,5.直到测完所有频率。
% 【绘制TX下，不同扫描角、不同频率的方向图】
% 
% （测试RX，方位角。把喇叭改连信号源，频谱仪关掉）
% 7. 连接MIMO模组RX和基带的ADC，阵列水平放置。初始化MIMO前端，转台归位。
% 9. 基带trig_in pulse
% 10. 转台每转一度，基带trig_in触发一次，网口读两块板ADC数据并保存。（可能还需要检查数据中的异常值：直接正弦拟合，异常值用拟合值代替，最终目的是拿到每个通道的正弦幅度）
% 11. 切换下一个扫描的方位角，重复9,10。
% 12. 切换下一个频率，重复9,10,11
% 【绘制RX下，不同扫描角，不同频率的方向图】
% 
% 13. 


%% 清除已有连接
CloseSerial;
clear COM;
fclose(SAObj);

%% 清除已有连接
CloseSerial;
clear COMHUB_EM;
clear classObj;

%% 初始化工作区
close all;
clear all;
clc;
addpath(genpath('UART'));
addpath(genpath('SA'));
addpath(genpath('Function'));
addpath(genpath('mat'));
addpath(genpath('RFSoCClient'));

%% 基带同步 dacMTSwl

% 触发一次同步操作
RFSOC_PORT = 6001;

for board_id = 1:2
    RFSOC_IP = ['192.168.1.' num2str(board_id)];
    % Create client instance
    client = RFSoC_Client(RFSOC_IP, RFSOC_PORT);
    % Connect to server
    success = client.connect();
    if ~success
        error('Failed to connect to RFSoC server at %s:%d', RFSOC_IP, RFSOC_PORT);
    end

    try
        client.trig_mts();
    catch ME
        fprintf('Error during execution: %s\n', ME.message);
        fprintf('Stack trace:\n');
        for i = 1:length(ME.stack)
            fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
        end
    end
    client.disconnect();
end


pause(4);

% SYSREF Pulser
func_clk_sysrefmode(COM_CLK, 2);


pause(2);

% Send pulses
func_clk_sysrefpulse(COM_CLK, 1)

pause(0.5);
func_clk_sysrefmode(COM_CLK, 3);

pause(0.1)
% trig_out ON
func_clk_trig(COM_CLK, 0, 'ON');




% 可能需要用示波器检查，或者环回检查

% 注意先拔出时钟板的CH340串口



%%


for board_id = 1:1

    RFSOC_IP = ['192.168.1.' num2str(board_id)];
    % Create client instance
    client = RFSoC_Client(RFSOC_IP, RFSOC_PORT);
    % Connect to server
    success = client.connect();
    if ~success
        error('Failed to connect to RFSoC server at %s:%d', RFSOC_IP, RFSOC_PORT);
    end

    try
        client.writeDacData([], 'dac_output.bin')
    catch ME
        fprintf('Error during execution: %s\n', ME.message);
        fprintf('Stack trace:\n');
        for i = 1:length(ME.stack)
            fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
        end
    end

    client.disconnect();
end





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


%% 连接时钟板的串口 (运行到此处时再插入设备，不要提前插入，否则会被识别到 COMHUB_EM 中)

% 如果没有连接EMIMO，只想连接时钟板，可以创建一个空结构体
% baudrate = 115200;COMHUB_EM = struct(); % 否则注释掉该行


tic
devices = IdentifySerialComs();
toc

% 获取已经打开的EMIMO串口列表
openedEMIMOports = fieldnames(COMHUB_EM);

for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'USB-SERIAL CH340')
        % Found a CH340 device, check if it's already in COMHUB_EM
        comstr = sprintf('com%d',devices{i,2});
        fieldname = matlab.lang.makeValidName(comstr);
        
        % 检查这个串口是否已经在COMHUB_EM中打开
        isEMIMOport = any(strcmp(fieldname, openedEMIMOports));
        
        if ~isEMIMOport
            % 这个CH340设备不在COMHUB_EM中，应该是时钟板
            COM_CLK = OpenSerial(comstr, baudrate, @ReadFcn_Com);
            fprintf('找到时钟板串口: %s\n', comstr);
        else
            fprintf('跳过EMIMO串口: %s\n', comstr);
        end
    end
end
%%
% 确保 SYSREF是连续模式
func_clk_sysrefmode(COM_CLK, 3);

%%
% trig_out
func_clk_trig(COM_CLK, 0, 'ON');
%%
func_clk_trig(COM_CLK, 0, 'OFF');

%%
% trig_in
func_clk_trig(COM_CLK, 1, 'Pulse');

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
fprintf('阵面已初始化为法相波束。\n')
%%
func_channel_switch(COMHUB_EM,0,8,8,isTX,1);
fprintf('已关闭通道。\n')
%%
att_byte = '20';
func_IFDSA_write(COMHUB_EM, isTX, att_byte);
attenuation = 31.5 - sum([16 8 4 2 1 0.5] .* bitget(hex2dec(att_byte), 6:-1:1));
fprintf('中频衰减值为 %0.1f dB\n', attenuation)

%% 使用LAN口连接频谱仪，并完成初始化
% 注意，为了匹配基带板的IPV4子网IP且不相互冲突，频谱仪的IPV4地址改为192.168.1.201

SA_Init_SVA1075X(); 


%% 循环转圈，三个频率，6.8，6.95，7.1GHz，每个频率的波束从-60到+60°，每隔10°转一圈
%测试的频点
% measfreq = [6.8 6.95 7.1];
% measfreq = [6.95];
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
speci_ang = 0;
classObj.MoCtrCard_MCrlAxisAbsMove(1,speci_ang,10,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，


%% TX 方向图测试
% 初始化矩阵来存储数据，假设每个频点旋转角度从-90到90度，步进1度
% 每1度，都读取频谱仪此时测量的信道的所有频率的功率值
% 每个频点有181个角度测量
recv_pw_peak = zeros(length(Angle),length(Beamdirect));

for i = 1:length(measfreq)
    % 每个频点画一幅图
    figure;
    legends = cell(length(Beamdirect),1);
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


%% 接收测试
N_board = 2;

% 信号源连接喇叭，配置输出。

% 确认前端RX、本振工作正常，基带已同步且与前端连接

% 触发一次采样
func_clk_trig(COM_CLK, 1, 'Pulse');



% 读取所有基带板的ADC数据

RFSOC_PORT = 6001;

multiBoard_adcData = struct();


for board_id = 1:N_board

    RFSOC_IP = ['192.168.1.' num2str(board_id)];
    % Create client instance
    client = RFSoC_Client(RFSOC_IP, RFSOC_PORT);
    % Connect to server
    success = client.connect();
    if ~success
        error('Failed to connect to RFSoC server at %s:%d', RFSOC_IP, RFSOC_PORT);
    end

    try
        fieldName = matlab.lang.makeValidName(['B' num2str(board_id)]);
        
        [multiBoard_adcData.(fieldName), success] = client.readAdcData();

    catch ME
        fprintf('Error during execution: %s\n', ME.message);
        fprintf('Stack trace:\n');
        for i = 1:length(ME.stack)
            fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
        end
    end

    client.disconnect();
end

% 计算各路ADC接收信号的幅度


%% RX 方向图测试
% 初始化矩阵来存储数据，假设每个频点旋转角度从-90到90度，步进1度
% 每1度，都读取所有板所有ADC的采集结果，暂时不做处理
% 每个频点有181个角度测量
% isTX = 0;

%测试的频点
% measfreq = [6.8 6.95 7.1];
% measfreq = [6.95];
% measfreq = [6.75];
measfreq = [7.15];
%波束偏转角度
% Beamdirect = -60:30:60;
Beamdirect = [0]
%转台角度
Start_Angle = -90;
% Start_Angle = 0;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;

%初始化转台在-90°
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,10,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
pause(1);

%%

% 确保喇叭天线+信号源 TX 输出正常


nameDirection = char('RX' + 'T'*(isTX) - 'R'*(isTX) - [0 2*isTX])

nameTime = char(datetime('now','Format','yMdHHmm'));

nameDirectory = ['mat\BeamScan' nameDirection '_' nameTime]

mkdir(nameDirectory)

for i = 1:length(measfreq)
    
    for j = 1:length(Beamdirect)

        % 每个波束角保存一个adc数据的结构体，但一个结构体含有181度的ADC数据
        multiBoard_multiAng_adcData = struct();

        func_phase_array_beam_direct_to(COMHUB_EM, Beamdirect(j), 0);%偏转水平角

        pause(0.5);
        if(j ~= 1) % 除了首次启动转台，其他情况都需要等待转台回到开始位置
            classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
            pause(11); % 速度20时，转90°大约耗时4.9s。
            fprintf("转台已回到起始位置。下一个波束号%d(角度%d°)\n", j, Beamdirect(j));
        end

        for ii = 1:length(Angle)
                fieldName2 = matlab.lang.makeValidName(['ZTAngIdx' num2str(ii)]);
                classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 5, 0.1);
                pause(0.25)
                % 触发一次采样
                func_clk_trig(COM_CLK, 1, 'Pulse');
                pause(0.25)
                % 连接基带板获取数据
                for board_id = 1:N_board
                    RFSOC_IP = ['192.168.1.' num2str(board_id)];
                    % Create client instance
                    client = RFSoC_Client(RFSOC_IP, RFSOC_PORT);
                    % Connect to server
                    success = client.connect();
                    if ~success
                        error('Failed to connect to RFSoC server at %s:%d', RFSOC_IP, RFSOC_PORT);
                    end
                
                    try
                        fieldName1 = matlab.lang.makeValidName(['B' num2str(board_id)]);
                        
                        [multiBoard_multiAng_adcData.(fieldName1).(fieldName2), success] = client.readAdcData();
                
                    catch ME
                        fprintf('Error during execution: %s\n', ME.message);

                        fprintf('Stack trace:\n');
                        
                        for i = 1:length(ME.stack)
                            fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
                        end
                    end
                    client.disconnect();
                end
        end
        %保存数据
        fileName=[nameDirectory '\' num2str(measfreq(i)) 'GHz' num2str(Beamdirect(j)) 'BeamAng.mat'];
        save(fileName,'multiBoard_multiAng_adcData');
    end

    input('手动切换下一个频率...（完成后按Enter）')
end


%% 检查数据

% 对每个板的8个adc直接求加权和
% 再对两个板的adc求加权和


% 选择部分 Angle值便于调试
% Angle=Start_Angle:AStep:Stop_Angle;
% Angle=-90:10:90;

amp = zeros(1, length(Angle));


figure;
hold on;

for ii = 1:length(Angle) 

    fieldName2 = matlab.lang.makeValidName(['ZTAngIdx' num2str(ii)]);

    B_all_adcsum = zeros(1, client.SAMPLES_PER_RX_BRAM/2); % struct.adcx alike

    for board_id = 1:N_board
        
        fieldName1 = matlab.lang.makeValidName(['B' num2str(board_id)]);
        
        B_all_adcsum = B_all_adcsum + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc0 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc1 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc2 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc3 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc4 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc5 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc6 + ...
            multiBoard_multiAng_adcData.(fieldName1).(fieldName2).adc7;

    end


    B_all_adcsum = B_all_adcsum - mean(B_all_adcsum);

    plot(real(B_all_adcsum))

    amp(ii) = sqrt(mean(abs(B_all_adcsum).^2));

end


figure
plot(Angle, amp)

figure
plot(Angle, mag2db(amp))

% 得出该ZTang的所有adc数据之和的单音幅度值


%% TX 俯仰角测试
%测试的频点
% measfreq = [6.8 6.95 7.1];
% measfreq = [6.95];
measfreq = [6.75];
% measfreq = [7.15];
%波束偏转角度
Beamdirect = -60:10:60;
%转台角度
Start_Angle = -90;
Stop_Angle  = 90;
AStep=1;
Angle=Start_Angle:AStep:Stop_Angle;

%初始化转台在-90°
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，


%% 
% 初始化矩阵来存储数据，假设每个频点旋转角度从-90到90度，步进1度
% 每1度，都读取频谱仪此时测量的信道的所有频率的功率值
% 每个频点有181个角度测量
recv_pw_peak = zeros(length(Angle),length(Beamdirect));

for i = 1:length(measfreq)
    % 每个频点画一幅图
    figure;
    legends = cell(length(Beamdirect),1);
    for j = 1:length(Beamdirect)
        func_phase_array_beam_direct_to(COMHUB_EM, 0, Beamdirect(j)); %偏转俯仰角角
        pause(0.5);
        if(j ~= 1) % 除了首次启动转台，其他情况都需要等待转台回到开始位置
            classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,20,0.1);  %1可能是控制的轴编号，Start_Angle是转到目标位置，
            pause(11); % 速度20时，转90°大约耗时4.9s。
            fprintf("转台已回到起始位置。下一个波束号%d(角度%d°)\n", j, Beamdirect(j));
        end
        for ii = 1:length(Angle)
                classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 5, 0.1);
                pause(0.4);
                fprintf(SAObj, 'CALC:MARK1:Y?');  % 读取Marker 1的幅度（Y轴）
                markerAmplitude = fscanf(SAObj, '%f');  % 幅度值
                recv_pw_peak(ii, j) = markerAmplitude;  % 将数据存储在矩阵中，-90°对应矩阵中的第1行
        end
        %保存数据
        fileName=['mat\pitch_scan' num2str(measfreq(i)) 'GHz' num2str(Beamdirect(j)) 'angle' char(datetime('now','Format','yMdHHmm')) '.mat'];
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

%% 关闭一个模组

func_channel_switch(COMHUB_EM.com6,0,8,8,isTX,1);
fprintf('已关闭通道。\n')

%% Function


function HitCallbackFcn(src,evnt) % 当点击图例后执行的自定义函数
    if strcmp(evnt.Peer.Visible,'on')
        evnt.Peer.Visible = 'off';
    else
        evnt.Peer.Visible = 'on';
    end
end