`timescale 1ns / 1ps

module mult (
    input clk_i,
    input rst_i,

    input signed [7:0] a_bi,
    input signed [7:0] b_bi,
    input start_i,

    output busy_o,
    output reg signed [7:0] y_bo
    
);

    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;

    reg  [3:0]  ctr;
    wire [2:0]  /*ctr_next,*/ end_step;
    wire [7:0]  part_sum; 
    wire [15:0] shifted_part_sum;
    reg [7:0]   a, b;
    reg sign;
    reg [15:0]   part_res;
    reg state;
    
    
    assign part_sum = a & {8{b[ctr]}};
    assign shifted_part_sum = part_sum << (ctr+1);
//    assign ctr_next = ctr + 1;
    assign end_step = (ctr == 4'h8);
    assign busy_o = state;

    always@(posedge clk_i)
        if(rst_i) begin
           ctr      <= 0;
           part_res <= 0;
           y_bo     <= 0;
           sign     <= 0;
           state <= IDLE;
        end else begin

            case(state)
                IDLE:
                    if(start_i) begin
                        state  <= WORK;
                        a        <= a_bi[7] ? -a_bi : a_bi;
                        b        <= b_bi[7] ? -b_bi : b_bi;
                        sign     <= a_bi[7] ^ b_bi[7];
                        ctr      <= 0;
                        part_res <= 0;
                    end
                WORK:
                    begin
                        if(end_step) begin
                            state  <= IDLE;
                            y_bo    <= sign ? -part_res[15:8] : part_res[15:8];
                            y_bo[7] <= sign;
                        end

                        part_res = part_res + shifted_part_sum;
                      
                        ctr <= ctr + 1;
                        
                    end
            endcase
        end

endmodule

