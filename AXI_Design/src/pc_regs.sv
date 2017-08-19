`timescale 1us/1ns




module pc_regs (
	input clk,
	input rst,
	input we,
	input [4:0] addr_a,
	input [4:0] addr_b,
	input [31:0] din,
	output reg [31:0] reg_a,
	output reg [31:0] reg_b
	);


reg [31:0] gpregs [1:31];
integer i;

always @(negedge rst or posedge clk)
	begin
		if (! rst)
			for (i=1; i<32; i=i+1) gpregs[i] =0;
		else
			if (we)
				gpregs [addr_b] = din;
	end

assign reg_a = (addr_a == 0) ? 0 : gpregs [addr_a];
assign reg_b = (addr_b == 0) ? 0 : gpregs [addr_b];

`ifdef COCOTB_SIM
initial begin
  $dumpfile ("pc_waveform.vcd");
  $dumpvars (0,pc_regs);
  #1;
end
`endif
endmodule
