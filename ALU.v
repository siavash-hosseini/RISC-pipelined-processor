
module ALU(data1, data2, ALUControl, zero, negative, ALUResult, rst);

input wire rst;
input wire signed [7:0] data1,data2;
input wire [3:0] ALUControl;
output reg zero,negative;
output reg signed [7:0] ALUResult;

parameter NOP = 4'b0000;
parameter ADD = 4'b0001;
parameter SUB = 4'b0010;
parameter NAND = 4'b0011;
parameter SHL = 4'b0100;
parameter SHR = 4'b0101;
parameter OUT = 4'b0110;
parameter IN = 4'b0111;
parameter MOV = 4'b1000;

always @(ALUControl, data1, data2)
begin
zero = 1'b0;
negative = 1'b0;
case(ALUControl)
	ADD: 
		begin	
		ALUResult = data1 + data2;
		if( ALUResult == 0)
		zero = 1'b1;
		else 
		zero = 1'b0;
		if (ALUResult[7] == 1'b1)
		negative = 1'b1;
		else 
		negative = 1'b0;
		end

	SUB:
		begin
		ALUResult = data1 - data2;
		if( ALUResult == 0)
		zero = 1'b1;
		else 
		zero = 1'b0;
		if (ALUResult[7] == 1'b1)
		negative = 1'b1;
		else 
		negative = 1'b0;
		end

		
	NAND:
		begin
		ALUResult = ~(data1 & data2);
		if( ALUResult == 0)
		zero = 1'b1;
		else 
		zero = 1'b0;
		if (ALUResult[7] == 1'b1)
		negative = 1'b1;
		else 
		negative = 1'b0;
		end

	SHL:
		begin
		zero =data1[7];
		ALUResult[7:1] = data1[6:0];
		ALUResult[0] = 1'b0;
		end
	SHR:
		begin
		zero=data1[0];
		ALUResult[6:0] = data1[7:1];
		ALUResult[7] = 1'b0;
		end
	MOV:
		ALUResult = data2;
	default: ALUResult = 0;
endcase
end

endmodule
