`timescale 1ns / 1ps

module mux_21(
    input a,
    input [7:0] x0,
    input [7:0] x1,
    output reg [7:0] ans
    );
    
    always@ (a) begin
        if(a) begin
            ans = x1;
        end else begin
            ans = x0;
        end
    end
endmodule