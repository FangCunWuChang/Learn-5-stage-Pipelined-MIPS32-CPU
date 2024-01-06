module ALU_Decoder (
    input   wire    [3:0]      aluOp,               //ALU指令类型
    input   wire    [5:0]      func,                //运算类型
    output  reg     [3:0]      aluController        //ALU控制信号
);

localparam   add = 6'b10_0000,
             sub = 6'b10_0010,
             slt = 6'b10_1010,
             and_ = 6'b10_0100,
             or_ = 6'b10_0101,
             xor_ = 6'b10_0110,
             nor_ = 6'b10_0111,
             mul = 6'b00_0010;

always @(*)
    begin
        case (aluOp)
            4'b0000   :    aluController = 4'b0000;
            4'b0001   :    aluController = 4'b0001;
            4'b0100   :    aluController = 4'b0011;
            4'b0010   :    begin
                            case (func)
                                add     :   aluController = 4'b0000;
                                sub     :   aluController = 4'b0001;
                                slt     :   aluController = 4'b0011;
                                and_     :   aluController = 4'b0100;
                                or_     :   aluController = 4'b0101;
                                xor_     :   aluController = 4'b0110;
                                nor_     :   aluController = 4'b0111;
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