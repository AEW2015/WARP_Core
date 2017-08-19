import cocotb
import random
import logging
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.result import TestFailure, TestSuccess
import cocotb.wavedrom

@cocotb.test()
def test_pc_regs(dut):
	"""
	Try accessing the design
	"""
	
	

	cocotb.fork(Clock(dut.clk, 2).start())
	dut._log.info("Running test!")
	dut.rst = 1
	dut.addr_a = 0
	dut.addr_b = 0
	dut.din = 0
	dut.we = 0
	yield Timer(10)
	dut._log.info("Resetting DUT")
	dut.rst = 0
	yield Timer(10)
	dut.rst = 1
	yield RisingEdge(dut.clk)
	dut.din = 0x12345678
	dut.addr_b = 1
	dut.we = 1
	yield RisingEdge(dut.clk)
	dut.din = 0
	dut.we = 0
	yield RisingEdge(dut.clk)
	dut.addr_a = 1
	if (dut.reg_b != 0x12345678):
		raise TestFailure ("Wrong value")
	
	yield RisingEdge(dut.clk)
	if (dut.reg_a != 0x12345678):
		raise TestFailure ("Wrong value")

	dut._log.info("Finsihed test!")
	raise TestSuccess()
	raise TestSuccess()
