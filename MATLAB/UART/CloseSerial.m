% function CloseSerial(scom)  
% try  
% fclose(scom);  
% catch err  
% fprintf('%s�ر�ʧ�ܡ�', scom.Name);  
% return  
% end  
% delete(scom);  
% clear scom;
% 
% %% �ر����ж˿�
% portA = instrfind;%INSTRFIND;
% if ~isempty(portA)
%     fclose(portA);%�ر����ж˿�
%     delete(portA);
% end
% clear portA;
% end 


%% �رմ��ж˿�
% ���������������ر�ת̨�����ӣ����Խ����Ķ˿ں�����У���Ϊת̨���Ӻ���ѧ���㲻�û����ˣ�
Port_whiteList = {'COM5'};  % cell����

portA = instrfind;
for j = 1:length(portA)
    if strcmp(portA(j).type, 'serial')
        currentPort = portA(j).Port;
        
        % ʹ��ismember����Ƿ��ڰ�������
        if ~ismember(currentPort, Port_whiteList)
            fclose(portA(j));
            delete(portA(j));
            fprintf('�ѹرմ���: %s\n', currentPort);
        else
            fprintf('��������������: %s\n', currentPort);
        end
    end
end