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
     
    mux_31 mux_const(
        .a(mux_const_adr),
        .x0(mux_const_in),
        .x1(NEG_QUATER),
        .x2(THIRD),
        .ans(mux_const_out) // TODO set as in in mux_x
    );
    
    mux_21 mux_x(
        .a(mux_x_adr),
        .x0(x_bi),
        .x1(mux_x_in),
        .ans(mux_x_out)
    );
     
    assign busy_o = state;
    assign end_step = (ctr == 3'd4);
    assign a_mult = mux_x_out;
    assign b_mult = mux_const_out;
    assign mux_const_in = mux_x_out;
    assign mux_x_in = y_mult;
    
    always@ (clk_i) begin
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
                        if(!clk_i) begin
                            case (ctr)
                                3'd0: begin
                                        mux_x_adr <= 0;
                                        mux_const_adr <= 0; 
                                        start_mult <= 1;                         
                                      end
                                3'd1: begin 
                                         mux_x_adr <= 1;
                                         mux_const_adr <= 1;
                                         start_mult <= 1;
                                       end
                                3'd2: begin  
                                         mux_x_adr <= 1;
                                         mux_const_adr <= 0;
                                         result = HALF + y_mult;
                                         start_mult <= 1;
                                      end
                                3'd3: begin 
                                          mux_x_adr <= 1;
                                          mux_const_adr <= 2;
                                          start_mult <= 1;
                                      end
                                3'd4: begin 
                                        start_mult = 0;
                                        result = result + y_mult;  
                                      end
                            endcase 
                            ctr <= ctr + 1;
                        end else begin
                            if(end_step) begin
                                sign = result[7:6];
                                y_bo = {sign,result<<1}; 
                                state <= IDLE; 
                            end
                        end
                    end else begin
                        start_mult = 0;
                    end
            endcase
        end
    end
endmodule
