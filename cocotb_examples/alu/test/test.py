import cocotb
import random
import logging
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.result import TestFailure, TestSuccess
from cocotb.regression import TestFactory

def add_doc(value):
    def _doc(func):
        func.__doc__ = value
        return func
    return _doc


@cocotb.coroutine
def my_first_test(dut,operation = None):
	dut.Reset = 1
	yield Timer(1)
	dut.Reset = 0
	for i in range(0,100):
		yield operation(dut,random.randint(0,15),random.randint(0,15))
	TestSuccess()

@add_doc('Random Mix')
@cocotb.coroutine
def mix(dut,A,B):
	operation = random.randint(0,3)
	if(operation == 0):
		yield addition(dut,A,B)
	if(operation == 1):
		yield subtraction(dut,A,B)
	if(operation == 2):
		yield invert(dut,A,B)
	if(operation == 3):
		yield reduction(dut,A,B)


@add_doc('OP Code = 3 |B')
@cocotb.coroutine
def reduction(dut,A,B):
	dut.OP = 3
	dut.A = A
	dut.B = B
	yield Timer(1)
	if (dut.C != bool(B)):
		raise TestFailure ("expected: 0x%08x acutal:0x%08x" %(bool(B),dut.C))

@add_doc('OP Code = 2 Invert A')
@cocotb.coroutine
def invert(dut,A,B):
	dut.OP = 2
	dut.A = A
	dut.B = B
	yield Timer(1)
	if (dut.C != (~A)&0b11111):
		raise TestFailure ("expected: 0x%08x acutal:0x%08x" %((~A)&0b11111,dut.C))

@add_doc('OP Code = 1 A-B')
@cocotb.coroutine
def subtraction(dut,A,B):
	dut.OP = 1
	dut.A = A
	dut.B = B
	yield Timer(1)
	if (dut.C != ((A-B)&0b11111)):
		raise TestFailure ("expected: 0x%08x acutal:0x%08x" %(((A-B)&0b11111),dut.C))

@add_doc('OP Code = 0 A+B')
@cocotb.coroutine
def addition(dut,A,B):
	dut.OP = 0
	dut.A = A
	dut.B = B
	yield Timer(1)
	if (dut.C != A+B):
		raise TestFailure ("expected: 0x%08x acutal:0x%08x" %(A+B,dut.C))


factory = TestFactory(my_first_test)
factory.add_option("operation", [addition,subtraction,invert,reduction,mix])
factory.generate_tests()
