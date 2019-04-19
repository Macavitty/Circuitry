module func(
    input [7:0] x_bi,
    input clk, 
    input rst,
    output [7:0] y_o
);
    parameter signed [7:0] NEG_QUATER   = 8'b1010_0000;
    parameter signed [7:0] THIRD        = 8'b0010_1010;


    reg signed [7:0] a_mult, b_mult, y_mult;
    reg signed [7:0] a_sum, b_sum, y_sum;
    reg signed [7:0] mux_counst_in,  
    mux_counst_adr,   
    
    reg start_mult, busy_mult;
    
    reg [2:0] ctr; 

    mult mult_1 (
        .clk_i(clk),
        .rst_i(rst),

        .a_bi(a_mult),
        .b_bi(b_mult),
        .start_i(start_mult),

        .busy_o(busy_mult),
        .y_bo(y_mult)
     );

    sum s(
        .a_bi(a_sum),
        .b_bi(b_sum),
        .y_bo(y_sum)
    );
    
    mux_41 mux_const(
        .a(),
        .x0(),
        .x1(NEG_QUATER),
        .x2(THIRD),
        .ans()
    );
    
    mux_21 mux_x(
        .a(),
        .x0(),
        .x1(),
        .ans()
    );
    
    always@(posedge clk, posedge rst) 
        if (rst) begin
            a_mult <= 0;
            b_mult <= 0;
            y_mult <= 0;
            a_sum <= 0;
            b_sum <= 0;
            y_sum <= 0;
            ctr <= 0;
        end else begin 
            if (!busy) begin
                case (ctr)
                    3'd0:
                    3'd1:
                    3'd2:
                    3'd3:
                    3'd4:
                endcase    
                ctr <= ctr + 1;
            end
    
        end

endmodule