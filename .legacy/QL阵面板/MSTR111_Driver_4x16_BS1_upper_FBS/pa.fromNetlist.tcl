
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name MSTR111_Driver_4x16 -dir "F:/ISE/MSTR111_4x16_20240713/MSTR111_Driver_4x16/planAhead_run_2" -part xc6slx45csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/ISE/MSTR111_4x16_20240713/MSTR111_Driver_4x16/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/ISE/MSTR111_4x16_20240713/MSTR111_Driver_4x16} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
