`timescale 1ns/1ns
 /// Data Memory
module Data_mem (MemWrite,Memread,address,writeData,clk,readData);
  reg[7:0] memory [0:255];
  input MemWrite,Memread,clk;
  input [7:0] address,writeData;
  output [7:0] readData;
  
  always@(posedge clk) 
    begin
      if(MemWrite==1)
        memory[address]<=writeData;
    end
  assign readData = memory[address];
endmodule
