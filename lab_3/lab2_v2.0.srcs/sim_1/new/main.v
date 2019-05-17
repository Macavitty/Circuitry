`timescale 1ns / 1ps

module main();

reg clk = 1, rst, start;
reg signed [7:0] x;

wire busy;
wire signed [7:0] y;

always#10 clk = ~clk;

func f(
    .x_bi(x),
    .clk_i(clk),
    .rst_i(rst),
    .start_i(start),
    .busy_o(busy),
    .y_bo(y)
);

reg signed [7:0] test_value [7:0], true_test_value [7:0];
reg signed [7:0] res;
reg [3:0] ctr = 0;

initial begin
    test_value[0] = -8'b0111_1111; // -0.992 => 0.548 (0100_0110)
    test_value[1] = -8'b0100_0000; // -1/2 => 0.878 (0111_0000)
    test_value[2] = -8'b0010_0000; // -1/4 => 0.969 (0111_1100)
    test_value[3] = -8'b0001_0001; // -0.117 => 0.991 (0111_1111)
    test_value[4] = -8'b0001_0000; // -1/8 * => 0.992 (0111_1111)
    test_value[5] = 8'b0001_0000; // 1/8 * => 0.992 (0111_1111)
    test_value[6] = 8'b0001_1010; // 1/5 => 0.98 (0111_1101)
    test_value[7] = 8'b0010_1011; // 1/3 => 0.946 (0111_1001)
    
    true_test_value[0] = 8'b0100_0110; 
    true_test_value[1] = 8'b0111_0000; 
    true_test_value[2] = 8'b0111_1100;  
    true_test_value[3] = 8'b0111_1111; 
    true_test_value[4] = 8'b0111_1111; 
    true_test_value[5] = 8'b0111_1111; 
    true_test_value[6] = 8'b0111_1101; 
    true_test_value[7] = 8'b0111_1001; 
end 


always@ (posedge clk) begin
    case(ctr)
        4'd0: begin
            rst = 0;
            ctr = ctr + 1;
              end
        4'd1:
            rst = 1;
    endcase
    if (!busy) begin
        case(ctr)
            4'd2:   begin
                x = test_value[0];
                start = 1;
                    end
            4'd3:   begin
                x = test_value[1];
                start = 1;
                    end
            4'd4:   begin
                x = test_value[2];
                start = 1;
                    end
            4'd5:   begin
                x = test_value[3];
                start = 1;
                    end
            4'd6:   begin
                x = test_value[4];
                start = 1;
                    end
            4'd7:   begin
                x = test_value[5];
                start = 1;
                    end
            4'd8:   begin
                x = test_value[6];
                start = 1;
                    end
            4'd9:   begin
                x = test_value[7];
                start = 1;
                    end
            4'd11: $stop;
        endcase
        if(ctr > 2) begin
            res = y;
            if(res == true_test_value[ctr-3]) begin
                $display("---SUCCESS---\n\tx = %b\n\ty = %b",test_value[ctr-3], res);
            end else begin
                $display("---FALL---\n\tx = %b\n\ty = %b\n\ttrue_y = %b",test_value[ctr-3], res, true_test_value[ctr-3]);
            end
        end
        ctr = ctr + 1;
    end else begin
        start = 0;
    end
end

endmodule


