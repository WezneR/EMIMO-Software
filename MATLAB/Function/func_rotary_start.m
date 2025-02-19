function Far_dB = func_rotary_start(classObj, Angle, isTX, varargin)
%FUNC_ROTARY_START 此处显示有关此函数的摘要
%   此处显示详细说明
%   
%   调用此函数前：
%       - 载入转台，包括加载DLL和连接COM口
%   Input
%       - classObj:SPLibClass类型，由SerialPortLibrary.SPLibClass()返回，用于转台控制。
%       - Angle:整数行向量。需要扫描的角度数构成的行向量。例如，当需要转台从-90°转到90°、以1°为步进测量时，Angle = -90:90。
%       - isTX:整数，1表示TX，0表示RX。
%       - varargin: 可选参数，包括 'loop_indicator_j', 'loop_indicator_k', 'vna_use'。
%   Output
%       - Far_dB: 空口增益，即矢网读数的dB值。该变量的行表示不同的频点，列表示转台不同的角度。因此行数等于
%        VNA_Init 初始化时使用的校准集的扫描点数，列数等于 Angle 的长度 。

% 初始化可选参数
loop_indicator_j = [];
loop_indicator_k = [];
% 如果沒有指定VNA_USE，默認使用VNA_USE='P5005A'
VNA_USE = 'P5005A';

% 解析可选参数
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'loop_indicator_j'
            loop_indicator_j = varargin{i+1};
        case 'loop_indicator_k'
            loop_indicator_k = varargin{i+1};
        case 'vna_use'
            VNA_USE = varargin{i+1};
        otherwise
            error('Unknown optional parameter: %s', varargin{i});
    end
end
% 如果外部指定了循环变量，则在测量时显示它。如果没有指定，则默认值是0。
if ~isempty(loop_indicator_j)
    VNA_Single_Sweep_Fast_loopIndicator.j = loop_indicator_j;
end
if ~isempty(loop_indicator_k)
    VNA_Single_Sweep_Fast_loopIndicator.k = loop_indicator_k;
end


% 初始化矢网
VNA_Init;
% 行表示频点，列表示角度
Far_Mag = zeros(numPoints,length(Angle));
Far_Rad = zeros(numPoints,length(Angle));
Far_dB = zeros(numPoints,length(Angle));
% Far_Deg = zeros(numPoints,length(Angle));


% S12, S21 在 rawData 中的列索引，请在 VNA_Single_Sweep_3672E 中检查。
S12_index = 3;
S21_index = 2;
% 转台上的设备接矢网端口1，因此当 isTX = True 时，S21表示增益。否则 S12表示增益。
if isTX
    Sp_index = S21_index;
else
    Sp_index = S12_index;
end


VNA_Single_Sweep;

for ii=1:length(Angle)
    
    classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(ii), 2, 0.1);
    pause(0.2);
    VNA_Single_Sweep_Fast_loopIndicator.i = ii;
    VNA_Single_Sweep_Fast;
    Far_Mag(:,ii) = sparamMag(:,Sp_index);
    Far_Rad(:,ii) = sparamPhase(:,Sp_index);
    Far_dB(:,ii)  = 20 * log10(abs(Far_Mag(:,ii)));
    
end
% 转台回到Start位置
classObj.MoCtrCard_MCrlAxisAbsMove(1, Angle(1), 5, 0.1);

user_confirm = 0;
while ~user_confirm
    user_confirm = input("当转台回到Start位置时，请输入'1'回车：\n");
end


end

