
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name lo_frimware -dir "C:/Users/aspha/Desktop/ise_workspace/lo_firmware/prj/lo_frimware/planAhead_run_4" -part xc3s200anftg256-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/aspha/Desktop/ise_workspace/lo_firmware/prj/lo_frimware/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/aspha/Desktop/ise_workspace/lo_firmware/prj/lo_frimware} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
