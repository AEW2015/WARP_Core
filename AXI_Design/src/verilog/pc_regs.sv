`timescale 1us/1ns




module pc_regs (
	input clk,
	input rst,
	input we,
	input [4:0] rs1_addr,
	input [4:0] rs2_addr,
	input [4:0] rd_addr,
	input [31:0] rd_data,
	output [31:0] rs1_data,
	output [31:0] rs2_data
	);


reg [31:0] gpregs [1:31];
integer i;

always @(negedge rst or posedge clk)
	begin
		if (! rst)
			for (i=1; i<32; i=i+1) gpregs[i] =0;
		else
			if (we &&  rd_addr != 0)
				gpregs [rd_addr] = rd_data;
	end

assign rs1_data = (rs1_addr == 0) ? 0 : gpregs [rs1_addr];
assign rs2_data = (rs2_addr == 0) ? 0 : gpregs [rs2_addr];

`ifdef COCOTB_SIM
initial begin
  $dumpfile ("pc_waveform.vcd");
  $dumpvars;
  #1;
end
`endif
endmodule
