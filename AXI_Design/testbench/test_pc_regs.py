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
	data = [0] * 32
	

	cocotb.fork(Clock(dut.clk, 2).start())
	dut._log.info("Running test!")
	dut.rst = 1
	dut.rs1_addr = 0
	dut.rs2_addr = 0
	dut.rd_data = 0
	dut.we = 0
	yield Timer(10)
	dut._log.info("Resetting DUT")
	dut.rst = 0
	yield Timer(10)
	dut.rst = 1
	dut._log.info("Verify Reset 1")
	for i in range(0,15):
		dut.rs1_addr = i
		dut.rs2_addr = i+16
		yield RisingEdge(dut.clk)
		if (dut.rs1_data != data[i]):
			raise TestFailure ("rs1 [%d] expected: 0x%08x acutal:0x%08x" %(i,data[i],dut.rs1_data))
		if (dut.rs2_data != data[i+16]):
			raise TestFailure ("rs2 [%d] expected: 0x%08x acutal:0x%08x" %(i+16,data[i+16],dut.rs2_data))

	dut._log.info("Write test 1")
	for j in xrange(0,0xff):
		dut.rd_data = j<<24 | j<<16 | j<<8 | j
		dut.rd_addr = j%32
		data[j%32]  = j<<24 | j<<16 | j<<8 | j
		data[0] = 0
		dut.we = 1
		yield RisingEdge(dut.clk)
		dut.we = 0
		for i in range(0,31):
			dut.rs1_addr = i
			reg2 = (31-i)
			dut.rs2_addr = reg2
			yield RisingEdge(dut.clk)
			if (dut.rs1_data != data[i]):
				raise TestFailure ("rs1 [%d] expected: 0x%08x acutal:0x%08x" %(i,data[i],dut.rs1_data))
			if (dut.rs2_data != data[reg2]):
				raise TestFailure ("rs2 [%d] expected: 0x%08x acutal:0x%08x" %(reg2,data[reg2],dut.rs2_data))

	data = [0] * 32
	yield Timer(10)
	dut.rst = 0
	yield Timer(10)
	dut.rst = 1

	dut._log.info("Verify Reset 2")
	for i in range(0,15):
		dut.rs1_addr = i
		dut.rs2_addr = i+16
		yield RisingEdge(dut.clk)
		if (dut.rs1_data != data[i]):
			raise TestFailure ("rs1 [%d] expected: 0x%08x acutal:0x%08x" %(i,data[i],dut.rs1_data))
		if (dut.rs2_data != data[i+16]):
			raise TestFailure ("rs2 [%d] expected: 0x%08x acutal:0x%08x" %(i+16,data[i+16],dut.rs2_data))

	dut._log.info("Write test 2")
	for j in xrange(0,0xff):
		dut.rd_data = j<<24 | j<<16 | j<<8 | j
		dut.rd_addr = j%32
		data[j%32]  = j<<24 | j<<16 | j<<8 | j
		data[0] = 0
		dut.we = 1
		yield RisingEdge(dut.clk)
		dut.we = 0
		for i in range(0,31):
			dut.rs1_addr = i
			reg2 = (i+16)%32
			dut.rs2_addr = reg2
			yield RisingEdge(dut.clk)
			if (dut.rs1_data != data[i]):
				raise TestFailure ("rs1 [%d] expected: 0x%08x acutal:0x%08x" %(i,data[i],dut.rs1_data))
			if (dut.rs2_data != data[reg2]):
				raise TestFailure ("rs2 [%d] expected: 0x%08x acutal:0x%08x" %(reg2,data[reg2],dut.rs2_data))


	dut._log.info("Finsihed test!")
	raise TestSuccess()
	raise TestSuccess()
