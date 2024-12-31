tic
% Generate_CtrlFrame;
% CtrlPacket;
% UART.CheckSum=rem(sum([UART.Head CtrlPacket]),256); 校验字节

% Mode 0 : 写入全0寄存器，全发射，幅度最大
% Mode 1 ：更新上下电、收发模式
% Mode 2 : 更新幅度相位控制字

PSA.PA_STA = 5;       %Used in Reg01, Ctrl PA, 0-7

switch (PSA.OpMode)
    
    case {0}        
        Ctrl_Chip = unique(Index_Chip);                                     %找到需要控制的芯片号(不重复)
        for i = 1:length(Ctrl_Chip)    
            CtrlPacket = hex2dec(['00';'00';'00';'00';'00']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['01';'00';'00';'55';'55']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['02';'00';'00';'00';'0F']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['03';'00';'00';'00';'0F']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['06';'00';'01';'00';'34']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['08';'00';'00';'00';'00']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['09';'00';'00';'00';'00']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['0A';'00';'00';'00';'00']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
            CtrlPacket = hex2dec(['0B';'00';'00';'00';'00']);  
            UART_Frame=[UART.Head; ...
                    Ctrl_Chip(i); ...
                    CtrlPacket; ...
                    UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
            
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    case {1} 
        %mode regs for all chips,including Reg 01-03
        
        Ctrl_Chip = unique(Index_Chip);                                     %找到需要控制的芯片号(不重复)
        CtrlPacket01 = hex2dec(['01';'00';'00';'00';'00']);  
        CtrlPacket02 = hex2dec(['02';'00';'00';'00';'00']);
        CtrlPacket03 = hex2dec(['03';'00';'00';'00';'0F']);
        for i = 1:length(Ctrl_Chip)                 
            CH_inArray = find(Index_Chip == Ctrl_Chip(i));                  %芯片对应的64通道中的通道编号
            Ctrl_Channel = Index_Channel( CH_inArray );                     %该芯片自身的通道编号
            Reg01_L16 = 0;
            Reg02_L8  = 0;
            Reg03_L2_8 = 0;
            for j = 1:length(Ctrl_Channel)
                Reg01_L16 = bitor(Reg01_L16,  PSA.Tx_ON(CH_inArray(j)) ... 
                            * PSA.PA_STA * power(2,4*Ctrl_Channel(j)-4) );
                %通道对应的PA状态
                
                Reg02_L8  = bitor(Reg02_L8,   PSA.Tx_ON(CH_inArray(j)) ... 
                            * power(2,Ctrl_Channel(j)-1));
                %bit3:0 CH4-CH1 TX enalble
                Reg02_L8  = bitor(Reg02_L8,   PSA.Rx_ON(CH_inArray(j)) ... 
                            * power(2,Ctrl_Channel(j)+3));
                %bit7:4 CH4-CH1 RX enalble
                
                Reg03_L2_8 = bitor(Reg03_L2_8,~Mode_TRX * power(2,Ctrl_Channel(j)));
                %[11:8] = Switch CH3-0, 0 = Tx on & Rx off
            end
            
            CtrlPacket01(5) = mod(Reg01_L16,256);
            CtrlPacket01(4) = idivide(Reg01_L16,uint8(256));
            
            CtrlPacket02(5) = Reg02_L8;
            
            CtrlPacket03(4) = Reg03_L2_8;
            
            UART_Frame=[UART.Head; ...
                            Ctrl_Chip(i); ...
                            CtrlPacket01; ...
                            UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);
                
            UART_Frame=[UART.Head; ...
                            Ctrl_Chip(i); ...
                            CtrlPacket02; ...
                            UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);  
            
            UART_Frame=[UART.Head; ...
                            Ctrl_Chip(i); ...
                            CtrlPacket03; ...
                            UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);  
            
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
    case {2}  
        %mode regs for channels,including Reg 08-0B
        Ctrl_Chip = unique(Index_Chip);                                     %找到需要控制的芯片号(不重复)
        CHPacket21 = hex2dec(['08';'00';'00';'00';'00']);  
        CHPacket43 = hex2dec(['09';'00';'00';'00';'00']);
%         PSA.Phase  = PSA.Pha_T * Mode_TRX + PSA.Pha_R * (~Mode_TRX);% 8bit:0~256
%         PSA.Att    = PSA.Att_T * Mode_TRX + PSA.Att_R * (~Mode_TRX);% 5bit:0~31, 0 is max mag, atten not work
%         PSA.RegPS  = Reg.TX_PS * Mode_TRX + Reg.RX_PS * (~Mode_TRX);
%         PSA.RegIQ  = Reg.TX_IQ * Mode_TRX + Reg.RX_IQ * (~Mode_TRX);
%         PSA.RegVGA = Reg.TX_VGA * Mode_TRX + Reg.RX_VGA * (~Mode_TRX);
        for i = 1:length(Ctrl_Chip)                 
            CH_inArray = find(Index_Chip == Ctrl_Chip(i));                  %芯片对应的64通道中的通道编号
            Ctrl_Channel = Index_Channel( CH_inArray );                     %该芯片自身的通道编号
            Tmp_L = zeros(1,length(Ctrl_Channel));
            Tmp_H = zeros(1,length(Ctrl_Channel));
            for j = 1:length(Ctrl_Channel)
                Reg_Index = PSA.Phase(CH_inArray(j)) + 1;                   %Reg Array index is 1-256        
                CH_inChip = Ctrl_Channel(j);
                Tmp_L(CH_inChip) =  PSA.RegPS(Reg_Index);
                
                Reg_VGAtmp = PSA.RegVGA(Reg_Index) + PSA.Att(CH_inArray(j));
                if(Reg_VGAtmp <= 0)
                    Reg_VGAtmp = 0;
                end
                Tmp_H(CH_inChip) =  PSA.RegVGA(Reg_Index)*4 + PSA.RegIQ(Reg_Index);
            end
            CHPacket21(5) = Tmp_L(1);
            CHPacket21(4) = Tmp_H(1);
            CHPacket21(3) = Tmp_L(2);
            CHPacket21(2) = Tmp_H(2);
            CHPacket21(1) = 8 + ~Mode_TRX*2;
            
            CHPacket43(5) = Tmp_L(3);
            CHPacket43(4) = Tmp_H(3);
            CHPacket43(3) = Tmp_L(4);
            CHPacket43(2) = Tmp_H(4);
            CHPacket43(1) = 9 + ~Mode_TRX*2; 
            
            UART_Frame=[UART.Head; ...
                            Ctrl_Chip(i); ...
                            CHPacket21; ...
                            UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);  
            
            UART_Frame=[UART.Head; ...
                            Ctrl_Chip(i); ...
                            CHPacket43; ...
                            UART.End];
            fwrite(COM,UART_Frame);   
            pause(UART.Pause_Sec);          
            
        end
        
        
    otherwise
            disp('Invalid Mode! Nothing will be written to Chip!')
end


% UART_Frame=[UART.Head CtrlPacket UART.End]
% fwrite(COM,UART_Frame,'uint8');
% UART_Back=(fread(COM,8,'uint8')).'; %回读
% 
% PSA.Temp_code=UART_Back(6)*256+UART_Back(7);
% PSA.Temp_deg=(PSA.Temp_code/1024*3.3*1000-776)/2.86;
% disp(sprintf('Temperature is %.2f °C\n', PSA.Temp_deg));






toc