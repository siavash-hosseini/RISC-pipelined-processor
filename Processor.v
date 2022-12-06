module Processor
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK,
		RST,
		IN,
		OUT
	);

input		   	CLOCK;
input			RST;
input [7:0] IN;
output[7:0] OUT;

wire[3:0] executeCMD_EXE_in;
wire[15:0] intstruction_ID_in,intstruction_IF_out;
wire[7:0] PC_IF_out;
wire[7:0] ALU_result_EXE_out, out1_EXE_in,out2_EXE_in,reg2_EXE_in;
wire[1:0]dest_EXE_in;
wire Br_taken_ID_out;

wire BR_ID_out;
wire[7:0] PC_ID_in, PC_EXE_in, writeVal, out1_ID_out,out2_ID_out, Br_addr_ID_out, imm_val_ID_out;
wire WB_en_WB_in, MEM_R_en_WB_in,WB_en_ID_out, memRead_ID_out, memWrite_ID_out,twoSources;
wire[1:0]writeBackDest, dest_ID_out, Dest_MEM_in;
wire WB_en_EXE_in, memRead_EXE_in, memWrite_EXE_in, WB_en_MEM_in, MEM_R_EN_MEM_in, MEM_W_EN_MEM_in,hazardDetected;
wire[1:0] BR_EXE_in; 
wire[3:0] executeCMD_ID_out;
wire[7:0] ALU_result_MEM_in, ST_val_MEM_in, Mem_read_value;
wire[7:0] ALU_result_WB_in, Mem_read_value_WB_in, val1EXE_Forward, val2EXE_Forward,WR2_MEM_Forward;
wire[1:0] sr_in,sr_out;
wire S_out_ID_Reg,S_out_ID;
wire is_imm_ID_out,is_imm_EXE_IN;
wire [7:0] imm_val_EXE_in;
wire [1:0] src1_hazard, src2_hazard, src1_forward, src2_forward, sel1_forward, sel2_forward;
wire src1_en_hazard, src2_en_hazard; 
wire sel3_forward; 

//assign writeBackDest = 5'd0;

IF_Stage If(
	.clk(CLOCK),.rst(RST),.freeze(hazardDetected),.Branch_taken(Br_taken_ID_out) ,
	.BranchAddr(Br_addr_ID_out), 
	.PC(PC_IF_out),.Instruction(intstruction_IF_out)
);
IF_Stage_Reg IF_Reg (
	.clk(CLOCK),.rst(RST),.freeze(hazardDetected),.flush(Br_taken_ID_out),
	.PC_in(PC_IF_out), .Instruction_in(intstruction_IF_out),
	.PC(PC_ID_in),.Instruction(intstruction_ID_in)
);

ID_Stage id_stage(
	.clk(CLOCK),.rst(RST),
	//from IF Reg
	.Instruction(intstruction_ID_in),
    .PC_in(PC_ID_in),
	//from WB stage
	.Result_WB(writeVal),
	.writeBackEn(WB_en_WB_in), 
	.Dest_wb(writeBackDest),
	//from hazard detect module
	.hazard(hazardDetected),
	//from Status Register
	.Z(sr_out[0]),
    .N(sr_out[1]),
	//to next stage
	.WB_EN(WB_en_ID_out), .MEM_R_EN(memRead_ID_out), .MEM_W_EN(memWrite_ID_out),
	.inPort(inPort_ID_out), .outPort(outPort_ID_out),
	.S(S_out_ID),
	.EXE_CMD(executeCMD_ID_out),
	.Val_Ra(out1_ID_out), .Val_Rb(out2_ID_out),
	.imm(is_imm_ID_out),
    .Val_Imm(imm_val_ID_out),
	.Dest(dest_ID_out),
	//to hazard detect module
	.src1(src1_hazard),.src2(src2_hazard),
	.src1_en(src1_en_hazard),
	.src2_en(src2_en_hazard),
    //to IF
    .B(Br_taken_ID_out),
    .Br_addr(Br_addr_ID_out)
	);

ID_Stage_Reg ID_Reg(
	.clk(CLOCK),.rst(RST),
	.WB_EN_in(WB_en_ID_out), .MEM_R_EN_in(memRead_ID_out), .MEM_W_EN_in(memWrite_ID_out),
	.inPort_in(inPort_ID_out), .outPort_in(outPort_ID_out),
    .S_in(S_out_ID),
	.EXE_CMD_in(executeCMD_ID_out),
	.Val_Ra_in(out1_ID_out), .Val_Rb_in(out2_ID_out),
	.imm_in(is_imm_ID_out),
    .Val_Imm_in(imm_val_ID_out),
	.Dest_in(dest_ID_out),
    .src1_in(src1_hazard),
    .src2_in(src2_hazard),

	.WB_EN(WB_en_EXE_in), .MEM_R_EN(memRead_EXE_in), .MEM_W_EN(memWrite_EXE_in),
	.inPort(inPort_EXE_in), .outPort(outPort_EXE_in),
    .S(S_out_ID_Reg),
	.EXE_CMD(executeCMD_EXE_in),
	.Val_Ra(out1_EXE_in), .Val_Rb(out2_EXE_in),
	.imm(is_imm_EXE_IN),
	.Val_Imm(imm_val_EXE_in),
	.Dest(dest_EXE_in),
	.src1(src1_forward),
    .src2(src2_forward)
);

