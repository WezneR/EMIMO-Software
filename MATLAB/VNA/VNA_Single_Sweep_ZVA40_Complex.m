try


%     fprintf('\nMeasuring S11...\n');
%     [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''TRC1'', ''S11''');
%     
%     [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT MAGNITUDE');
%     [S11_MAGNITUDE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
%     
%     [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT PHASE');
%     [S11_PHASE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
if TR==0    
    fprintf('Measuring S12...\n');
%    [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''Trc2'', ''S12''');
     fprintf(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''Trc2'', ''S12''');
    [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT MAGNITUDE');
    [S12_MAGNITUDE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');    
    [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT PHASE');
    [S12_PHASE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
else

    fprintf('Measuring S21...\n');
    %[DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''Trc3'', ''S21''');
    fprintf(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''Trc3'', ''S21''');
    [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT MAGNITUDE');
    [S21_MAGNITUDE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');%     
    [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT PHASE');
    [S21_PHASE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
end


%     fprintf('Measuring S22...\n');
    %[DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:PARAMETER:SDEFINE ''TRC4'', ''S22''');      
%     [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT MAGNITUDE');
%     [S22_MAGNITUDE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
%     
%     [DATA, COUNT, MSG] = query(instrObj,'CALCULATE1:FORMAT PHASE');
%     [S22_PHASE_STRING, COUNT, MSG] = query(instrObj,'CALCULATE1:DATA? FDATA');
%        
    catch
    sprintf('VISA Error...')
    fclose(instrObj); 
end
%%
% S11_MAG= str2num(S11_MAGNITUDE_STRING);
% S11_PHASE = str2num(S11_PHASE_STRING);
if  TR==0 
S12_MAG = str2num(S12_MAGNITUDE_STRING);
S12_PHASE = str2num(S12_PHASE_STRING);%degree
S12=10.^(S12_MAG/20).*exp(1j*S12_PHASE/180*pi);
else
S21_MAG = str2num(S21_MAGNITUDE_STRING);
S21_PHASE = str2num(S21_PHASE_STRING);
S21=10.^(S21_MAG/20).*exp(1j*S21_PHASE/180*pi);
end
% S22_MAG = str2num(S22_MAGNITUDE_STRING);
% S22_PHASE = str2num(S22_PHASE_STRING);