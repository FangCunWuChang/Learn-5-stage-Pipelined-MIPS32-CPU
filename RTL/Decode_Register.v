module Decode_Register (
    input     wire        [31:0]       rd, pcPlus4F,
    input     wire                     clk, en, clear, rst,
    output    reg         [31:0]       instrD, pcPlus4D
);

always @(posedge clk or negedge rst)
        begin
            if(!rst)                        //重置
                begin
                    instrD   <=    32'b0;
                    pcPlus4D <=    32'b0;
                end
            else if (clear & !en)           //清除指令寄存器和PC寄存器
                begin
                    instrD   <=    32'b0;
                    pcPlus4D <=    32'b0;
                end
            else if(!en)                    //读取指令
                begin
                    instrD   <=    rd;
                    pcPlus4D <=    pcPlus4F;
                end
        end
endmodule 