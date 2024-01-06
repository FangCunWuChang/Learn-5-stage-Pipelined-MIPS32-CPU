module Controller (
    input    wire    [5:0]      opCode, func,       //指令类型，ALU运算类型
    input    wire               equalD,             //是否相等，用于BEQ指令
    output   wire               memWrite, regWrite, regDest, aluSrc, memtoReg, jump, pcSrcD, clearD, branch, 
                                //内存写使能，寄存器写使能，目标寄存器，ALU操作数来源，内存到寄存器传输控制，无条件跳转控制，PC数据来源控制，清除寄存器信号，条件跳转控制
    output   wire    [3:0]      aluController       //ALU控制信号
);

wire      [3:0]     aluOp;

assign pcSrcD = branch & equalD;        //如果有条件跳转且相等，则PC数据来源置1，否则为0
assign clearD = pcSrcD | jump;          //如果执行跳转，则清除寄存器

Main_Decoder U1_MD1 (
    .opCode(opCode),
    .aluOp(aluOp),
    .memWrite(memWrite),
    .regWrite(regWrite),
    .regDest(regDest),
    .aluSrc(aluSrc),
    .memtoReg(memtoReg),
    .jump(jump),
    .branch(branch)
);                              //解码指令

ALU_Decoder  U2_ALUD (
    .aluOp(aluOp),
    .func(func),
    .aluController(aluController)
);                              //解码ALU运算

endmodule

