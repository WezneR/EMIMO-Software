CloseSerial;
clear all;
%%
baudrate = 921600;

%% 识别串口号
tic
devices = IdentifySerialComs()
toc
%% 打开串口
comstr = sprintf('com%d',devices{2});
scom = OpenSerial(comstr, baudrate, @ReadFcn_Com);

%% 写串口
init_array = hex2dec(['54';'4D';'3A'; ...
                      'AA';'BB';'CC';'DD';'EE';'FF'; ...
                      '0D';'0A']);                      

fwrite(scom,init_array);

%% 写串口
% Write_buf = 'TM:Hello!';
% WriteSerial(scom,Write_buf);

%% 关闭串口
CloseSerial;