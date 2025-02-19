% 根据 VNA_USE 重定向到具体的VNA初始化脚本
switch VNA_USE
    case '3672E'
        VNA_Init_3672E;
    case 'P5005A'
        VNA_Init_P5005A;
    otherwise
        error('TODO: the VNA "%s" is not supported yet.', VNA_USE);
end
