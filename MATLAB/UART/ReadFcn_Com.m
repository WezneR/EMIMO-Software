% 读串口回调函数
function ReadFcn_Com(obj, ~)
n = get(obj, 'BytesAvailable');
if n>2
    rxBUFFER = fread(obj, n, 'uchar');
    rxBUFFER = char(rxBUFFER');
    while (rxBUFFER(n) == 0) 
        n = n - 1;
        if (n == 2) 
            break;
        end
    end
    if rxBUFFER(n) == 10
        if rxBUFFER(n-1) == 13
            UART_RX_BUF = rxBUFFER(1:n-2);
            fprintf('%s\n', UART_RX_BUF);
            assignin('base','UART_RX_BUF',abs(UART_RX_BUF));
%             assignin('base','rxBUFFER',abs(rxBUFFER));
        end
    end
end
end
