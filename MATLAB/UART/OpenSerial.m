%scom =OpenSerial('com3', 115200, @ReadFcn_Com)
function scom = OpenSerial(sname, BaudRate ,HReadFcn)  
scom = serial(sname); 
scom.BaudRate = BaudRate;
scom.BytesAvailableFcnMode = 'terminator';  
scom.Terminator = 'CR/LF';  
scom.BytesAvailableFcnMode = 'byte';%中断触发事件为‘bytes-available Event’
scom.BytesAvailableFcnCount = 2;%接收缓冲区每收到2个字节时，触发回调函数
scom.BytesAvailableFcn = HReadFcn;  

try  
fopen(scom);  
catch err  
fprintf('%s打开失败。\n', sname);  
fprintf('----------------Error---------------- \n');  
disp(err.message);
fprintf('------------------------------------- \n'); 
return;
end  
fprintf('%s成功打开。\n', sname);  
end  
