
module IF_Stage (
	input clk,rst,freeze,Branch_taken ,
	input[7:0] BranchAddr, 
	output [15:0] Instruction,
	output [7:0] PC
);
	
	wire[7:0] PC_out,PC_in,PCPlus2;
// MUX BR: PC+2  or Branch Address
	myMUX #(8) mux8( .in1(PCPlus2),.in2(BranchAddr), .sel(Branch_taken), .out(PC_in));
// PC 
	Reg #(8) pc(.clk(clk),.en(~freeze),.rst(rst),.in(PC_in), .out(PC_out));

	Inst_mem inst(
		.clk(clk),
		.rst(rst),
		.Addr(PC_out),
		.q(Instruction)
	);

	assign PCPlus2 = PC_out + 8'd2; //PC+2

	assign PC = PCPlus2; //next PC
	
endmodule
	