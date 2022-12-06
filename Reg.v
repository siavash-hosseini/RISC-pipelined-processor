module Reg(clk,en, rst, in, out);
	parameter DATA_WIDTH = 8;

	input rst,en,clk;
	input[DATA_WIDTH-1:0] in;
	output reg [DATA_WIDTH-1:0] out;

	always@(posedge clk,posedge rst) begin
		if (rst) begin
			out = 8'd0;
		end
		else if(en) begin
			out = in;
		end
	end

endmodule
	