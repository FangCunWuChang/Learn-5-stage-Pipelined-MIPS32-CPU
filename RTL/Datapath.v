module Datapath (
    input      wire               clearD, jump, pcSrcD, 
    input      wire               memWrite, regWrite, regDest, aluSrc, memtoReg, 
    input      wire    [3:0]      aluController,
    input      wire               stallD, stallF, flushE,       //指令读取使能，PC使能，执行使能
    input      wire               forwardAD, forwardBD,
    input      wire    [1:0]      forwardAE, forwardBE,
    input      wire               clk, rst,
    output     wire    [5:0]      opCode, func,
    output     wire               equalD,
    output     wire               regWriteM, memToRegM, regWriteE, memToRegE, regWriteW,
    output     wire    [4:0]      writeRegE, writeRegMOut, writeRegW, rsEHazardUnit, rsD, rtEHazardUnit, rtD,
    output     wire    [31:0]     testDataOut
);

wire    [31:0]   pcMux1Out, pcOld, pcPlus4F, pcPlus4D, pcBranchD, pcJumpD;
wire    [31:0]   pcF, rd;
wire    [31:0]   instrD, resultW, aluOutMOut, aluOutMIn, aluOutM, writeDataM;
wire    [4:0]    writeRegWIn, writeRegMIn, writeRegM, rdD;
wire    [31:0]   rd1D, rd2D, signImmD, signImmE;
wire             memWriteE, aluSrcE, regDstE;
wire    [3:0]    aluControlE;
wire    [31:0]   rd1E, rd2E, writeDataE, aluOutE;
wire    [4:0]    rdE, rsE, rtE;
wire             memToRegW, memWriteM;
wire    [31:0]   readDataM, readDataW, aluOutW;

MUX #(32) U1_MUX (
    .out(pcMux1Out),
    .in1(pcBranchD),
    .in2(pcPlus4F),
    .sel(pcSrcD)
);                      //有条件跳转设置PC

MUX #(32) U2_MUX (
    .out(pcOld),
    .in1(pcJumpD),
    .in2(pcMux1Out),
    .sel(jump)
);                      //无条件跳转设置PC

Program_Counter #(32)  U3_Program_Counter (
    .pcNew(pcF),
    .pcOld(pcOld),
    .clk(clk),
    .reset(rst),
    .enable(stallF)
);                      //用New更新Old，接受重置

fetchSatge U4_fetchSatge (
    .rd(rd),
    .pcPlus4F(pcPlus4F),
    .pcF(pcF)
);                      //从rom取指令到rd并将PC+4

Decode_Register U5_Decode_Register(
    .rd(rd),
    .pcPlus4F(pcPlus4F),
    .clk(clk),
    .rst(rst),
    .en(stallD),
    .clear(clearD),
    .instrD(instrD),
    .pcPlus4D(pcPlus4D)
);                     //由rd更新指令，接受清除与重置

decodeStage U6_decodeStage (
    .regWriteW(regWriteW),
    .instrD(instrD),
    .resultW(resultW),
    .aluOutM(aluOutMOut),
    .pcPlus4D(pcPlus4D),
    .writeRegW(writeRegW),
    .forwardAD(forwardAD),
    .forwardBD(forwardBD),
    .clk(clk),
    .rst(rst),
    .opCode(opCode),
    .func(func),
    .rd1D(rd1D),
    .rd2D(rd2D),
    .signImmD(signImmD),
    .pcBrancD(pcBranchD),
    .pcJumpD(pcJumpD),
    .rsD(rsD),
    .rtD(rtD),
    .rdE(rdD),
    .equalD(equalD)
);                   //译码，寄存器控制，判等

Execute_Register U7_Execute_Register (
    .regWriteE(regWriteE),
    .memToRegE(memToRegE),
    .memWriteE(memWriteE),
    .aluControlE(aluControlE),
    .aluSrcE(aluSrcE),
    .regDstE(regDstE),
    .rd1E(rd1E),
    .rd2E(rd2E),
    .rsE(rsE),
    .rtE(rtE),
    .rdE(rdE),
    .signImmE(signImmE),
    .regWriteD(regWrite),
    .memToRegD(memtoReg),
    .memWriteD(memWrite),
    .aluControlD(aluController),
    .aluSrcD(aluSrc),
    .regDstD(regDest),
    .rd1D(rd1D),
    .rd2D(rd2D),
    .rsD(rsD),
    .rtD(rtD),
    .rdD(rdD),
    .signImmD(signImmD),
    .clk(clk),
    .reset(rst),
    .clear(flushE)
);                  //从译码结果更新执行的寄存器

executeStage U8_executeStage (
    .regDstE(regDstE),
    .aluSrcE(aluSrcE),
    .aluControlE(aluControlE),
    .rd1D(rd1E),
    .rd2D(rd2E),
    .rsE(rsE),
    .rtE(rtE),
    .rdE(rdE),
    .signImmE(signImmE),
    .aluOutMOut(aluOutMOut),
    .resultW(resultW),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .rsEHazardUnit(rsEHazardUnit),
    .rtEHazardUnit(rtEHazardUnit),
    .writeRegE(writeRegE),
    .writeDataE(writeDataE),
    .aluOutE(aluOutE)
);                  //执行，获得ALU运算结果

Memory_Register U9_Memory_Register (
    .regWriteE(regWriteE),
    .memToRegE(memToRegE),
    .memWriteE(memWriteE),
    .aluOutE(aluOutE),
    .writeRegE(writeRegE),
    .writeDataE(writeDataE),
    .clk(clk),
    .rst(rst),
    .regWriteM(regWriteM),
    .memToRegM(memToRegM),
    .memWriteM(memWriteM),
    .aluOutM(aluOutMIn),
    .writeDataM(writeDataM),
    .writeRegM(writeRegMIn)
);                  //从执行结果更新访存的寄存器

memStage U10_memStage (
    .writeRegMOut(writeRegMOut),
    .aluOutMOut(aluOutMOut),
    .readDataM(readDataM),
    .aluOutM(aluOutM),
    .writeRegM(writeRegM),
    .testDataOut(testDataOut),
    .writeRegMIn(writeRegMIn),
    .aluOutMIn(aluOutMIn),
    .writeDataM(writeDataM),
    .memWriteM(memWriteM),
    .clk(clk),
    .reset(rst)
);                  //访问RAM存储器

WriteBack_Register U11_WriteBack_Register (
    .regWriteM(regWriteM),
    .memToRegM(memToRegM),
    .readDataM(readDataM),
    .aluOutM(aluOutM),
    .writeRegM(writeRegM),
    .clk(clk),
    .rst(rst),
    .regWriteW(regWriteW),
    .memToRegW(memToRegW),
    .readDataW(readDataW),
    .aluOutW(aluOutW),
    .writeRegW(writeRegWIn)
);              //从执行与访存结果更新回写的寄存器

writeBackStage U12_writeBackStage (
    .resultW(resultW),
    .writeRegWOut(writeRegW),
    .memToRegW(memToRegW),
    .readDataW(readDataW),
    .aluOutW(aluOutW),
    .writeRegWIn(writeRegWIn)
);          //进行寄存器回写，并暂存该指令执行结果

endmodule