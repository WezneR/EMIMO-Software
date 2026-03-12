


%% 连接MIMO模组
clear ;
close all;
clc;

addpath(genpath('UART'));%生成指定的文件夹及其子文件的路径，并添加到matlab的搜索路径中。

%%
CloseSerial;



%% 识别串口号
baudrate = 115200;

tic
devices = IdentifySerialComs()   %IdentifySerialComs用于识别计算机链接的串口设备，输出为devices
toc

COM_VT = sprintf('com%d',devices{1,2});
COM = OpenSerial(COM_VT,baudrate,@ReadFcn_Com);

%% 帧格式
UART.Head = hex2dec(['55';'5D']);  
UART.Pause_Sec = 0.1; %Between each frame
UART.End = hex2dec(['0D';'0A']);
UART.End_mcu = hex2dec(['0A';'0D']);

Parket = hex2dec(['08';'00';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM,Frame);


%% 打开RX

Parket = hex2dec(['07';'04';'01';'00';'0D';'0A']);
Frame = [UART.Head; Parket];
fwrite(COM,Frame);

%% 读取原模组和子板ID
Parket = hex2dec(['08';'02';'00';'01';'0A';'0D']);
Frame = [UART.Head; Parket];
fwrite(COM,Frame);



%% 写入新ID




