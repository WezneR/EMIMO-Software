`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SEU_MMW
// Engineer: XXQ
// 
// Create Date:    10:23:40 07/20/2020 
// Design Name: 
// Module Name:    UART_RX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: ���ڽ��ճ���ͨ���౶��������ȷ���������ݣ������ڲ�������ȥ������̬��ë�̣�֧�ֶ������ʵĴ����Լ�֧�ָ������ݸ�ʽ��ֹͣλ��ʽ��֧����żУ�顣
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module UART_RX #( 
    //Ĭ�ϲ�����=9600  ֧�� 4800 9600 19200 57600 115200 230400 460800 921600 
    parameter  Baud_rate = 115200, 
    //Ĭ��ʱ��Ƶ��100MHz �����100MHz ����С��250MHz
    parameter  clk_frq = 100000000,  
    //Ĭ���������Ϊ36������֧�����data_depth�Ľ��պͷ��� ������󲻳���63���������63����ı������ send_data_bytes��receive_data_bytes
    parameter  uart_max_byte_len = 10  
) 
(
    
    //����ʱ�� ��clk_frq��ƥ��
    input  wire clk,             
    //��λ���͵�ƽ��λ
    input  wire rst,             

    //����bit ֧��5 6 7 8 λ
    input  wire [3:0] data_bits, 
    //ֹͣλ��00=1λֹͣλ��01=1.5λֹͣλ��10=2λֹͣλ
    input  wire [1:0] stop_bits, 
    //У��λ��00=��У��λ�� 01=żУ��10=��У��
    input  wire [1:0] parity,    

    //���յ�����  ���ݿ�����λ   00_00_����00_XX_XX_XX  (XXΪ��Ч���ݣ���λΪ��һ���ֽ�)
    output reg  [uart_max_byte_len*8-1:0] receive_data, 
    //���յ�����  ���ݿ�����λ  XX_XX_XX_00_00_����00  (XXΪ��Ч���ݣ���λΪ��һ���ֽ�)
    output reg  [uart_max_byte_len*8-1:0] receive_data_, 
    //���յ����ݵ�֡����ֻ�е�����λ=8 bitsʱ����ֵ�ű�ʾ�������ݵ��ֽ�����
    output reg  [5:0] receive_data_bytes,        
    //���յ������Ƿ�������żУ�飨�����������żУ�鹦�ܣ�1��ʾ��ȷ���ݣ�0��ʾ����ȷ���ݣ���ÿ��bit�������ֽڵ���ȷ��
    output reg  [uart_max_byte_len-1:0] receive_data_check, 
    //���յ����ݴ���ȷ�� 1��ʾ��ȷ��0��ʾ����
    output reg  receive_data_check_all, 

    //������һ�ε��жϱ�־
    output reg  RX_interrupt,
    //��������жϱ�־
    input  wire RX_interrupt_clear,         

    //����RX��
    input  wire RX                          
    ); 
    
    //��Ƶϵ��
    localparam  Baud_rate_division_factor = clk_frq/Baud_rate; 
    //����ʱ���
    localparam  Baud_rate_division_factor_2 = clk_frq/Baud_rate/2;   
    
    //�������ٸ�bit���ڽ��ղ�����ʼλ ���ν����������
    localparam  RX_complete = 3;
    
    reg  [3:0] sig_rx;
    
    //��Ϊ���첽��ȡ�źţ�ͨ���༶�Ĵ�������ֹ��������̬,����ԭ��� https://www.cnblogs.com/linjie-swust/archive/2012/01/07/YWT.html
    always @ (posedge clk ) 
    //��ʼ��sig_rx
    begin 
        if(~rst) sig_rx <= 4'b1111;
        else sig_rx <= {sig_rx[2:0],RX};
    end
    
    reg [6:0] sig_maoci;
    
    //ȥ������̬֮���ë���źţ�ȡ�����ߴ��źŲ��������ߵ�ƽ����>=4,��Ϊ�ߵ�ƽ������Ϊ�͵�ƽ
    always @ (posedge clk) 
    begin
        if(~rst) sig_maoci <= 7'b1111111;
        else sig_maoci <= {sig_maoci[5:0],sig_rx[3]};
    end
    
    wire [2:0] sig_maoci_sum;
    assign sig_maoci_sum = sig_maoci[0] + sig_maoci[1] + sig_maoci[2] +sig_maoci[3]+sig_maoci[4]+sig_maoci[5]+sig_maoci[6];
    
    wire RX_signal;
    
    //assign RX_signal = sig_rx[3]; //ֻ��������̬
    assign RX_signal = (sig_maoci_sum >= 4)? 1'b1:1'b0;
    
    //��Ƶ������
    reg [15:0] counter; 
    //���������ֽ�������
    reg [5:0]  RX_data_bytes_counter;
    //��������λbit������ 
    reg [3:0]  RX_data_bits_counter;
    //����ֹͣλbit������ 
    reg [3:0]  RX_stop_bits_counter;
    //���ս���æ
    reg        RX_busy;
    //�����ж���ǰ��־��=1��ʾ���һ�Σ�����֡��UART���ݵĽ���
    reg        RX_interrupt_;
    
    
    reg [2:0] RX_state;
    localparam                     RX_IDLE               = 0, //���տ���״̬
                                   RX_START_BIT_DETECTED = 1, //��⵽��ʼλ
                                   RX_START_BIT          = 2, //���ճ�����ʼλ
                                   RX_DATA_BITS          = 3, //���ճ�������λ
                                   RX_PARITY_BIT         = 4, //���ճ���У��λ
                                   RX_STOP_BIT           = 5; //���ճ���ֹͣλ
 
                                   

    
    reg [7:0] RX_once_data;
    reg       RX_once_parity_bit;
    wire check_bit; //ÿһ�ν����ֽڵ�У��λ
    assign check_bit = RX_once_data[0] + RX_once_data[1] + RX_once_data[2] + RX_once_data[3] + RX_once_data[4] + RX_once_data[5] + RX_once_data[6] + RX_once_data[7];

    always @ (posedge clk ) //����״̬�ı����
    begin
        if(~rst)
        begin
            counter <= 0;
            RX_data_bytes_counter <= 0;
            RX_data_bits_counter  <= 0;
            RX_stop_bits_counter  <= 0;
            RX_state <= RX_IDLE;
            RX_busy <= 0;
            
            receive_data <= 0;
				receive_data_ <= 0;
            receive_data_bytes <= 0;
            receive_data_check <= 0;
				receive_data_check_all <= 1;
            RX_interrupt <= 0;
				RX_interrupt_ <=0;
        end
        else  if(RX_busy)//���ڽ��н��գ�������չ���Ϊæµ
        begin
            if(counter == Baud_rate_division_factor - 1)
                counter <= 0;
            else
                counter <= counter + 1;
                
            if(counter == Baud_rate_division_factor_2-1)//ת���������״̬�����м�ת������״̬
            begin
                if(RX_state == RX_START_BIT_DETECTED) //��ʼλ����
                    RX_state <= RX_START_BIT;
                else if(RX_state == RX_START_BIT)//��һ״̬Ϊ������ʼλ 
                begin
                    RX_data_bits_counter <= 0;//���յ�һ��bit
                    RX_data_bytes_counter <= RX_data_bytes_counter+1;//�����ֽ���+1
                    RX_state <= RX_DATA_BITS;
                end
                else if(RX_state == RX_DATA_BITS)//��һ״̬Ϊ��������λ
                begin
                    if(RX_data_bits_counter == data_bits - 1) //�Ѿ���������һ���ֽڵ�����
                    begin
                        RX_data_bits_counter <= 0;
                        if( parity == 2'b01 || parity == 2'b10 ) //����żУ��λ,������żУ��λ
                            RX_state <= RX_PARITY_BIT;
                        else
                        begin
                            RX_state <= RX_STOP_BIT;
                            RX_stop_bits_counter  <= 0;
                        end
                    end
                    else
                    begin
                        RX_data_bits_counter <= RX_data_bits_counter + 1;//������һ��bit
                        RX_state <= RX_DATA_BITS;
                    end
                end
                else if(RX_state == RX_PARITY_BIT)//��һ״̬Ϊ���ճ���У��λ
                begin
                    RX_state <= RX_STOP_BIT;
                    RX_stop_bits_counter  <= 0;
                end
                else if(RX_state == RX_STOP_BIT)
                begin
                   RX_stop_bits_counter <= RX_stop_bits_counter + 1;
                   if(RX_stop_bits_counter == RX_complete)//����RX_complete��û���ٴμ�⵽��ʼλ�����δ������
                   begin
                        RX_busy <= 1'b0; //����״̬��Ϊ����
                        RX_state <= RX_IDLE; //������·λ����
								receive_data_ <= receive_data << (uart_max_byte_len - receive_data_bytes)*8;//�����ݷŵ����λ////////////////*******************
                        RX_interrupt_ <= 1'b1;//�������һ������
                   end
                end
            end
            else  if(counter == Baud_rate_division_factor_2)//���� ������ֹͣλ�������ݼĴ����ͽ��յ������Ƿ�������żУ��Ĵ���
            begin
                if(RX_state == RX_DATA_BITS) //��������
                begin
                    RX_once_data[RX_data_bits_counter] <= RX_signal; //
                end
                else if(RX_state == RX_PARITY_BIT)//������żУ��
                begin
                    RX_once_parity_bit <= RX_signal;
                end
                else if(RX_state == RX_STOP_BIT && RX_stop_bits_counter == 0)//��һ�γ���ֹͣλ���������ݼĴ��� ��ԭ�������ݼĴ������ư�λ�������µ����ݣ���ԭ���������Ĵ�������һλ���������µ����ݼ��λ
                begin
                    receive_data <= {receive_data[uart_max_byte_len*8-9 : 0],RX_once_data[7:0]};  //��ԭ�������ݼĴ������ư�λ�������µ�����
                    receive_data_bytes <= RX_data_bytes_counter;
                    if(parity == 2'b00 || (parity == 2'b01 && RX_once_parity_bit == check_bit) || (parity == 2'b10 && RX_once_parity_bit == ~check_bit) )  //��У���У����ȷ
						  begin
                        receive_data_check <= {receive_data_check[uart_max_byte_len-2 : 0],1'b1};
								receive_data_check_all <= receive_data_check_all && 1'b1;
						  end
                    else//У�����
						  begin
                        receive_data_check <= {receive_data_check[uart_max_byte_len-2 : 0],1'b0};
								receive_data_check_all <= receive_data_check_all && 1'b0;
						  end
                end
            end
            
            if(RX_state == RX_STOP_BIT) //�����ճ���ֹͣλ���ֳ�����ʼλ��˵���������ݴ���δ���
            begin
                if(RX_signal == 1'b0)
                begin
                    counter <= 0;
                    RX_state <= RX_START_BIT_DETECTED;
                end
            end
        end
        else  //����ģ�鴦�ڿ���״̬���ȴ���������
        begin
            if(RX_state == RX_IDLE && RX_signal == 1'b0) //��������·���ڿ���״̬���Ҽ�⵽�½��أ���ʼһ�ν���
            begin
                RX_busy <= 1'b1; //����״̬��Ϊæµ
                RX_data_bytes_counter <= 0;
                RX_data_bits_counter  <= 0;
                receive_data <= 0;//���ջ�����ȫ����0
					 receive_data_ <= 0;
                receive_data_bytes <= 0;
                receive_data_check <= 0;
					 receive_data_check_all <= 1;
                
                RX_once_data <= 0; //��ʱ����8λ���ݻ�����
                RX_once_parity_bit <= 0;  //��ʱ����У��λ
                
                counter <= 0;
                RX_state <= RX_START_BIT_DETECTED;
                
                RX_interrupt <= 0;
					 RX_interrupt_ <= 0;
            end
            else
            begin
					 if(RX_interrupt_ == 1)
					 begin
						RX_interrupt <= 1;
						RX_interrupt_ <= 0;
					 end
					 else
					 begin
						 if(RX_interrupt_clear == 1) //��������жϱ�־
							  RX_interrupt <= 0;
						 else 
							  RX_interrupt <= RX_interrupt;
					 end
            end
        end
    end
    
endmodule
