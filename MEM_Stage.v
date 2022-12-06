`timescale 1ns/1ns
//Memory Stage
module MEM_Stage(
    input clk, rst,
    //needed for memory inputs
    input [7:0] mem_data_in   , 
    input [7:0]  mem_adr_in    ,
    input        mem_wr_en,mem_rd_en, 
    output [7:0] mem_data_out
);	
//Memory instantiation

Data_mem Data_MEM_ins(
    .clk(clk),
    .address(mem_adr_in),
    .writeData(mem_data_in),
    .readData(mem_data_out), 
    .Memread(mem_rd_en),
    .MemWrite(mem_wr_en)
);	
endmodule
