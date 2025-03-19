#!/bin/sh

# 
# PlanAhead(TM)
# runme.sh: a PlanAhead-generated Runs Script for UNIX
# Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=E:/Xilinx/14.7/ISE_DS/EDK/bin/nt64;E:/Xilinx/14.7/ISE_DS/EDK/lib/nt64;E:/Xilinx/14.7/ISE_DS/ISE/bin/nt64;E:/Xilinx/14.7/ISE_DS/ISE/lib/nt64;E:/Xilinx/14.7/ISE_DS/common/bin/nt64;E:/Xilinx/14.7/ISE_DS/common/lib/nt64:E:/Xilinx/14.7/ISE_DS/PlanAhead/bin
else
  PATH=E:/Xilinx/14.7/ISE_DS/EDK/bin/nt64;E:/Xilinx/14.7/ISE_DS/EDK/lib/nt64;E:/Xilinx/14.7/ISE_DS/ISE/bin/nt64;E:/Xilinx/14.7/ISE_DS/ISE/lib/nt64;E:/Xilinx/14.7/ISE_DS/common/bin/nt64;E:/Xilinx/14.7/ISE_DS/common/lib/nt64:E:/Xilinx/14.7/ISE_DS/PlanAhead/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD=`dirname "$0"`
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# EAStep map -intstyle pa -w "CTRL_TOP.ngd"
EAStep par -intstyle pa "CTRL_TOP.ncd" -w "CTRL_TOP_routed.ncd"
EAStep trce -intstyle ise -o "CTRL_TOP.twr" -v 30 -l 30 "CTRL_TOP_routed.ncd" "CTRL_TOP.pcf"
EAStep xdl -secure -ncd2xdl -nopips "CTRL_TOP_routed.ncd" "CTRL_TOP_routed.xdl"
EAStep bitgen "CTRL_TOP_routed.ncd" "CTRL_TOP.bit" "CTRL_TOP.pcf" -w -intstyle pa
