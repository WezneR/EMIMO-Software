CloseSerial;
clear all;
%%
baudrate = 921600;

%% ʶ�𴮿ں�
tic
devices = IdentifySerialComs()
toc
%% �򿪴���
comstr = sprintf('com%d',devices{2});
scom = OpenSerial(comstr, baudrate, @ReadFcn_Com);

%% д����
init_array = hex2dec(['54';'4D';'3A'; ...
                      'AA';'BB';'CC';'DD';'EE';'FF'; ...
                      '0D';'0A']);                      

fwrite(scom,init_array);

%% д����
% Write_buf = 'TM:Hello!';
% WriteSerial(scom,Write_buf);

%% �رմ���
CloseSerial;