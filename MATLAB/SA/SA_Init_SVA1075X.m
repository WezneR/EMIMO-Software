% %% 关闭一切非串口设备
% portA = instrfind;%INSTRFIND;
% for j = 1:length(portA)
%     if ~strcmp( portA(j).type, 'serial')
%         fclose(portA(j));
%         delete(portA(j));
%     end
% end

%% 参数

CenterFreq = 6.0e9 ; %6.95GHz
Span = 400e6  ;  %400MHz

%% 初始化设置

%频谱仪的ip和端口
sva_ip = '192.168.0.2';
sva_port = 5025;

% 通过visa方式连接,需要下载NI-VISA驱动
try
SAObj=tcpip(sva_ip, sva_port);
SAObj.InputBufferSize = 10e6;  %设置缓冲区域
SAObj.ByteOrder = 'bigEndian';  %大端字节顺序
fopen(SAObj);  %打开设备接口
catch ME
    fprintf('Error connecting to the device: %s\n', ME.message);
    return;
end

% Display information about instrument
IDNString = query(SAObj,'*IDN?');
if isempty(IDNString)
    fprintf('Error: Unable to communicate with the device.\n');
    return;
else
    fprintf('Connected to: %s\n',IDNString);
end

%% 设置测量模式、参数和marker

%清除所有当前队列与状态
fprintf(SAObj,'*CLS');
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));%确认设备完成操作
end

fprintf(SAObj, ':INSTrument:SELECT GPSA'); %选择频谱分析模式
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));
end

% 设置中心频率
fprintf(SAObj, sprintf(':SENSe:FREQuency:CENTer %s',num2str(CenterFreq)));  
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));
end

% 设置频谱扫宽
fprintf(SAObj, sprintf(':SENSe:FREQuency:SPAN %s',num2str(Span)));  
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));
end

% 设置分辨率带宽
fprintf(SAObj, ':SENSe:BWIDTh:RESolution 1e6');  % 1 MHz
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));
end

% 启动一次扫描操作
fprintf(SAObj, ':INITiate:IMMediate');  

opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 检查扫描是否完成
end

% % 读取测量数据
% fprintf(SAObj, 'TRAC:DATA? TRACE1');
% traceData = fscanf(SAObj, '%s');
% disp('Trace Data:');
% disp(traceData);

% 设置一个Marker
fprintf(SAObj, 'CALC:MARK1:STATE ON');  % 打开Marker 1
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end

% 设置Marker测量为Peak
fprintf(SAObj, 'CALC:MARK1:FUNC:PEAK ON');  % 设置Marker为Peak测量模式
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end

% 读取Peak的频率和幅度
fprintf(SAObj, 'CALC:MARK1:X?');  % 读取Marker 1的频率（X轴）
markerFreq = fscanf(SAObj, '%f');  % 频率值
fprintf(SAObj, 'CALC:MARK1:Y?');  % 读取Marker 1的幅度（Y轴）
markerAmplitude = fscanf(SAObj, '%f');  % 幅度值

% 显示Peak值
disp(['Peak Frequency (Marker 1): ', num2str(markerFreq), ' Hz']);
disp(['Peak Amplitude (Marker 1): ', num2str(markerAmplitude), ' dBm']);
