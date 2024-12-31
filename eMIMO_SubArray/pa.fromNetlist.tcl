
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name eMIMO_SubArray -dir "F:/ISE/eMIMO_SubArray/planAhead_run_1" -part xc6slx25ftg256-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/ISE/eMIMO_SubArray/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/ISE/eMIMO_SubArray} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "F:/ISE/eMIMO_SubArray/planAhead_run_4/design_1.ucf" [current_fileset -constrset]
add_files [list {F:/ISE/eMIMO_SubArray/planAhead_run_4/design_1.ucf}] -fileset [get_property constrset [current_run]]
link_design
