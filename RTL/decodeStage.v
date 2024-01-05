module decodeStage (
    input    wire           regWriteW,
    input    wire   [31:0]  instrD, resultW, aluOutM, pcPlus4D,
    input    wire   [4:0]   writeRegW,
    input    wire           forwardAD, forwardBD,
    input    wire           clk, rst,
    output   wire   [5:0]   opCode, func,
    output   wire   [31:0]  rd1D, rd2D, signImmD,
    output   wire   [31:0]  pcBrancD, pcJumpD,
    output   wire   [4:0]   rsD, rtD, rdE,
    output   wire           equalD
);

wire    [31:0]  signImmDTimes4;
wire    [31:0]  equalDIn1, equalDIn2;


assign  opCode    =   instrD[31:26];
assign  func      =   instrD[5:0];
assign  rsD       =   instrD[25:21];
assign  rtD       =   instrD[20:16];
assign  rdE       =   instrD[15:11];



signExtend #(32,16) U1_signExtend (
    .dataOut(signImmD),
    .dataIn(instrD[15:0])
);                          //将指令低16位扩展为32位

shiftLeftTwice #(32) U2_shiftLeftTwice (
    .out(signImmDTimes4),
    .in(signImmD)
);                          //将指令左移2位

pcBranch #(32)  U3_pcBranch (
    .pcBranch(pcBrancD),
    .shiftedSignImm(signImmDTimes4),
    .pcPlusFour(pcPlus4D)
);                          //将左移2位结果作为偏移量与指令地址相加获得条件跳转目标地址

shiftLeftTwice #(32, 26) U4_shiftLeftTwice (
    .out(pcJumpD),
    .in(instrD[25:0])
);                          //将指令低26位左移两位作为无条件跳转目标地址

Register_File #(32,32) U5_Register_File (
    .readData1(rd1D),
    .readData2(rd2D),
    .writeData(resultW),
    .readAddr1(instrD[25:21]),
    .readAddr2(instrD[20:16]),
    .writeAddr(writeRegW),
    .writeEnable(regWriteW),
    .clk(clk),
    .reset(rst)
);                          //寄存器堆

MUX #(32)  U6_MUX (
    .out(equalDIn1),
    .in1(aluOutM),
    .in2(rd1D),
    .sel(forwardAD)
);                          //根据是否前推选择比较的值来自于寄存器还是ALU输出

MUX #(32)  U7_MUX (
    .out(equalDIn2),
    .in1(aluOutM),
    .in2(rd2D),
    .sel(forwardBD)
);                          //根据是否前推选择比较的值来自于寄存器还是ALU输出

equality #(32)  U8_equality (
    .in1(equalDIn1),
    .in2(equalDIn2),
    .equalD(equalD)
);                          //判断运算结果相等

endmodule