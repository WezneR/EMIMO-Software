EMIMO/64通道模组控制程序

### 文件说明

#### 目录：
- figure:  保存绘制的图像；
- Function: 用于控制模组、校准以及控制转台的函数；
- mat: 保存的MATLAB变量；
- Script: 用户编写的脚本；
- UART: 用于实现MATLAB与串口通信的函数和宏；
- VNA: 用于实现MATLAB与矢网通信的函数和宏。

#### 文件：
- eMIMO阵面数据帧格式.xlsx: 定义了和模组通信的帧格式；
- calibration.m: 用于空口校准的程序；
- calibration20241124.m: 用于空口校准的程序，使用函数简化；
- plot_pattern.m: 用于测量不同频率下方向图并画图的程序；
- plot_pattern_varIFgain.m: 用于测量不同中频增益下方向图并画图的程序；
- MCC4DLL.dll: 控制转台所需的库。


### 控制接口

#### Function目录下的以下函数用于通过串口控制单个模组：
- func_channel_switch.m: 控制通道工作状态：TR切换或关闭。
- func_dev_mode.m: 控制进入或退出开发者模式。只允许在开发者模式下使用软件控制通道状态。否则，只能通过硬件上的TX_ON和RX_ON连线的电平来控制通道状态。
- func_IFDSA_write.m: 控制模组的中频增益。
- func_phase_array_beam_direct_to.m: 控制波束指向特定的角度。
- func_phase_array_beam_init.m: 控制波束回到法向。
- func_power_down.m: 控制所有通道状态为关闭状态。
- func_ps_att_write.m: 控制指定通道的射频衰减。
- func_ps_lacth_phase.m: 向模组发送更新相位的指令（写入射频移相器的AC或BF寄存器后需要更新相位才能使移相值生效）。
- func_ps_phase_write.m: 控制特定通道的射频相移。

使用方法：
可以参考 `calibration.m`和`plot_pattern.m`中的初始化部分，需要先识别串口设备，成功打开串口后，使用该串口控制模组。

模组上电之后会自动读取ROM中的校准信息，自动完成一次波束初始化，将射频衰减和相移码字写入射频移相器中，同时FEM处于关闭状态。

如果用MATLAB控制通道开关和TR切换，需要先试用func_dev_mode()打开开发者模式，再用func_channel_switch()控制通道状态。

