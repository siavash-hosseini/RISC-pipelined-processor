`timescale 1ns/1ns
// Write Back Stage Multiplexer
module WB_stage ( 
	//From MEM (ALU or Load)
	input [7:0] wb_ALU_data   ,
	input [7:0] mem_data_out  ,
	input        wb_data_sel   , 
	//To Register File
	output[7:0] wb_data_out	
);
					  
					  
	assign wb_data_out = (wb_data_sel==1'b0) ? wb_ALU_data : mem_data_out;

endmodule