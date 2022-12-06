`timescale 1ns/1ns
module RegisterFile(
  clk,
  rst,
  rg_wrt_enable,
  rg_wrt_dest,
  rg_wrt_data,
  rg_rd_addr1,
  rg_rd_data1,
  rg_rd_addr2,
  rg_rd_data2
);
 
input clk,rst;
input rg_wrt_enable;

input [1:0] rg_wrt_dest,rg_rd_addr1,rg_rd_addr2;
input  [7:0] rg_wrt_data;
output [7:0] rg_rd_data1,rg_rd_data2;

reg [7:0] register_file [3:0];

always @(negedge clk) begin
	if(rst==1'b1)
  begin
    register_file[0] = 8'd0; //R0
    register_file[1] = 8'd1; //R1
    register_file[2] = 8'd2; //R2
    register_file[3] = 8'd3; //R3
  end
  else
    if(rg_wrt_enable==1'b1)
      register_file[rg_wrt_dest] =rg_wrt_data;
end
  assign rg_rd_data1=register_file[rg_rd_addr1];
  assign rg_rd_data2=register_file[rg_rd_addr2]; 
endmodule
  



    
