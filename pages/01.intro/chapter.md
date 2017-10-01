---
title: Introduction
taxonomy:
    category:
        - docs
child_type: docs
---

### Chapter 0

# Introduction

A VHDL and Verilog Processor designed for academic purposes and future potential as a soft-core processor build for space

`timescale 1ns/1ns

module config_regTB;

	typedef struct {
		//Name
		string name;
		//Data to write
		logic [15:0] data_write;
		//Expected data read
		logic [15:0] exp_data_read;
		//Actual data read
		logic [15:0] act_data_read;
		//reset value
		logic [15:0] reset_value;
		} reg_type;

	integer testCount = 0;
	int k;
	int error_count = 0;
	int error_found= 0;
	bit verbose = 0;
	logic clk, write, reset;
	logic [15:0] data_in;
	logic [2:0] address;
	logic [15:0] data_out;
	
	string operations[9] = {"write to adc0_reg",
							"write to adc1_reg",
							"write to temp_sensor0_reg",
							"write to temp_sensor1_reg",
							"write to analog_test",
							"write to digital_test",
							"write to amp_gain",
							"write to digital_config",
							"reset"
							};
	logic [15:0] operation_write_value;
	bit recorded [9];
	bit recorded_rst [9];
	
	
	
	reg_type reg_array [0:7];
	
	

	config_reg dut(.*);

	task print_regs();
	$display("[%0tns] Reg Print Out",$realtime);
	foreach (reg_array[addr])
		begin
		$display("\t[%0d] %20s \tExpected Value = %04X \tActual Value = %04x",
		addr,reg_array[addr].name,reg_array[addr].exp_data_read,
		reg_array[addr].act_data_read);
		end
	endtask
	
	task test_reg_values (int operation);
	error_found = 0;
	foreach (reg_array[addr])
		begin
		address = addr;
		#0;
		reg_array[addr].act_data_read = data_out;
		if(reg_array[addr].act_data_read != reg_array[addr].exp_data_read)
		begin
			if((operation<8 && recorded[operation] == 0)||(operation==8 && recorded_rst[addr] == 0)||(error_found==1)||verbose)
				begin
				if(operation==8)
					begin
						if(error_found==0)$display("[%0tns]ERROR on %s write is %d",$realtime,operations[operation],write);
						recorded_rst[addr] = 1;
						error_found = 1;
					end
				else
					begin
						if (error_found==0)$display("[%0tns]ERROR on %s %04X",$realtime,operations[operation],operation_write_value);
						recorded[operation] =1;
						error_found = 1;
					end
				$display("\t[%0d] %14s \tExpected Value = %04X \tActual Value = %04x",
				addr,reg_array[addr].name,reg_array[addr].exp_data_read,
				reg_array[addr].act_data_read);
				
				end
				
			end
			reg_array[addr].exp_data_read = reg_array[addr].act_data_read;
		end
	endtask
	
	task setup_reg_array ();
		reg_array[0].name = "adc0_reg";
		reg_array[0].reset_value = 16'hffff;
		reg_array[1].name = "adc1_reg";
		reg_array[1].reset_value = 16'h0;
		reg_array[2].name = "temp_sensor0_reg";
		reg_array[2].reset_value = 16'h0;
		reg_array[3].name = "temp_sensor1_reg";
		reg_array[3].reset_value = 16'h0;
		reg_array[4].name = "analog_test";
		reg_array[4].reset_value = 16'hABCD;
		reg_array[5].name = "digital_test";
		reg_array[5].reset_value = 16'h0;
		reg_array[6].name = "amp_gain";
		reg_array[6].reset_value = 16'h0;
		reg_array[7].name = "digital_config";
		reg_array[7].reset_value = 16'h1;
		if(verbose) 
			foreach (reg_array[k])
			$display("[%0tns][%0d] %20s \treset value = %04X",$realtime,k,reg_array[k].name,reg_array[k].reset_value);
	endtask
	
	task test_reset ();
		reset = 1;
		@ (negedge clk);
		reset = 0;
		foreach (reg_array[k])
		begin
			reg_array[k].exp_data_read = reg_array[k].reset_value;
		end
		test_reg_values(8);
	endtask
	
		
	task test_inputs (logic  resertV, logic writeV, logic [2:0] addr, logic [15:0] value);
		reset = resertV;
		write = writeV;
		address = addr;
		data_in = value;
		operation_write_value = value;
		@ (negedge clk);
		if(reset == 1)
		begin
			if(verbose) $display("[%0tns]rst",$realtime);
			foreach (reg_array[k])
			begin
				reg_array[k].exp_data_read = reg_array[k].reset_value;
			end
		test_reg_values(8);
		end
		else
		begin
			if(verbose) $display("[%0tns]write %s %04X",$realtime,reg_array[addr].name,value);
			if(write) reg_array[addr].exp_data_read = value;
			test_reg_values(addr);
		end
	endtask
	
	task random_writes(int count);
		for(int j = 0; j<count; j+=1)
		begin
			test_inputs($urandom,$urandom,$urandom,$urandom);
		end
	endtask
	
	initial
	begin
		write = 0;
		reset = 0;
		setup_reg_array();
		@ (negedge clk)
		test_reset();
		random_writes(testCount);
		$finish;
	end
	
	always
	begin
		clk <=1; #5ns;
		clk <=0; #5ns;
	end
endmodule