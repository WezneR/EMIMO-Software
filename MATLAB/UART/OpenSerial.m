%scom =OpenSerial('com3', 115200, @ReadFcn_Com)
function scom = OpenSerial(sname, BaudRate ,HReadFcn)  
scom = serial(sname); 
scom.BaudRate = BaudRate;
scom.BytesAvailableFcnMode = 'terminator';  
scom.Terminator = 'CR/LF';  
scom.BytesAvailableFcnMode = 'byte';%�жϴ����¼�Ϊ��bytes-available Event��
scom.BytesAvailableFcnCount = 2;%���ջ�����ÿ�յ�2���ֽ�ʱ�������ص�����
scom.BytesAvailableFcn = HReadFcn;  

try  
fopen(scom);  
catch err  
fprintf('%s��ʧ�ܡ�\n', sname);  
fprintf('----------------Error---------------- \n');  
disp(err.message);
fprintf('------------------------------------- \n'); 
return;
end  
fprintf('%s�ɹ��򿪡�\n', sname);  
end  
