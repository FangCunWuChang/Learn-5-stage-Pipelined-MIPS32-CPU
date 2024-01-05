module ALU #(
    parameter DATA_WIDTH = 32,
    parameter OP_WIDTH   = 2
) (
    output reg   [DATA_WIDTH-1:0]  aluOut,          //运算结果
    input  wire  [OP_WIDTH-1:0]    aluFunc,         //ALU控制信号
    input  wire  [DATA_WIDTH-1:0]  A, B             //操作数
);

localparam ADD   =  2'b00;
localparam SUB   =  2'b01;
localparam MUL   =  2'b10;
localparam SLT   =  2'b11;

always @ (*)
    begin 
        case (aluFunc)
            ADD: aluOut = A + B;                    //加
            SUB: aluOut = A - B;                    //减
            MUL: aluOut = A * B;                    //乘
            SLT: aluOut = (A < B) ? {{(DATA_WIDTH - 1){1'b0}}, 1'b1} :  {(DATA_WIDTH){1'b0}};  //有符号小于
            default: aluOut = {(DATA_WIDTH){1'b0}};
        endcase
    end

endmodule