module dataMemory #(
    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 32,  
    parameter DEPTH         = 128 //NUMBER_OF_ENTRIES
) (
    output wire [DATA_WIDTH-1:0]    readData,       //读出的数据
    output wire [DATA_WIDTH-1:0]    testData,    // For Testing Purposes 
    input  wire [DATA_WIDTH-1:0]    writeData,      //写入的数据
    input  wire [ADDRESS_WIDTH-1:0] addr,           //地址
    input  wire                     writeEnable,    //写入使能
    input  wire                     clk,            //时钟
    input  wire                     reset           //重置
);
integer i;

reg [DATA_WIDTH-1:0] dMEM [0:DEPTH-1]; 

always @(posedge clk or negedge reset)
    begin 
         if (!reset)
            begin
                for (i = 0; i < DEPTH; i = i + 1)
                    begin
                        dMEM [i] <= {(DATA_WIDTH){1'b0}};
                    end
            end
        else if (writeEnable)
            begin 
                dMEM [addr] <= writeData;
            end
    end

assign readData = dMEM [addr]; //We always read our data asynchronously (regardless of the clock edge)
assign testData = dMEM [{(ADDRESS_WIDTH) {1'b0}}];

endmodule