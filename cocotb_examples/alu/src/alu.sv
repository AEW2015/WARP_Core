`timescale 1us/1ns




module alu (
	input Reset,
	input [3:0] A,
	input [3:0] B,
	input [1:0] OP,
	output reg [4:0] C
	);



always @(Reset,A,B,OP)
begin
if(Reset)
	C = 0;
else 
	case(OP)
		0: C=A+B;
		1: C=A-B;
		2: C=~A;
		3: C=|B;
	endcase
end


`ifdef COCOTB_SIM
initial begin
  $dumpfile ("alu_waveform.vcd");
  $dumpvars;
  #1;
end
`endif
endmodule
