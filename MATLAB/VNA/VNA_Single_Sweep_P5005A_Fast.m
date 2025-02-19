%%
% %使用外部触发源，产生一次触发信号
% fprintf(instrObj,'TRIG:SOURce IMMediate');

fprintf(instrObj,':SENSe:SWEep:MODE SINGLE');
% Since the instrument may take time to make the measurement, wait until it
% is done before requesting measurement data
opcStatus = 0;
while(opcStatus~=1)
    opcStatus = str2double(query(instrObj, '*OPC?'));
end

% Request 2-port measurement data from instrument
fprintf(instrObj, 'CALC:DATA:SNP:PORTs? ''1,2'''); %20170531 %N5225
% fprintf(instrObj, 'CALC:DATA:SNP? 2');%S2P 20170531

% Read the measured data
rawDataDB = binblockread(instrObj, 'double'); 
fread(instrObj,1);

% Reshape measurement data to [frequency, real, imag] array
rawDataDB = reshape(rawDataDB, numPoints, 9);

fprintf('#%d,%d,%d...\n',VNA_Single_Sweep_Fast_loopIndicator.i,VNA_Single_Sweep_Fast_loopIndicator.j,VNA_Single_Sweep_Fast_loopIndicator.k);

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