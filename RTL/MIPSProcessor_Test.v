module MIPSProcessor_Test ();

reg clk, rst;
wire [31:0] testOutput;

always #10 clk = ~clk;
 
initial                                                
begin                                                   
  clk = 1'b0;
  
  rst = 1'b1; // 复位
  #5 rst = 1'b0;
  #5 rst = 1'b1;

  $display("Running testbench"); 
end

MIPSProcessor cpu (
    .clk(clk),
    .rst(rst),
    .testDataOut(testOutput)
);

endmodule