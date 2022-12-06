module hazadDetection(
        input[1:0]src1,src2,dest_EXE,
        input src1_en, src2_en, mem_rd_en_EXE,
        output hazardDetected
);
        assign hazardDetected = 
                (src1_en & src1 == dest_EXE & mem_rd_en_EXE) ||
                (src2_en & src2 == dest_EXE & mem_rd_en_EXE); 
endmodule

 //   if src1 for A_format+Stroe and prev inst is load
 //   or  src2 for add, sub, nand  prev inst is load 
 //   Insert Stall

