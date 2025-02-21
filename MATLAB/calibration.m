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

COM_VT = sprintf('com%d',devices{1,2});
COM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);

%% 帧格式
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
fwrite(COM,init_Frame);

%% 打开开发者模式
Parket = hex2dec(['08';'00';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM,Frame);
fprintf('已打开开发者模式。')
%% 给ROM写入module 和 board，需要修改八次
Parket = hex2dec(['00';'07';'00';'00';'0A';'0D']);%parket的倒数第六和第五位十六进制分别表示moduleID和boardID,这里是第0个module的第0个board
Frame = [UART.Head; Parket];
fwrite(COM,Frame);

%% 通道打开
Parket = hex2dec(['10';'04';'02';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
%% 全部board全部的通道关闭
init_Parket = hex2dec(['08';'06';'00';'00']);
init_Frame = [UART.Head; init_Parket;UART.End];
fwrite(COM,init_Frame);

%% 阵面波束法向初始化
Parket = hex2dec(['08';'01';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('阵面已初始化为法相波束。')

%% 水平方向角
ang = -45;
ang_azimuth = dec2hex(round(ang/(180/256)), 2);

Parket = hex2dec(['08'; '00'; ang_azimuth; '00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)

Parket = hex2dec(['08';'05';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已改变波束方向角。')

%% 俯仰角
ang = -60;
ang_pitch = dec2hex(round(ang/(180/256)), 2);

Parket = hex2dec(['08'; '00'; '00'; ang_pitch]);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)

Parket = hex2dec(['08';'05';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已改变波束俯仰角。')

%% 中频衰减
Parket = hex2dec(['08';'0a'; '01';'3F']);  
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已更改TX中频衰减。')

%%
Parket = hex2dec(['08';'1a'; '01';'20']);  
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已更改RX中频衰减。')
%%  全部移相器衰减清零
 %衰减清零
Parket = hex2dec(['08';'83';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)

Parket = hex2dec(['08';'83';'01';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)
fprintf('已清除所有通道DSA。')

 %相位清零
Parket = hex2dec(['08';'82';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)

Parket = hex2dec(['08';'82';'01';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)
fprintf('已清除所有通道BF。')

Parket = hex2dec(['08';'82';'10';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1)

Parket = hex2dec(['08';'82';'11';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已清除所有通道AC。')
pause(0.1)

Parket = hex2dec(['08';'05';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
fprintf('已更新相位。')

%% 单个module ,读取每个通道初始相位和初始幅度

%每个module 有 8个board ,每个board 有8个天线的单元

% board0      board1      board2      ......      board7
%    #0          #0
%    #1
%     ...
%    #7


VNA_Init; %校准文件、频率范围、频点数在这里修改

numPoints=201; 
frequencyRange = [2.7e9 3.2e9];
Freq_MK_point = 101; %取2.95GHz处的值
Freq_MK2_point = 41:2:161;

loop = 1;%读取三次,取平均值
phase_init = zeros(8,8);
amp_init = zeros(8,8);
% phase_init = zeros(8,2);
% amp_init = zeros(8,2);

Module_ID = 1;
isTX = 0;%发射或者接收模式 
VNA_Single_Sweep;%必须先运行这个，才可以运行fast
pause(0.1);

for bi = 0:7 % from board 1 to board 8
    for i = 0:7
        a = zeros(1,loop);
        p = zeros(1,loop);

        Byte3 = [num2str(Module_ID) num2str(bi)];
        Byte2 = [num2str(i) '4'];

        if isTX
            Byte1 = '02';
            sp = 2;
        else
            Byte1 = '01';
            sp = 3;
        end
        Parket = hex2dec([Byte3;Byte2; Byte1;'00']);  
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.02);
        VNA_Single_Sweep_Fast_loopIndicator.j=bi;
        VNA_Single_Sweep_Fast_loopIndicator.k=i;
        for j = 1:loop
            VNA_Single_Sweep_Fast;
            a(j) = 20*log10(mean(sparamMag(Freq_MK2_point,sp)));
            p(j) = sparamPhase(Freq_MK_point,sp)/pi*180;
        end
            amp_init(i+1,bi+1) = sum(a)/loop;
            phase_init(i+1,bi+1) = sum(p)/loop;
        % close all channels of all boards
        init_Parket = hex2dec(['08';'06';'00';'00']);
        init_Frame = [UART.Head; init_Parket;UART.End];
        fwrite(COM,init_Frame);
        pause(0.02);
    end
end

%%

if isTX
    amp_TX_init = amp_init;
    phase_TX_init = phase_init;
else
    amp_RX_init = amp_init;
    phase_RX_init = phase_init;  
end
fprintf("已赋值init。")

%% 单独测量某一个通道

Parket = hex2dec(['01';'34';'02';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.5);

VNA_Single_Sweep_Fast;
amp = 20*log10(sparamMag(Freq_MK_point,sp));
pha = sparamPhase(Freq_MK_point,sp)/pi*180;
pause(0.5);

init_Parket = hex2dec(['08';'06';'00';'00']);
init_Frame = [UART.Head; init_Parket;UART.End];
fwrite(COM,init_Frame);


%% 單獨控制單個通道衰減
Module_id = 1;
board_id = 8;
PS_Chip_ID = 8 ;
channel_id = 0;
att = '00' ;

Parket = hex2dec([[num2str(Module_id) num2str(board_id)];[num2str(PS_Chip_ID) '3']; ['0' num2str(channel_id)];att]);  
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
%% 单独控相位
board_id =1 ;
PS_Chip_ID = 1 ;
channel_id = 1 ;
att = '0a' ;

Parket = hex2dec([[num2str(Module_ID) num2str(board_id)];[num2str(PS_Chip_ID) '2']; ['0' num2str(channel_id)];att]);  
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.5);

Parket = hex2dec([[num2str(Module_ID) num2str(board_id)];'05';'00';'00']);
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);
pause(0.1);

%% 比较各通道和相位和幅度
% 校准完成的module，各个单元指向同一个方向，幅度相同

%计算 TX的 phase delta
phase_TX_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        phase_TX_delta(i,j) = round((phase_TX_init(i,j)-min(min(phase_TX_init)))/1.41);
    end
end

old_data = load("mat\pahse_TX_delta202411252022.mat");


phase_TX_delta = phase_TX_delta + old_data.phase_TX_delta;

phase_TX_delta = phase_TX_delta - min(phase_TX_delta(:));

phase_TX_delta = mod(phase_TX_delta,256);




%计算TX的 amp delta
amp_TX_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        amp_TX_delta(i,j) = round((amp_TX_init(i,j)-min(min(amp_TX_init)))/0.125);
    end
end

old_data = load("mat\amp_TX_delta202411251956.mat");

amp_TX_delta = amp_TX_delta + old_data.amp_TX_delta;

amp_TX_delta = amp_TX_delta - min(amp_TX_delta(:));

%计算RX的 amp delta
amp_RX_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        amp_RX_delta(i,j) = round((amp_RX_init(i,j)-min(min(amp_RX_init)))/0.125);
    end
end

old_data = load("mat\amp_RX_delta202411252122.mat");

amp_RX_delta = amp_RX_delta + old_data.amp_RX_delta;

amp_RX_delta = amp_RX_delta - min(amp_RX_delta(:));



%计算 RX的 phase delta
phase_RX_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        phase_RX_delta(i,j) = round((phase_RX_init(i,j)-min(min(phase_RX_init)))/1.41);
    end
end

old_data = load("mat\pahse_RX_delta202411252129.mat");

phase_RX_delta = phase_RX_delta + old_data.phase_RX_delta;

phase_RX_delta = phase_RX_delta - min(phase_RX_delta(:));

phase_RX_delta = mod(phase_RX_delta, 256);

%%
fileName=['mat/amp_TX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'amp_TX_delta');

fileName=['mat/pahse_TX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'phase_TX_delta');


fileName=['mat/amp_RX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'amp_RX_delta');

fileName=['mat/pahse_RX_delta' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'phase_RX_delta');

%% 完成每个通道的初始移相和初始衰减
i = 0;
j = 0;
    
%校准TX的相位
for i = 0:7
    for j = 0:3
        for ci = 0:1
        Byte4 = [num2str(j) '2'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(phase_TX_delta(j*2+ci+1,i+1),2);
        Parket = hex2dec([['0' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.1);
        %更新相位
        Parket = hex2dec([['0' num2str(i)];'05';'00';'00']);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end

%校准TX的幅度
amp_TX_delta = amp_delta;
i = 0;
j = 0;
for i = 0:7
    for j = 0:3
        for ci = 0:1
        Byte4 = [num2str(j) '3'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(amp_TX_delta(j*2+ci+1,i+1),2);
        Parket = hex2dec([['1' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end

amp_RX_delta = amp_delta;
%校准RX的幅度
i = 0 ;
j = 4 ;
for i = 0:7
    for j = 4:7
        for ci = 0:1
        Byte4 = [num2str(j) '3'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(amp_RX_delta((j-4)*2+ci+1,i+1), 2);
        Parket = hex2dec([['1' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end


%校准RX的相位

for i = 0:7
    for j = 4:7
        for ci = 0:1
        Byte4 = [num2str(j) '2'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(phase_RX_delta((j-4)*2+ci+1,i+1),2);
        Parket = hex2dec([['0' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.02);
        %更新相位
        Parket = hex2dec([['0' num2str(i)];'05';'00';'00']);
        Frame = [UART.Head; Parket; UART.End];
        fwrite(COM,Frame);
        pause(0.02);
        end
    end
end

%% 打开通道，检测有没有校准成功
%RX
Parket = hex2dec(['08';'84';'01';'00']);%打开第0个module的全部board全部通道RX状态
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);

%TX
Parket = hex2dec(['08';'84';'02';'00']);%打开第0个module的全部board全部通道RX状态
Frame = [UART.Head; Parket; UART.End];
fwrite(COM,Frame);

%关闭通道
init_Parket = hex2dec(['08';'06';'00';'00']);
init_Frame = [UART.Head; init_Parket;UART.End];
fwrite(COM,init_Frame);


%% 写入ROM


%TX的相位
for i = 0:7
    for j = 0:3
        for ci = 0:1
        Byte4 = [num2str(j) '8'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(phase_TX_delta(j*2+ci+1,i+1),2);
        Parket = hex2dec([['0' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End_mcu];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end
fprintf('已将TX相位写入ROM。')


% amp_TX_delta = amp_delta;
%TX的幅度
for i = 0:7
    for j = 0:3
        for ci = 0:1
        Byte4 = [num2str(j) '9'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(amp_TX_delta(j*2+ci+1,i+1),2);
        Parket = hex2dec([['0' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End_mcu];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end
fprintf('已将TX幅度写入ROM。')


amp_RX_delta = amp_delta;
%RX的幅度 
for i = 0:7
    for j = 4:7
        for ci = 0:1
        Byte4 = [num2str(j) '9'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(amp_RX_delta((j-4)*2+ci+1,i+1), 2);
        Parket = hex2dec([['1' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End_mcu];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end
fprintf('已将RX幅度写入ROM。')

%RX的相位
for i = 0:7
    for j = 4:7
        for ci = 0:1
        Byte4 = [num2str(j) '8'];
        Byte5 = ['0' num2str(ci)];
        Byte6 = dec2hex(phase_RX_delta((j-4)*2+ci+1,i+1),2);
        Parket = hex2dec([['0' num2str(i)];Byte4;Byte5;Byte6]);
        Frame = [UART.Head; Parket; UART.End_mcu];
        fwrite(COM,Frame);
        pause(0.1);
        end
    end
end
fprintf('已将RX相位写入ROM。')

