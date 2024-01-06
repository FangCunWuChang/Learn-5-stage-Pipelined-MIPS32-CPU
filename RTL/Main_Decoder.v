module Main_Decoder (
    input    wire     [5:0]     opCode,
    output   reg      [3:0]     aluOp,
    output   reg                memWrite, regWrite, regDest, aluSrc, memtoReg, branch, jump
);

reg     [10:0]     flags;  

localparam loadWord        = 6'b10_0011,        //LW
           storeWord       = 6'b10_1011,        //SW
           spec            = 6'b00_0000,        //ALU OPs
           spec2           = 6'b01_1100,        //ALU OPs
           addImmediate    = 6'b00_1000,        //ADDI
           branchIfEqual   = 6'b00_0100,        //BEQ
           jump_inst       = 6'b00_0010;        //J

always @(*)
    begin
        {jump, aluOp, memWrite, regWrite, regDest, aluSrc, memtoReg, branch} = flags;
    end

always @(*)
    begin
        case (opCode)
            loadWord      : flags = 11'b000_0001_0110;
            storeWord     : flags = 11'b000_0010_0110;
            spec          : flags = 11'b000_1001_1000;
            spec2         : flags = 11'b000_1101_1000;
            addImmediate  : flags = 11'b000_0001_0100;
            branchIfEqual : flags = 11'b000_0100_0001;
            jump_inst     : flags = 11'b100_0000_0000;
            default       : flags = 11'b000_0000_0000;
        endcase
    end
endmodule 