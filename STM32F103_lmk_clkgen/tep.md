
F:\MATLAB\RFSoCClient\claude

cd F:/Vivado/ZU47DR_MTS_test
cd F:/Vivado/zu47_calibadc  
source download_waveform.tcl

# 发送trig_in正脉冲
55 5d 00 12 00 00 0d 0a

dacMTSwl 0xf
getPhaseAll
getMultAll

setPhase
setMult

savePhaseAll
saveMultAll

loadMultAll

setPhase 1  7 48500
setPhase 1  6 48600
setPhase 1  5 48500
setPhase 1  4 48500
setPhase 1  3 49000
setPhase 1  2 48000
setPhase 1  1 48200
setPhase 1  0 47000