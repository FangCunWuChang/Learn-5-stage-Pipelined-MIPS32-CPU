module ALU #(
    parameter DATA_WIDTH = 32,
    parameter OP_WIDTH   = 4
) (
    output reg   [DATA_WIDTH-1:0]  aluOut,          //运算结果
    input  wire  [OP_WIDTH-1:0]    aluFunc,         //ALU控制信号
    input  wire  [DATA_WIDTH-1:0]  A, B             //操作数
);

localparam ADD   =  4'b0000;
localparam SUB   =  4'b0001;
localparam MUL   =  4'b0010;
localparam SLT   =  4'b0011;
localparam AND   =  4'b0100;
localparam OR   =  4'b0101;
localparam XOR   =  4'b0110;
localparam NOR   =  4'b0111;

always @ (*)
    begin 
        case (aluFunc)
            ADD: aluOut = A + B;                    //加
            SUB: aluOut = A - B;                    //减
            MUL: aluOut = A * B;                    //乘
            SLT: aluOut = (A < B) ? {{(DATA_WIDTH - 1){1'b0}}, 1'b1} :  {(DATA_WIDTH){1'b0}};  //有符号小于
            AND: aluOut = A && B;                   //逻辑与
            OR: aluOut = A || B;                    //逻辑或
            XOR: aluOut = (A != 0) != (B != 0);     //逻辑异或
            NOR: aluOut = (A != 0) == (B != 0);     //逻辑或非
            default: aluOut = {(DATA_WIDTH){1'b0}};
        endcase
    end

endmodule