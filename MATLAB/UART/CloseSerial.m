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
portA = instrfind;%INSTRFIND;
for j = 1:length(portA)
    if strcmp( portA(j).type, 'serial')
        fclose(portA(j));
        delete(portA(j));
    end
end
