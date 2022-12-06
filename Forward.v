module Forward(
        input[1:0] src1, src2, dest_MEM, dest_WB,
        input wb_MEM, wb_WB,
        output[1:0] sel1, sel2,
        output sel3
);
        // Forward from MEM or WB to EXEC
        // Multiplexer 1:
        assign sel1 = 
                (src1 == dest_MEM & wb_MEM) ? 2'b01 :
                (src1 == dest_WB & wb_WB) ? 2'b10 :
                2'b00;  
        // Multiplexer 2:
        assign sel2 = 
                (src2 == dest_MEM & wb_MEM) ? 2'b01 :
                (src2 == dest_WB & wb_WB) ? 2'b10 :
                2'b00;
          // NEW
        assign sel3 = 
                (dest_MEM == dest_WB & wb_WB) ? 1'b1 :
                1'b0;
endmodule
