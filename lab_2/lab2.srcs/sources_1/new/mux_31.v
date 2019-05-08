`timescale 1ns / 1ps

module mux_31(
    input [1:0] a,
    input [7:0] x0,
    input [7:0] x1,
    input [7:0] x2,
    output reg [7:0] ans
    );
    
    always@ (a) begin
        case(a)
            2'd0: ans = x0;
            2'd1: ans = x1;
            2'd2: ans = x2;
        endcase
    end
endmodule
