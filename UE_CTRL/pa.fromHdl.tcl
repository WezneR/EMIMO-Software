
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name UE_CTRL -dir "E:/work/AcAnt/01-design/09-eMIMO_Array/05-code/FPGA/UE_CTRL/V1/UE_CTRL/planAhead_run_2" -part xc6slx25ftg256-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "CTRL_TOP.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {CTRL_TOP.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top CTRL_TOP $srcset
add_files [list {CTRL_TOP.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx25ftg256-2
