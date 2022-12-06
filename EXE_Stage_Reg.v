module EXE_reg (
	input clk,rst,
	input WB_EN_in, MEM_R_EN_in, MEM_W_EN_in,
	input[7:0] Val_Ra_in,
	input[7:0] ALU_Res_in,
	input[1:0] Dest_in,
	//to next stage
	output reg WB_EN, MEM_R_EN, MEM_W_EN,
	output reg[7:0] Val_Ra,
	output reg[7:0] ALU_Res,
	output reg[1:0] Dest
	);

	always@(posedge clk,posedge rst)begin
		if (rst) begin
			WB_EN = 0;
			MEM_R_EN = 0;
			MEM_W_EN = 0;
			Val_Ra = 0;
			ALU_Res = 0;
			Dest = 0;
		end
		else begin
			WB_EN 		= WB_EN_in ;
			MEM_R_EN 	= MEM_R_EN_in;
			MEM_W_EN 	= MEM_W_EN_in;
			ALU_Res 	= ALU_Res_in;
			Val_Ra 		= Val_Ra_in 	;
			Dest 		= Dest_in 		;
		end
	end
endmodule