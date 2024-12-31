function phase_delta = func_compute_phase_delta(phase_init, old_phase_delta)
%FUNC_COMPUTE_PHASE_DELTA 
% 根据测量的通道相位，上次校准的通道相位以及移相器精度，计算出每个通道需要的移相码字
%   此处显示详细说明

phase_delta = zeros(8,8);

for i = 1:8
    for j = 1:8
        phase_delta(i,j) = round((phase_init(i,j)-min(phase_init(:)))/1.41);
    end
end

phase_delta = phase_delta + old_phase_delta;

phase_delta = phase_delta - min(phase_delta(:));

phase_delta = mod(phase_delta, 256);

end

