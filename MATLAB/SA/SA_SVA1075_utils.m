% 设置一个Marker
fprintf(SAObj, 'CALC:MARK1:STATE OFF');  % 关闭Marker 1
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end

%%
% 设置Marker测量为Peak
fprintf(SAObj, 'CALC:MARK1:FUNC:PEAK OFF');  % 设置Marker为Peak测量模式
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end

%%
% 设置一个Marker
fprintf(SAObj, 'CALC:MARK2:STATE ON');  % 打开Marker 2
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end


%%
% 关闭所有光标
fprintf(SAObj, 'CALC:MARK:AOFF'); 
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end
%%
% 设置Marker测量为Peak
fprintf(SAObj, 'CALC:MARK2:FUNC:PEAK ON');  % 设置Marker为Peak测量模式
opcStatus = 0;
while (~opcStatus)
    opcStatus = str2double(query(SAObj, '*OPC?'));  % 等待命令执行
end