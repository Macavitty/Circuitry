module sum (

    input  [7:0] a_bi,
    input signed [7:0] b_bi,

    output signed [7:0] y_bo
);

    assign y_bo = a_bi + b_bi;
    
endmodule