// for for WB and MEM to EXEC Forwarding
assign val1EXE_Forward = (sel1_forward == 2'b01) ? ALU_result_MEM_in :
	(sel1_forward == 2'b10) ? writeVal :
	out1_EXE_in;
assign val2EXE_Forward = (sel2_forward == 2'b01) ? ALU_result_MEM_in :
	(sel2_forward == 2'b10) ? writeVal :
	out2_EXE_in;

EXE_Stage EXE(
    .ex_alu_cmd(executeCMD_EXE_in),
	.ex_alu_src1(val1EXE_Forward), .ex_alu_src2(val2EXE_Forward),
	.reset(RST),
	.ex_is_imm(is_imm_EXE_IN),
    .ex_immval(imm_val_EXE_in),
	.inPort(inPort_EXE_in), .outPort(outPort_EXE_in),
	.inPort_Data(IN),

    .ex_out(ALU_result_EXE_out),
	.zero(sr_in[0]),
	.negative(sr_in[1]),
	.outPort_Data(OUT)
);

EXE_reg EXEReg(
	.clk(CLOCK),
	.rst(RST),
	.WB_EN_in(WB_en_EXE_in),
	.MEM_R_EN_in(memRead_EXE_in),.MEM_W_EN_in(memWrite_EXE_in),
	.Val_Ra_in(out1_EXE_in),
	.ALU_Res_in(ALU_result_EXE_out),
	.Dest_in(dest_EXE_in),
	
	.WB_EN(WB_en_MEM_in),
	.MEM_R_EN(MEM_R_EN_MEM_in), .MEM_W_EN(MEM_W_EN_MEM_in),
	.ALU_Res(ALU_result_MEM_in), .Val_Ra(ST_val_MEM_in), .Dest(Dest_MEM_in)
);
	// NEW for WB to MEM Forwarding
	//	.mem_data_in(ST_val_MEM_in),
assign WR2_MEM_Forward = (sel3_forward == 1'b1) ? writeVal:ST_val_MEM_in;
MEM_Stage mem(
	.clk(CLOCK),
	.rst(RST),
	.mem_rd_en(MEM_R_EN_MEM_in), 
	.mem_wr_en(MEM_W_EN_MEM_in),
	.mem_adr_in(ALU_result_MEM_in),
	.mem_data_in(WR2_MEM_Forward),
	.mem_data_out(Mem_read_value)
);

MEMReg memReg (
	.clk(CLOCK),
	.rst(RST),
	.WB_EN_in(WB_en_MEM_in),
	.MEM_R_EN_in(MEM_R_EN_MEM_in),
	.Val_LDR_in(Mem_read_value),
	.ALU_Res_in(ALU_result_MEM_in),
	.Dest_in(Dest_MEM_in),
	//to next stage
	.WB_EN(WB_en_WB_in),
	.MEM_R_EN(MEM_R_en_WB_in),
	.Val_LDR(Mem_read_value_WB_in),
	.ALU_Res(ALU_result_WB_in),
	.Dest(writeBackDest)
	);

WB_stage WB(
	.wb_ALU_data(ALU_result_WB_in),
	.mem_data_out(Mem_read_value_WB_in),
	.wb_data_sel(MEM_R_en_WB_in),
	.wb_data_out(writeVal)
);

hazadDetection hazard(
	.src1(src1_hazard),
	.src2(src2_hazard),
	.src1_en(src1_en_hazard),
	.src2_en(src2_en_hazard),
	.dest_EXE(dest_EXE_in),
	.mem_rd_en_EXE(memRead_EXE_in),
	.hazardDetected(hazardDetected)
);

Forward forward(
	.src1(src1_forward),
	.src2(src2_forward),
	.dest_MEM(Dest_MEM_in),
	.dest_WB(writeBackDest),
	.wb_MEM(WB_en_MEM_in),
	.wb_WB(WB_en_WB_in),
	.sel1(sel1_forward),
	.sel2(sel2_forward), 
	.sel3(sel3_forward)
);

RegSR #(2) Status_Register(.clk(CLOCK),.en(S_out_ID_Reg), .rst(RST), .in(sr_in), .out(sr_out));

endmodule
