%P5005A Init

%this script is used for Initing USB VNA P5005A

%State Key Lab of Millimeter Waves, SEU
%Created by Liyu Zhu
%Rev 0-Create Files
%2021.12.15

%%
portA = instrfind;%INSTRFIND;
for j = 1:length(portA)
    if ~strcmp( portA(j).type, 'serial')
        fclose(portA(j));
        delete(portA(j));
    end
end

%%
Cal_Set='2p7-3p2-201-2';%校准数据集名

% Number of points in measurement
numPoints=201;  

VNA_IF_BW=100000;%Hz
VNA_Power=-15;%dBm
frequencyRange = [2.7e9 3.2e9];
CalSet_En = 1; %Control whether the calset will be written

%%

% Define instrument VISA address. The VISA address of the instrument
% may be obtained from the instrument's user interface or your VISA
% configuration utility

instrumentVISAAddress = 'TCPIP0::Localhost::hislip_PXI10_CHASSIS1_SLOT1_INDEX0::INSTR';%VNA P5005A
% Create a VISA connection to interface with instrument
instrObj = visa('agilent',instrumentVISAAddress);
set(instrObj,'InputBufferSize',20000);
set(instrObj,'TimeOut',0.4); 
fopen(instrObj);
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

    opcStatus = 0;
    while(~opcStatus)
       opcStatus = str2double(query(instrObj, '*OPC?'));
    end

%创建空的测量数据矩阵
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS11'',S11');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS12'',S12');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS21'',S21');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''SParamMeaS22'',S22');

% Create a new display window and turn it on 重新创建1号窗口
fprintf(instrObj,'DISPlay:WINDow1:STATE ON');


% Apply the Calset  应用校准集
if CalSet_En
    fprintf(instrObj,sprintf('SENS:CORR:CSET:ACT ''%s'',1',Cal_Set));
    opcStatus = 0;
    while(~opcStatus)
       opcStatus = str2double(query(instrObj, '*OPC?'));
    end
end

% Associate the measurements to WINDow1
fprintf(instrObj,'DISPlay:WINDow1:TRACe1:FEED ''SParamMeaS11''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe2:FEED ''SParamMeaS12''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe3:FEED ''SParamMeaS21''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe4:FEED ''SParamMeaS22''');

% Turn ON the Title, Frequency, and Trace Annotation to allow for
% visualization of the measurements on the instrument display
% fprintf(instrObj,'DISPlay:WINDow1:TITLe:STATe ON'); 
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
 
 % IF band width
fprintf(instrObj,sprintf('SENSe1:BANDwidth %s',num2str(VNA_IF_BW)));

fprintf(instrObj,sprintf('SOURce:POWer:LEVel %s',num2str(VNA_Power)));

% VNA_Single_Sweep_Fast_loopIndicator 用于在循环中使用 fast sweep 采集数据时，指示循环变量的值
% VNA_Single_Sweep_Fast_loopIndicator结构体 在每个矢网的初始化脚本中被创建，在快速数据采集脚本VNA_Single_Sweep_xxxxx_Fast.m中被输出
VNA_Single_Sweep_Fast_loopIndicator = struct('i',0,'j',0,'k',0);
