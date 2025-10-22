% function CloseSerial(scom)  
% try  
% fclose(scom);  
% catch err  
% fprintf('%s关闭失败。', scom.Name);  
% return  
% end  
% delete(scom);  
% clear scom;
% 
% %% 关闭所有端口
% portA = instrfind;%INSTRFIND;
% if ~isempty(portA)
%     fclose(portA);%关闭现有端口
%     delete(portA);
% end
% clear portA;
% end 


%% 关闭串行端口
% 白名单。如果不想关闭转台的连接，可以将它的端口号填到其中（因为转台连接很玄学，搞不好会闪退）
Port_whiteList = {'COM5'};  % cell数组

portA = instrfind;
for j = 1:length(portA)
    if strcmp(portA(j).type, 'serial')
        currentPort = portA(j).Port;
        
        % 使用ismember检查是否在白名单中
        if ~ismember(currentPort, Port_whiteList)
            fclose(portA(j));
            delete(portA(j));
            fprintf('已关闭串口: %s\n', currentPort);
        else
            fprintf('保留白名单串口: %s\n', currentPort);
        end
    end
end