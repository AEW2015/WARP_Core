
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]



################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# LED_Control, RGB_Control, Top_Control

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project base base -part xc7a35ticsg324-1L
   set_property BOARD_PART digilentinc.com:arty:part0:1.1 [current_project]
}

add_files ../Src/hdl/

# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set CLK100MHZ [ create_bd_port -dir I -type clk CLK100MHZ ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
 ] $CLK100MHZ
  set led [ create_bd_port -dir O -from 3 -to 0 led ]
  set rgb0 [ create_bd_port -dir O -from 2 -to 0 rgb0 ]
  set rst_n [ create_bd_port -dir I -type rst rst_n ]
  set sw [ create_bd_port -dir I -from 3 -to 0 sw ]

  # Create instance: LED_Control_0, and set properties
  set block_name LED_Control
  set block_cell_name LED_Control_0
  if { [catch {set LED_Control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $LED_Control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: RGB_Control_0, and set properties
  set block_name RGB_Control
  set block_cell_name RGB_Control_0
  if { [catch {set RGB_Control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $RGB_Control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Top_Control_0, and set properties
  set block_name Top_Control
  set block_cell_name Top_Control_0
  if { [catch {set Top_Control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Top_Control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net CLK100MHZ_1 [get_bd_ports CLK100MHZ] [get_bd_pins LED_Control_0/clk] [get_bd_pins RGB_Control_0/CLK] [get_bd_pins Top_Control_0/clk]
  connect_bd_net -net LED_Control_0_led [get_bd_ports led] [get_bd_pins LED_Control_0/led]
  connect_bd_net -net RGB_Control_0_rgb [get_bd_ports rgb0] [get_bd_pins RGB_Control_0/rgb]
  connect_bd_net -net RST_N_1 [get_bd_ports rst_n] [get_bd_pins LED_Control_0/rst_n] [get_bd_pins RGB_Control_0/RST_N] [get_bd_pins Top_Control_0/rst_n]
  connect_bd_net -net SW_1 [get_bd_ports sw] [get_bd_pins Top_Control_0/sw]
  connect_bd_net -net Top_Control_0_led_en [get_bd_pins LED_Control_0/led_en] [get_bd_pins Top_Control_0/led_en]
  connect_bd_net -net Top_Control_0_led_input [get_bd_pins LED_Control_0/led_input] [get_bd_pins Top_Control_0/led_input]
  connect_bd_net -net Top_Control_0_rgb_en [get_bd_pins RGB_Control_0/rgb_en] [get_bd_pins Top_Control_0/rgb_en]
  connect_bd_net -net Top_Control_0_rgb_input [get_bd_pins RGB_Control_0/rgb_input] [get_bd_pins Top_Control_0/rgb_input]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   commentid: "",
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port CLK100MHZ -pg 1 -y 40 -defaultsOSRD
preplace port rst_n -pg 1 -y 60 -defaultsOSRD
preplace portBus sw -pg 1 -y 160 -defaultsOSRD
preplace portBus rgb0 -pg 1 -y 210 -defaultsOSRD
preplace portBus led -pg 1 -y 70 -defaultsOSRD
preplace inst Top_Control_0 -pg 1 -lvl 1 -y 140 -defaultsOSRD
preplace inst LED_Control_0 -pg 1 -lvl 2 -y 70 -defaultsOSRD
preplace inst RGB_Control_0 -pg 1 -lvl 2 -y 210 -defaultsOSRD
preplace netloc Top_Control_0_led_input 1 1 1 300
preplace netloc RST_N_1 1 0 2 20 60 290
preplace netloc Top_Control_0_rgb_input 1 1 1 270
preplace netloc Top_Control_0_led_en 1 1 1 270
preplace netloc Top_Control_0_rgb_en 1 1 1 280
preplace netloc CLK100MHZ_1 1 0 2 30 40 310
preplace netloc LED_Control_0_led 1 2 1 NJ
preplace netloc RGB_Control_0_rgb 1 2 1 NJ
preplace netloc SW_1 1 0 1 NJ
levelinfo -pg 1 0 150 430 570 -top 0 -bot 290
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

# Additional steps to get to bitstream
# generate toplevel wrapper files
set_property target_language VHDL [current_project]
make_wrapper -files [get_files ./base/base.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse ./base/base.srcs/sources_1/bd/system/hdl/system_wrapper.vhd
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

add_files -fileset constrs_1 -norecurse ../Src/const/Arty_Master.xdc










