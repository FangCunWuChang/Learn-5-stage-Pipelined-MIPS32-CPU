module ALU_Decoder (
    input   wire    [3:0]      aluOp,               //ALU指令类型
    input   wire    [5:0]      func,                //运算类型
    output  reg     [3:0]      aluController        //ALU控制信号
);

localparam   add = 6'b10_0000,
             sub = 6'b10_0010,
             slt = 6'b10_1010,
             mul = 6'b00_0010;

always @(*)
    begin
        case (aluOp)
            4'b0000   :    aluController = 4'b0000;
            4'b0001   :    aluController = 4'b0001;
            4'b0010   :    begin
                            case (func)
                                add     :   aluController = 4'b0000;
                                sub     :   aluController = 4'b0001;
                                slt     :   aluController = 4'b0011;
                                default :   aluController = 4'b0000;
                            endcase
                         end 
            4'b0011   :    begin
                            case (func)
                                mul     :   aluController = 4'b0010;
                                default :   aluController = 4'b0000;
                            endcase
                         end 
            default :   aluController = 4'b0000;
        endcase
    end
endmodule