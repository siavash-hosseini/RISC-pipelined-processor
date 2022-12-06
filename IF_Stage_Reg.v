module IF_Stage_Reg (
	input clk,rst,freeze,flush,
	input[15:0] Instruction_in,
	input [7:0] PC_in,
	output reg [15:0] Instruction,
	output reg [7:0] PC
);

	initial begin
		Instruction = 16'd0;
	end
	always@(posedge clk,posedge rst)begin
		if (rst) begin
			Instruction = 16'd0;
			PC = 0;
		end
		else if (flush) begin
			Instruction = 16'd0;
			PC = 0;
		end
		else if(!freeze) begin
			Instruction <= Instruction_in;
			PC = PC_in;
		end
		
	end
endmodule