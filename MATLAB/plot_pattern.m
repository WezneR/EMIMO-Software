clear all;
close all;
clc;
cd 'F:\MATLAB\EMIMO' %���õ�ǰ�ļ���·��
addpath(genpath('UART'));%����ָ�����ļ��м������ļ���·��������ӵ�matlab������·���С�
addpath(genpath('VNA'));
addpath(genpath('Script'));
addpath(genpath('Function'));


%%
CloseSerial;
clear COM;

% Choose the connected VNA 
VNA_USE = 'P5005A';
%% ʶ�𴮿ں� Far field ת̨����
baudrate = 115200;
tic
devices = IdentifySerialComs()   %IdentifySerialComs����ʶ���������ӵĴ����豸�����λdevices
toc


COM = open_serial_hub(baudrate, @ReadFcn_Com)

NET.addAssembly('F:\MATLAB\EMIMO\MCC4DLL.dll');%����һ��dll����
classObj = SerialPortLibrary.SPLibClass();
% �ҵ�ת̨�Ĵ��ڲ���
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'Prolific USB-to-Serial Comm Port')
        COM_ZT = sprintf('com%d',devices{i,2});
        break;
    end
end

classObj.MoCtrCard_Initial(COM_ZT);

%% ת̨����
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

%% ת��Startλ��
classObj.MoCtrCard_MCrlAxisAbsMove(1,Start_Angle,5,0.1);  %1�����ǿ��Ƶ����ţ�Start_Angle��ת��Ŀ��λ�ã�

pause(1);

%%

IF_gain_list = [0 8 16 24 31.5];

IFDSA_step = 0.5;

att_byte_list = dec2hex(IF_gain_list./IFDSA_step, 2);


% �ı���Ƶ����
att_byte_list(2,:)
func_IFDSA_write(COM, isTX, att_byte_list(2,:))

%% �򿪿�����ģʽ������ͨ����
func_dev_mode(COM, 1);
fprintf('�Ѵ򿪿�����ģʽ��')

func_channel_switch(COM, 0, 8, 8, isTX, 0)
fprintf('�Ѵ�����ͨ����')
pause(0.1);

%% ���沨����ʼ��
func_phase_array_beam_init(COM);
fprintf('��ִ�������ʼ����')
pause(0.1);


%%

ang = 45;
func_phase_array_beam_direct_to(COM, ang, 0);
pause(0.1)
func_ps_lacth_phase(COM);
pause(0.1)

fprintf('�Ѹı䲨������ǡ�')
pause(2)


%%

S12_index = 3; %�������� S12��������������޸�
S21_index = 2; %�ڶ����� S21��������������޸�
% ת̨�ϵ��豸��ʸ���˿�1����˵� isTX = True ʱ��S21��ʾ���档���� S12��ʾ���档
if isTX
    Sp_index = S21_index;
else
    Sp_index = S12_index;
end


VNA_Pause = 0.1;

% ���� VNA_Init ǰ��VNA���ڲ����½��κι켣
VNA_Init; %У׼�ļ���Ƶ�ʷ�Χ��Ƶ�����������޸�


%% ��ת
% �б�ʾƵ�㣬�б�ʾ�Ƕ�
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
% ת̨�ص�Startλ��
classObj.MoCtrCard_MCrlAxisAbsMove(1, Start_Angle, 5, 0.1);

Far_GaindB = Far_dB - repmat(max(Far_dB'), length(Angle), 1)';


Far_realizedGain_atAng = Far_dB(ang_MK_center, :)
Far_realizedGain_atFreqCenter = Far_dB(freq_MK_center, :);
Far_realizedGain_atFreqLower = Far_dB(freq_MK_lower, :);
Far_realizedGain_atFreqHigher = Far_dB(freq_MK_higher, :);

%% Close all
func_channel_switch(COM, Module_ID, 8, 8, isTX, 1);
%% �����ļ�

fileName=['mat\Far_dB_TX' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'Far_dB');

fileName=['mat\Far_dB_RX' char(datetime('now','Format','yMdHHmm')) '.mat'];
save(fileName,'Far_dB');


%% ���� ����-Ƶ�� ͼ
figure;
plot(freq_list, smooth(Far_realizedGain_atAng,1));

legend;

%% ���� ����-�Ƕ� ͼ������ͼ��
figure;
plot(Angle, Far_realizedGain_atFreqCenter);
hold on;
plot(Angle, Far_realizedGain_atFreqLower);
plot(Angle, Far_realizedGain_atFreqHigher);
legend("����Ƶ��", "��Ƶ��(2.8G)", "��Ƶ��(3.1G)");

