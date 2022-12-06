`timescale 1ns/1ns
module EXE_Stage(
    inPort,
    outPort,
    inPort_Data,
    outPort_Data,
    ex_alu_cmd,
    ex_is_imm,
    ex_immval,
    ex_alu_src1,
    ex_alu_src2,
    ex_out,
    reset,
    zero,
    negative
);
  
input [3:0] ex_alu_cmd;//ALUControl   !!!!!!!!!!!!!!!!!!
input [7:0] ex_alu_src1,ex_alu_src2,ex_immval,inPort_Data;// data1, data2
output [7:0] ex_out, outPort_Data;//ALUResult
output zero,negative;
input reset, ex_is_imm, inPort, outPort;

wire [7:0] val2_ALU_out_mux;
// for select In-port or Imm or alu result in output alu
assign outPort_Data = (outPort) ? ex_alu_src1 : 8'bzzzzzzzz;
ALU A1(ex_alu_src1,ex_alu_src2,ex_alu_cmd,zero, negative, val2_ALU_out_mux, reset);  
assign ex_out = (inPort) ? inPort_Data:
    (ex_is_imm) ? ex_immval : val2_ALU_out_mux;

endmodule
  
