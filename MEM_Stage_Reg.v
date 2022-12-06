module MEMReg (
	input clk,rst,
	input WB_EN_in, MEM_R_EN_in,
	input[7:0] Val_LDR_in,
	input[7:0] ALU_Res_in,
	input[1:0] Dest_in,
	//to next stage
	output reg WB_EN, MEM_R_EN,
	output reg [7:0] Val_LDR,
	output reg [7:0] ALU_Res,
	output reg [1:0] Dest
	);

	always@(posedge clk,posedge rst)begin
		if (rst) begin
			WB_EN = 0;
			MEM_R_EN = 0;
			Val_LDR = 0;
			ALU_Res = 0;
			Dest = 0;
		end
		else begin
			WB_EN 		= WB_EN_in ;
			MEM_R_EN 	= MEM_R_EN_in;
			Val_LDR 		= Val_LDR_in 	;
			ALU_Res 	= ALU_Res_in ;
			Dest 		= Dest_in 		;
		end
	end

endmodule