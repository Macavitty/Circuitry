`timescale 1ns / 1ps

module test;
    reg clk = 0;
    reg rst; 
    
    always #10 clk = ~clk;
    
    
    reg signed [7:0] a,b;
    wire signed [15:0] y;
    wire busy;
    reg start;
    wire [3:0] ctr;
       
     sum s(
        .a_bi(a),
        .b_bi(b),
        .y_bo(y)
        );
        
//     mult m(
//        .clk_i(clk),
//        .rst_i(rst),

//        .a_bi(a),
//        .b_bi(b),
//        .start_i(start),

//        .busy_o(busy),
//        .y_bo(y)
//     );
    
initial begin
    #10
    rst = 1;
    #10
    rst = 0;
    a = -8'b0100_0000; 
    $display("A = %b", a);
    b = 8'b0010_0000;
    #10
    if (!busy) begin
        start = 1;
    end
    #10
    while (busy) begin 
        #10
        $display("buzy = %b", busy);
    end
   $display("Y = %b", y[15:0]);
      #10      
    $stop;

end

endmodule