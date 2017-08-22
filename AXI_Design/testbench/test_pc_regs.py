import cocotb
import random
import logging
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.result import TestFailure, TestSuccess
from cocotb.regression import TestFactory
import cocotb.wavedrom
from cocotb.generators.byte import random_data, get_bytes


@cocotb.coroutine
def run_test(dut,write_num=None,test_setting=None):
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
	#dut.gpregs
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
	for j in xrange(0,write_num):
		data_to_write = random.randint(0,0xFFFFFFFF)
		addr_to_write = random.randint(0,31)
		dut.rd_data = data_to_write
		dut.rd_addr = addr_to_write
		data[addr_to_write]  = data_to_write
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
	for j in xrange(0,write_num):
		data_to_write = random.randint(0,0xFFFFFFFF)
		addr_to_write = random.randint(0,31)
		dut.rd_data = data_to_write
		dut.rd_addr = addr_to_write
		data[addr_to_write]  = data_to_write
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


def random_write_counts(min_size=1, max_size=0xFF, tests=10):
    """random string data of a random length"""
    for i in range(tests):
		yield random.randint(min_size, max_size)




factory = TestFactory(run_test)
factory.add_option("write_num", random_write_counts())
#factory.add_option("test_setting", ["High","Low","Z"])
factory.generate_tests()


