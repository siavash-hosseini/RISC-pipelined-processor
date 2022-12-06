module controlUnit (
	input[3:0] opcode,
	input Z,N,BRX,
	output WB_EN, MEM_R_EN, MEM_W_EN, B, S, Ret, L, IMM, SRC1, SRC2, inPort, outPort,
	output [3:0] EXE_CMD
);
/* 
Input : opcode, Z,N,BRX,
Output:
	 BRX
	 WB_EN,
	 MEM_R_EN, 
	 MEM_W_EN, 
	 B, 
	 S,
	 Ret, 
	 L, 
	 IMM, 
	 SRC1, 
	 SRC2, 
	 inPort, 
	 outPort
	 
	 EXE_CMD
*/

// List A format instructions
parameter NOP = 4'b0000; 
parameter ADD = 4'b0001;
parameter SUB = 4'b0010;
parameter NAND = 4'b0011;
parameter SHL = 4'b0100;
parameter SHR = 4'b0101;
parameter OUT = 4'b0110;
parameter IN = 4'b0111;
parameter MOV = 4'b1000;
	// A format + Load + LoadIMM  set WB_EN=1
	assign WB_EN =
		opcode==4'b0001 ||
		opcode==4'b0010 ||
		opcode==4'b0011 ||
		opcode==4'b0100 ||
		opcode==4'b0101 ||
		opcode==4'b1000 ||
		opcode==4'b1101 ||
		opcode==4'b0111 ||
		opcode==4'b1111;
	assign MEM_R_EN = opcode==4'b1101; //just  Load set MEM_R_EN=1
	assign MEM_W_EN = opcode==4'b1110; //just Store set MEM_W_EN=1
	// BRX , BR.Z , BR.N , BR,SUB , Return => set B=1
	assign B = 
		opcode==4'b1001 ||
		(opcode==4'b1010 && Z && !BRX) ||
		(opcode==4'b1010 && N && BRX) || 
		opcode==4'b1011 ||
		opcode==4'b1100;
		// Add, Sub, Nand, SHL, SHR  => set S=1
	assign S = 
		opcode==4'b0001 ||
		opcode==4'b0010 ||
		opcode==4'b0011 ||
		opcode==4'b0100 ||
		opcode==4'b0101;
		
	assign Ret = opcode==4'b1100; // Return => set Ret=1
	assign L = opcode==4'b1011; // Br.sub   => set L=1  
	assign IMM = opcode==4'b1111 || opcode==4'b1101 || opcode==4'b1110; // loadimm, load , store => set IMM=1
	// A format  f=> set SRC1=1
	assign SRC1 = 
		opcode==4'b0001 ||
		opcode==4'b0010 ||
		opcode==4'b0011 ||
		opcode==4'b0100 ||
		opcode==4'b0101 ||
		opcode==4'b0110 ||
		opcode==4'b0111 ||
		opcode==4'b1000; 
		// || opcode==4'b1110;   store removed( ADD data forwarding store after load)
	// add, sub, nand   => set SRC2=1
	assign SRC2 = 
		opcode==4'b0001 ||
		opcode==4'b0010 ||
		opcode==4'b0011;
	assign EXE_CMD = 
		(opcode==4'b0001) ? ADD: //add
		(opcode==4'b0010) ? SUB: //sub
		(opcode==4'b0011) ? NAND: //nand
		(opcode==4'b0100) ? SHL: //shl
		(opcode==4'b0101) ? SHR: //shr
		(opcode==4'b0110) ? OUT: //out
		(opcode==4'b0111) ? IN: //in
		(opcode==4'b1000) ? MOV: //mov
		(opcode==4'b1101) ? MOV: //ldr
		(opcode==4'b1110) ? MOV: //sdr
		(opcode==4'b1111) ? MOV: //ldrimm
		NOP;

	assign inPort = (opcode==4'b0111);  // set In_Port = 1
	assign outPort = (opcode==4'b0110); //set Out_Prot = 1
endmodule