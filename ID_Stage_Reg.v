module ID_Stage_Reg (
	input clk,rst,
	input WB_EN_in, MEM_R_EN_in, MEM_W_EN_in,S_in,inPort_in, outPort_in,
	input[3:0] EXE_CMD_in,
	input[7:0] Val_Ra_in, Val_Rb_in,
	input imm_in,
	input[7:0] Val_Imm_in,
	input[1:0] Dest_in,
	input[1:0] src1_in,src2_in,
	//to next stage
	output reg WB_EN, MEM_R_EN, MEM_W_EN,S,inPort, outPort,
	output reg[3:0] EXE_CMD,
	output reg[7:0] Val_Ra, Val_Rb,
	output reg imm,
	output reg[7:0] Val_Imm,
	output reg[1:0] Dest,
	output reg[1:0] src1,src2
	);

	always@(posedge clk,posedge rst)begin
		if (rst) begin
			WB_EN = 0;
			MEM_R_EN = 0;
			MEM_W_EN = 0;
			S = 0;
			EXE_CMD = 0;
			Val_Ra = 0;
			Val_Rb = 0;
			imm = 0;
			Val_Imm = 0;
			Dest = 0;
			src1 = 0;
			src2 = 0;
			inPort = 0;
			outPort = 0;
		end
		else begin
			WB_EN 		= WB_EN_in ;
			MEM_R_EN 	= MEM_R_EN_in;
			MEM_W_EN 	= MEM_W_EN_in;
			S 			= S_in ;
			EXE_CMD 	= EXE_CMD_in ;
			Val_Ra 		= Val_Ra_in 	;
			Val_Rb 		= Val_Rb_in 	;
			imm 		= imm_in 		;
			Val_Imm 	= Val_Imm_in ;
			Dest 		= Dest_in 		;
			src1 		= src1_in 		;
			src2 		= src2_in 		;
			inPort = inPort_in; 
			outPort = outPort_in;
		end
	end

endmodule