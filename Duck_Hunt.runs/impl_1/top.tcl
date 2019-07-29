proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -ruleid {1}  -id {filemgmt 20-1318}  -suppress 
set_msg_config  -ruleid {10}  -id {DRC 23-20}  -suppress 
set_msg_config  -ruleid {11}  -id {Place 30-879}  -suppress 
set_msg_config  -ruleid {12}  -id {Place 30-574}  -suppress 
set_msg_config  -ruleid {2}  -id {Project 1-486}  -suppress 
set_msg_config  -ruleid {3}  -id {DRC 23-20}  -string {{WARNING: [DRC 23-20] Rule violation (CKLD-2) Clock Net has IO Driver, not a Clock Buf, and/or non-Clock loads - Clock net btnC_IBUF is directly driven by an IO rather than a Clock Buffer or may be an IO driving a mix of Clock Buffer and non-Clock loads. This connectivity should be reviewed and corrected as appropriate. Driver(s): btnC_IBUF_inst/O}}  -suppress 
set_msg_config  -ruleid {4}  -id {Place 30-574}  -string {{WARNING: [Place 30-574] Poor placement for routing between an IO pin and BUFG. This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	btnC_IBUF_inst (IBUF.O) is locked to IOB_X0Y13
	 and btnC_IBUF_BUFG_inst (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y1
Resolution: Poor placement of an IO pin and a BUFG has resulted in the router using a non-dedicated path between the two.  There are several things that could trigger this DRC, each of which can cause unpredictable clock insertion delays that result in poor timing.  This DRC could be caused by any of the following: (a) a clock port was placed on a pin that is not a CCIO-pin (b)the BUFG has not been placed in the same half of the device or SLR as the CCIO-pin (c) a single ended clock has been placed on the N-Side of a differential pair CCIO-pin.}}  -suppress 
set_msg_config  -ruleid {5}  -id {DRC 23-20}  -string {{WARNING: [DRC 23-20] Rule violation (PLCK-12) Clock Placer Checks - Poor placement for routing between an IO pin and BUFG. 
Resolution: Poor placement of an IO pin and a BUFG has resulted in the router using a non-dedicated path between the two.  There are several things that could trigger this DRC, each of which can cause unpredictable clock insertion delays that result in poor timing.  This DRC could be caused by any of the following: (a) a clock port was placed on a pin that is not a CCIO-pin (b)the BUFG has not been placed in the same half of the device or SLR as the CCIO-pin (c) a single ended clock has been placed on the N-Side of a differential pair CCIO-pin.
 This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	btnC_IBUF_inst (IBUF.O) is locked to U18
	btnC_IBUF_BUFG_inst (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y1}}  -suppress 
set_msg_config  -ruleid {6}  -id {Synth 8-3332}  -string {{WARNING: [Synth 8-3332] Sequential element (main_cnc/duck1_ctl/x_reg[0]) is unused and will be removed from module vga_example.}}  -suppress 
set_msg_config  -ruleid {7}  -id {Synth 8-3332}  -suppress 
set_msg_config  -ruleid {8}  -id {Synth 8-3331}  -suppress 
set_msg_config  -ruleid {9}  -id {Place 30-568}  -suppress 

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.cache/wt} [current_project]
  set_property parent.project_path {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.xpr} [current_project]
  set_property ip_repo_paths {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.cache/ip}} [current_project]
  set_property ip_output_repo {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.cache/ip}} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.runs/synth_1/top.dcp}}
  add_files -quiet {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp}}
  set_property netlist_only true [get_files {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp}}]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc}}
  set_property processing_order EARLY [get_files {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc}}]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc}}
  set_property processing_order EARLY [get_files {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc}}]
  read_xdc -ref clk_wiz_0 -cells inst {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc}}
  set_property processing_order EARLY [get_files {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc}}]
  read_xdc {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vga_example.xdc}}
  link_design -top top -part xc7a35tcpg236-1
  write_hwdef -file top.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force top_opt.dcp
  report_drc -file top_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force top_placed.dcp
  report_io -file top_io_placed.rpt
  report_utilization -file top_utilization_placed.rpt -pb top_utilization_placed.pb
  report_control_sets -verbose -file top_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_routed.dcp
  report_drc -file top_drc_routed.rpt -pb top_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file top_timing_summary_routed.rpt -rpx top_timing_summary_routed.rpx
  report_power -file top_power_routed.rpt -pb top_power_summary_routed.pb -rpx top_power_routed.rpx
  report_route_status -file top_route_status.rpt -pb top_route_status.pb
  report_clock_utilization -file top_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

