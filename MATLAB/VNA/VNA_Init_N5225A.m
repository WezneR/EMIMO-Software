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
% instrumentVISAAddress = 'TCPIP0::192.168.1.145::inst0::INSTR';%VNA N5245A
instrumentVISAAddress = 'TCPIP0::192.168.1.5::hislip0::INSTR';%VNA N5225A
% instrumentVISAAddress = 'TCPIP0::A-N5225A-51333.local::inst0::INSTR';%VNA N5225A

% Define frequency range of 5.25GHz to 5.75GHz

 frequencyRange = [24e9 32e9];
 
% Number of points in measurement
numPoints = 401;
% data=zeros(10,6401);

% Cal_Set='2031';%校准数据集名
% Cal_Set='cal10_35G';




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
    % Perform a System Preset

    %fprintf(instrObj,'SYSTem:FPReset');
    %清除所有当前队列与状态
     fprintf(instrObj,'*CLS');
    % Wait till system is ready as Preset could take time
    opcStatus = 0;
    while(~opcStatus)
       opcStatus = str2double(query(instrObj, '*OPC?'));
    end

    %删除当前仪表中所有measurement
    fprintf(instrObj,'CALC:PAR:DEL:ALL');

    opcStatus = 0;
    while(~opcStatus)
       opcStatus = str2double(query(instrObj, '*OPC?'));
    end

    %关闭1号窗口
    fprintf(instrObj,'DISPlay:WINDow1:STATE OFF');


    %应用校准数据
%     fprintf(instrObj,sprintf('SENS:CORR:CSET:ACT "%s",1',Cal_Set));


    opcStatus = 0;
    while(~opcStatus)
       opcStatus = str2double(query(instrObj, '*OPC?'));
    end

%创建空的测量数据矩阵
% numPoints = str2double(query(instrObj,' SENSe:SWEep:POINts?'));

% Define a measurement name and parameter
%fprintf(instrObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS11'',S11');
%fprintf(instrObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS12'',S12');
%fprintf(instrObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS21'',S21');
%fprintf(instrObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS22'',S22');

fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS11'',S11');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS12'',S12');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS21'',S21');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS22'',S22');

% Create a new display window and turn it on 重新创建1号窗口
fprintf(instrObj,'DISPlay:WINDow1:STATE ON');

% Associate the measurements to WINDow1
fprintf(instrObj,'DISPlay:WINDow1:TRACe1:FEED ''SParamMeaS11''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe2:FEED ''SParamMeaS12''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe3:FEED ''SParamMeaS21''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe4:FEED ''SParamMeaS22''');

% Turn ON the Title, Frequency, and Trace Annotation to allow for
% visualization of the measurements on the instrument display
fprintf(instrObj,'DISPlay:WINDow1:TITLe:STATe ON');
fprintf(instrObj,'DISPlay:ANNotation:FREQuency ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe1:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe2:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe3:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe4:STATe ON');

% Turn OFF averaging
fprintf(instrObj,'SENSe1:AVERage:STATe OFF');

% % Set the number of points
fprintf(instrObj, sprintf('SENSe:SWEep:POINts %s',num2str(numPoints)));
% 
% % Set the frequency ranges
 fprintf(instrObj, sprintf('SENSe:FREQuency:STARt %sHz',num2str(frequencyRange(1))));
 fprintf(instrObj, sprintf('SENSe:FREQuency:STOP %sHz',num2str(frequencyRange(2))));
 
 
 
fprintf(instrObj,'SOUR:POW1 -5');
fprintf(instrObj,'SOUR:POW2 -5');