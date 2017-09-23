# Default to verilog
MODE ?= vhdl

COCOTB ?= ~/cocotb/cocotb
PWD=$(shell pwd)

ifeq ($(MODE),verilog)
    VERILOG_SOURCES = $(PWD)/../src/verilog/pc_regs.sv

else ifeq ($(MODE),vhdl)
    VHDL_SOURCES = $(PWD)/../src/vhdl/pc_regs.vhd
	SIM=ghdl 
	SIM_ARGS = --fst=../wave.fst
else
    $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif


TOPLEVEL=pc_regs



MODULE=test_pc_regs
include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
