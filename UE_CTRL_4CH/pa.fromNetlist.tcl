
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name UE_CTRL_4CH -dir "F:/ISE/UE_CTRL_4CH/planAhead_run_3" -part xc6slx25ftg256-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/ISE/UE_CTRL_4CH/CTRL_TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/ISE/UE_CTRL_4CH} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "CTRL_TOP.ucf" [current_fileset -constrset]
add_files [list {CTRL_TOP.ucf}] -fileset [get_property constrset [current_run]]
link_design
