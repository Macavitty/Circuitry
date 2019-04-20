module func(
    input signed [7:0] x_bi,
    input clk, 
    input rst,
    output reg signed [7:0] y_bo
);
    parameter signed [7:0] NEG_QUATER   = 8'b1010_0000;
    parameter signed [7:0] THIRD        = 8'b0010_1010;
    parameter signed [7:0] HALF         = 8'b0100_0000;
    
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;

    reg signed [7:0]  y_mult;
    wire signed [7:0] a_mult, b_mult;
    reg start_mult, busy_mult;
    
    reg signed [7:0] mux_const_out, mux_x_out;  
    wire signed [7:0] mux_const_in, mux_x_in;
    reg [1:0] mux_const_adr;
    reg mux_x_adr;
    
    reg signed [7:0] sum;
    reg [2:0] ctr; 
    
    reg state;

    mult mult_1 (
        .clk_i(clk),
        .rst_i(rst),

        .a_bi(a_mult),
        .b_bi(b_mult),
        .start_i(start_mult),

        .busy_o(busy_mult),
        .y_bo(y_mult)
     );

    
    mux_41 mux_const(
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
    
    assign a_mult = mux_x_out;
    assign b_mult = mux_const_out;
    assign mux_const_in = mux_x_out;
    assign mux_x_in = y_mult;
    
    always@(posedge clk, posedge rst) 
        if (rst) begin
//            a_mult <= 0;
//            b_mult <= 0;
            y_mult <= 0;
            ctr <= 0;
            state <= IDLE;
        end else begin 
            if (!busy_mult) begin
                case (ctr)
                    3'd0: begin
                            mux_x_adr <= 0;
                            mux_const_adr <= 0; 
                            start_mult = 1;                         
                          end
                    3'd1: begin 
                             mux_x_adr <= 1;
                             mux_const_adr <= 1;
                             start_mult = 1;
                           end
                    3'd2: begin  
                             mux_x_adr <= 1;
                             mux_const_adr <= 0;
                             sum = HALF + y_mult;
                             start_mult = 1;
                          end
                    3'd3: begin 
                              mux_x_adr <= 1;
                              mux_const_adr <= 2;
                              start_mult = 1;
                          end
                    3'd4: begin 
                            sum = sum + y_mult;
                            y_bo = sum;   
                            start_mult = 0;
                          end
                endcase 
                // here were a and b mult   
                ctr <= ctr + 1;
            end
         end

endmodule