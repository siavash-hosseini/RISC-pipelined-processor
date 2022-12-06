module ID_Stage (
	input clk,rst,
	//from IF Reg 
	input[15:0] Instruction,
	input [7:0] PC_in,
	//from WB stage
	input[7:0] Result_WB,
	input writeBackEn, 
	input[1:0] Dest_wb,
	//from hazard detect module
	input hazard,
	//from Status Register
	input Z,N,
	//to next stage
	output WB_EN, MEM_R_EN, MEM_W_EN,S, inPort, outPort,
	output[3:0] EXE_CMD,
	output[7:0] Val_Ra, Val_Rb,
	output imm,
	output[7:0] Val_Imm,
	output[1:0] Dest,
	//to hazard detect module
	output[1:0] src1,src2,
	output src1_en,src2_en,
	//to IF
	output[7:0] Br_addr,
	output B
	);

	wire wb_en,mem_r_en,mem_w_en,s,b,link,ret;
	wire [3:0]exe_cmd;
	wire  cond_true;
	wire [7:0] linkAddr;

	controlUnit cu (
		.opcode(Instruction[7:4]),
		.Z(Z),
		.N(N),
		.BRX(Instruction[3]),
		.WB_EN(wb_en),
		.MEM_R_EN(mem_r_en),
		.MEM_W_EN(mem_w_en),
		.S(s),
		.B(b),
		.Ret(ret),
		.L(link),
		.EXE_CMD(exe_cmd),
		.IMM(imm),
		.SRC1(src1_en),
		.SRC2(src2_en),
		.inPort(inPort),
		.outPort(outPort)
	);

	myMUX #(9) contMux(
		.in1({wb_en, mem_r_en, mem_w_en, b,s , exe_cmd}),
		.in2(9'd0),
		.sel(hazard),
		.out({WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD})
	);
	RegisterFile reg_file (
		.clk(clk),
		.rst(rst),
		.rg_wrt_enable(writeBackEn),
		.rg_wrt_dest(Dest_wb),
		.rg_wrt_data(Result_WB),
		.rg_rd_addr1(Instruction[3:2]),
		.rg_rd_data1(Val_Ra),
		.rg_rd_addr2(Instruction[1:0]),
		.rg_rd_data2(Val_Rb)
	);
	
	Reg #(8) LR(.clk(clk),.en(link),.rst(rst),.in(PC_in), .out(linkAddr));

	assign Br_addr = ret ? linkAddr : Instruction[15:8];

	assign Val_Imm = Instruction[15:8];
	assign Dest = Instruction[3:2];
	assign src1 = Instruction[3:2];
	assign src2 = Instruction[1:0];
endmodule