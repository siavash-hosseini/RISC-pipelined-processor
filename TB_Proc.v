`timescale 1ns/1ns

module TB();

	reg clk = 1, rst = 0;
	wire [7:0] IN,OUT;
	assign IN = 4'hF;
	Processor Proc(.CLOCK(clk), .RST(rst), .IN(IN), .OUT(OUT));

	always #50 clk = ~clk;

	initial begin
		#100
		rst = 1;
		#300
		rst = 0;
		#1000000
		$stop;
	end

endmodule
