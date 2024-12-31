% MATLAB DAQ Script for the Rohde & Schwarz ZVA40 Vector Network Analyzer
% ZVA40 Init

% clear all;
% close all;
% clc;
% INSTRFIND
%instrumentVISAAddress = 'TCPIP0::192.168.1.100::hpib7,16::INSTR';
instrumentVISAAddress = 'TCPIP0::192.168.1.100::inst0::INSTR';
portA = instrfind;%INSTRFIND;
for j = 1:length(portA)
    if ~isempty(portA)
        if ~strcmp( portA(j).type, 'serial')
            fclose(portA(j));
            delete(portA(j));
        end
    end
end

%%
% Create a VISA connection to interface with instrument
instrObj = visa('agilent',instrumentVISAAddress);
set(instrObj,'InputBufferSize',10000);
set(instrObj,'TimeOut',0.1); 
fopen(instrObj);
% Display information about instrument
IDNString = query(instrObj,'*IDN?');
fprintf('Connected to: %s\n',IDNString);
% query(instrObj,'*RST')
START=27.5;
STOP=28.5;
VNA_Power=-10;%dBm
VNA_IF_BW=500;%5k Hz
NUMBEROFPOINTS=101;
FREQ = START+(STOP-START)/(NUMBEROFPOINTS-1)*(0:NUMBEROFPOINTS-1);
%%
try
fprintf(instrObj,sprintf('SOURce:POWer:LEVel %s',num2str(VNA_Power)));
fprintf(instrObj,'CALCulate:PARameter:DEFine ''Trc1'',S12');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''Trc2'',S12');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''Trc3'',S21');
fprintf(instrObj,'CALCulate:PARameter:DEFine ''Trc4'',S21');
% % 
% % % Create a new display window and turn it on 重新创建1号窗口
fprintf(instrObj,'DISPlay:WINDow1:STATE ON');
% % 
% % % Associate the measurements to WINDow1
fprintf(instrObj,'DISPlay:WINDow1:TRACe1:FEED ''Trc1''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe2:FEED ''Trc2''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe3:FEED ''Trc3''');
fprintf(instrObj,'DISPlay:WINDow1:TRACe4:FEED ''Trc4''');
% 
% % Turn ON the Title, Frequency, and Trace Annotation to allow for
% % % visualization of the measurements on the instrument display
fprintf(instrObj,'DISPlay:WINDow1:TITLe:STATe ON');
fprintf(instrObj,'DISPlay:ANNotation:FREQuency ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe1:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe2:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe3:STATe ON');
fprintf(instrObj,'DISPlay:WINDow1:TRACe4:STATe ON');
% 
% % Turn OFF averaging
% fprintf(instrObj,'SENSe1:AVERage:STATe OFF');

    [DATA, COUNT, MSG] = query(instrObj,sprintf('SENSe1:SWEep:POINts %s',num2str(NUMBEROFPOINTS)));
    [DATA, COUNT, MSG] = query(instrObj,sprintf('SENSE1:FREQUENCY:START %f GHZ; STOP %f GHZ',START,STOP));
     % fprintf(instrObj,'SENSe1:BANDwidth:RESolution 5 KHz');
    fprintf(instrObj,sprintf('SENSe1:BANDwidth %s',num2str(VNA_IF_BW)));
    [FREQ_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA:STIMULUS?');
    %[DATA, COUNT, MSG] = query(instrObj,'DISPLAY:WINDOW1:TRACE1:Y:SCALE:AUTO ONCE');
    FREQ = str2num(FREQ_STRING); 
    catch
    sprintf('VISA Error...')
    fclose(instrObj); 
end

