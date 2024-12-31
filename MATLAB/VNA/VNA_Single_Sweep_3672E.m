%%
%3672E Single Sweep

%this script is used for Single Sweep VNA 3672E

%State Key Lab of Millimeter Waves, SEU
%Created by Liyu Zhu
%Rev 0-Create Files
%2020.11.02

index = 0;
%%
%使用外部触发源，产生一次触发信号
fprintf(instrObj,'TRIG:SOURce IMMediate');
 

% Autoscale display
%fprintf(instrObj, 'DISPlay:WIND:Y:AUTO');

% Select a single sweep across the frequency range to trigger a measurement
%设置仪表在触发信号到来时，进行一次测量，然后停止

fprintf(instrObj,':SENSe:SWEep:MODE SINGLE');

% Since the instrument may take time to make the measurement, wait until it
% is done before requesting measurement data
opcStatus = 0;
while(opcStatus~=1)
    opcStatus = str2double(query(instrObj, '*OPC?'));
end


% Set instrument to return the data back using binblock format
fprintf(instrObj, 'FORMat REAL,64');

% Set byte order to swapped (little-endian) format. SWAPped is required
% when using IBM compatible computers
 fprintf(instrObj, 'FORMat:BORDer SWAP');%SWAP表示高位字节和低位字节交换位置，反过来
% fprintf(instrObj, 'FORMat:BORDer NORM');  %210506,3672E,Datasheet error?


% Request 2-port measurement data from instrument
fprintf(instrObj, 'CALC:DATA:SNP:PORTs? ''1,2'''); %20170531 %N5225
% fprintf(instrObj, 'CALC:DATA:SNP? 2');%S2P 20170531


% opcStatus = 0;
% while(opcStatus~=1)
%     opcStatus = str2double(query(instrObj, '*OPC?'));
%     pause(0.1);
% end

% Read the measured data
rawDataDB = binblockread(instrObj, 'double'); 
fread(instrObj,1);

% Read back the number of points in the measurement and reshape the
% measurement data
numPoints = str2double(query(instrObj,' SENSe:SWEep:POINts?'));
% Reshape measurement data to [frequency, real, imag] array
rawDataDB = reshape(rawDataDB, numPoints, 9);

% Loop through the error queue and display all errors
systemError = '';

fprintf('#%d,\t',index);
while isempty(strfind(lower(systemError),'no error'))
    systemError = query(instrObj,'SYSTem:ERRor?');
    fprintf('System Error(s): %s',systemError);
end




% Store frequency range of the measurements
freqRange = rawDataDB(:,1);

% Convert retrieved magnitude info from dB
sparamMag = 10.^((1/20).*rawDataDB(:,2:2:8));

% Convert retrieved phase info from degrees to radians
sparamPhase = rawDataDB(:,3:2:9)*(pi/180);
sparamDegree = rawDataDB(:,3:2:9);

% Extract S-Parameter vectors
rawDataRI = sparamMag.*(cos(sparamPhase)+1i*sin(sparamPhase));
S11 = reshape(rawDataRI(:,1),1,1,numPoints);
S12 = reshape(rawDataRI(:,3),1,1,numPoints);
S21 = reshape(rawDataRI(:,2),1,1,numPoints);
S22 = reshape(rawDataRI(:,4),1,1,numPoints);

% Assemble into a 3D matrix to be consumed by the RF Toolbox
SParameter3Ddata = [S11 S12; S21 S22];