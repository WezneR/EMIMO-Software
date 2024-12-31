%close all;
%clear all;

%%

% close all; clear all; clc;

%% 关闭所有端口
portA = instrfind;%INSTRFIND;
for j = 1:length(portA)
    if ~strcmp( portA(j).type, 'serial')
        fclose(portA(j));
        delete(portA(j));
    end
end


% if ~isempty(portA)
%     fclose(portA);%关闭现有端口
%     delete(portA);
% end
% clear portA;

% delete instrObj;
% clear instrObj;
%%

% Define instrument VISA address. The VISA address of the instrument
% may be obtained from the instrument's user interface or your VISA
% configuration utility

% instrumentVISAAddress = 'TCPIP0::192.168.1.147::hislip0::INSTR';%VNA N5247A
instrumentVISAAddress = 'TCPIP0::192.168.1.145::inst0::INSTR';%VNA N5245A
% instrumentVISAAddress = 'TCPIP0::192.168.1.5::hislip0::INSTR';%VNA N5225A
% instrumentVISAAddress = 'TCPIP0::A-N5225A-51333.local::inst0::INSTR';%VNA N5225A






    % Create a VISA connection to interface with instrument
    instrObj = visa('agilent',instrumentVISAAddress);
    % Set up connection parameters for transfer of measurement data from the
    % instrument
    instrObj.InputBufferSize = 10e6;
    instrObj.ByteOrder = 'littleEndian';
    % Open connection to the instrument and clear hardware buffer of instrument
    fopen(instrObj);
    clrdevice(instrObj);

    % Display information about instrument
    IDNString = query(instrObj,'*IDN?');
    fprintf('Connected to: %s\n',IDNString);
%%
fprintf(instrObj,'*CLS');
% Wait till system is ready as Preset could take time
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(instrObj, '*OPC?'));
end

%创建空的测量数据矩阵
numPoints = str2double(query(instrObj,' SENSe:SWEep:POINts?'));


% % Set the number of points
fprintf(instrObj, sprintf('SENSe:SWEep:POINts %s',num2str(numPoints)));


% Turn OFF averaging
fprintf(instrObj,'SENSe1:AVERage:STATe OFF');

