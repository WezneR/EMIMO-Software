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
portA = instrfind;%INSTRFIND;
for j = 1:length(portA)
    if strcmp( portA(j).type, 'serial')
        fclose(portA(j));
        delete(portA(j));
    end
end
