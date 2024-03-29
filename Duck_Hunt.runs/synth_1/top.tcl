# 
# Synthesis run script generated by Vivado
# 

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
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.xpr} [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
add_files -quiet {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp}}
set_property used_in_implementation false [get_files {{c:/Users/Kiteu/OneDrive/UEC/Duck Hunt/vivado/Duck_Hunt.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp}}]
read_verilog {
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/video_bus.h}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vesa_vga.vh}
}
set_property file_type "Verilog Header" [get_files {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/video_bus.h}}]
set_property file_type "Verilog Header" [get_files {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vesa_vga.vh}}]
read_mem {
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/graphics/bush_128x128.jpg.data}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/graphics/foreground_256x128.jpg.data}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/graphics/sprites_128x128.jpg.data}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/graphics/tree_256x256.jpg.data}
}
read_verilog -library xil_defaultlib {
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/delay_upel.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/rng.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/image_rom.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/draw_rect.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/sync_gen.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/duck_ctl.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/draw_sprite.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/anim_clock_gen.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vga_timing.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/sync_and_blank.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/list_ch06_02_debounce.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/duck_cnc.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/draw_image.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/draw_background.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/blanker.v}
  {C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/top.v}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vga_example.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Kiteu/OneDrive/UEC/Duck Hunt/src/vga_example.xdc}}]


synth_design -top top -part xc7a35tcpg236-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }
