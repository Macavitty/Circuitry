`timescale 1ns / 1ps

module func(
    input signed [7:0] x_bi,
    input clk_i,
    input rst_i,
    input start_i,
    output busy_o, //?
    output reg signed [7:0] y_bo
    );
    
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    parameter signed [7:0] NEG_QUATER   = 8'b1010_0000;
    parameter signed [7:0] THIRD        = 8'b0010_1010;
    parameter signed [7:0] HALF         = 8'b0100_0000;
    
    reg state;
    reg signed [7:0] x, result;
    reg [2:0] ctr;
    wire end_step;
    reg sign;
    
    wire signed [7:0]  y_mult;
    wire signed [7:0] a_mult, b_mult;
    reg start_mult;
    wire busy_mult;
    
//    wire signed [7:0] mux_const_out, mux_x_out;  
//    wire signed [7:0] mux_const_in, mux_x_in;
//    reg [1:0] mux_const_adr;
//    reg mux_x_adr;
        
            
    mult mult_1 (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .a_bi(a_mult),
        .b_bi(b_mult),
        .start_i(start_mult),

        .busy_o(busy_mult),
        .y_bo(y_mult)
     );
          
    assign busy_o = state;
    
    always@ (posedge clk_i) begin
        if(rst_i) begin
            ctr <= 0;
            result <= 0;
            y_bo <= 0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE:
                    if(start_i)begin
                        state <= WORK;
                        x <= x_bi;
                        ctr <= 0;
                        result <= 0;
                        start_mult <= 0;
                    end
                WORK:
                    if (!busy_mult) begin
                        case (ctr)
                            4'd0: begin
                                    a_mult <= x;
                                    b_mult <= x; 
                                    start_mult <= 1;                         
                                  end
                            4'd2: begin
                                    a_mult <= y_mult;
                                    b_mult <= NEG_QUATER;
                                    start_mult <= 1;
                                   end
                            4'd4: begin
                                    result <= HALF + y_mult;
                                    a_mult <= y_mult;
                                    b_mult <= y_mult;
                                    start_mult <= 1;
                                  end
                            4'd6: begin
                                    a_mult <= y_mult;
                                    b_mult <= THIRD;
                                    start_mult <= 1;
                                  end
                            4'd8: begin 
                                    result <= result + y_mult;  
                                  end
                            4'd10: begin
                                    sign <= result[7:6];
                                    result <= result<<1;
                                  end 
                            4'd12: begin
                                    y_bo <= {sign,result}; 
                                    state <= IDLE; 
                                  end  
                        endcase 
                        ctr <= ctr + 1;
                    end else begin
                         start_mult <= 0;
                    end
            endcase
        end
    end
endmodule
