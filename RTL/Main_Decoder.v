module Main_Decoder (
    input    wire     [5:0]     opCode,
    output   reg      [3:0]     aluOp,
    output   reg                memWrite, regWrite, regDest, aluSrc, memtoReg, branch, jump, reverse
);

reg     [11:0]     flags;  

localparam loadWord             = 6'b10_0011,        //LW
           storeWord            = 6'b10_1011,        //SW
           spec                 = 6'b00_0000,        //ALU OPs
           spec2                = 6'b01_1100,        //ALU OPs
           addImmediate         = 6'b00_1000,        //ADDI
           sltImmediate         = 6'b00_1010,        //SLTI
           branchIfEqual        = 6'b00_0100,        //BEQ
           branchIfNotEqual     = 6'b00_0101,        //BNE
           jump_inst            = 6'b00_0010;        //J

always @(*)
    begin
        {reverse, jump, aluOp, memWrite, regWrite, regDest, aluSrc, memtoReg, branch} = flags;
    end

always @(*)
    begin
        case (opCode)
            loadWord            : flags = 12'b0000_0001_0110;
            storeWord           : flags = 12'b0000_0010_0110;
            spec                : flags = 12'b0000_1001_1000;
            spec2               : flags = 12'b0000_1101_1000;
            addImmediate        : flags = 12'b0000_0001_0100;
            sltImmediate        : flags = 12'b0001_0001_0100;
            branchIfEqual       : flags = 12'b0000_0100_0001;
            branchIfNotEqual    : flags = 12'b1000_0100_0001;
            jump_inst           : flags = 12'b0100_0000_0000;
            default             : flags = 12'b0000_0000_0000;
        endcase
    end
endmodule 