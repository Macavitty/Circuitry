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

reg [7:0] test_value [7:0];
reg signed [7:0] true_res, res;
reg [3:0] ctr = 0;

initial begin
    test_value[0] = 8'b0000_0000;
    test_value[1] = 8'b0100_0000;
    test_value[2] = 8'b0000_0000;
    test_value[3] = 8'b0000_0000;
    test_value[4] = 8'b0000_0000;
    test_value[5] = 8'b0000_0000;
    test_value[6] = 8'b0000_0000;
    test_value[7] = 8'b1111_1111;

end 

//assign true_res = 1 - (x*x)/2 + (x*x*x*x)/24;

always@ (posedge clk) begin
    case(ctr)
        4'd0:
            rst = 1;
        4'd1:
            rst = 0;
    endcase
    if (!busy) begin
        case(ctr)
            4'd2:   begin
                x <= test_value[0];
                start <= 1;
                    end
            4'd3:   begin
                x <= test_value[1];
                start <= 1;
                    end
            4'd4:   begin
                x <= test_value[2];
                start <= 1;
                    end
            4'd5:   begin
                x <= test_value[3];
                start <= 1;
                    end
            4'd6:   begin
                x <= test_value[4];
                start <= 1;
                    end
            4'd7:   begin
                x <= test_value[5];
                start <= 1;
                    end
            4'd8:   begin
                x <= test_value[6];
                start <= 1;
                    end
            4'd9:   begin
                x <= test_value[7];
                start <= 1;
                    end
            4'd11: $stop;
        endcase
        if(ctr > 2) begin
            res = y;
            true_res = 1 - (test_value[ctr-3]*test_value[ctr-3])/2 + (test_value[ctr-3]*test_value[ctr-3]*test_value[ctr-3]*test_value[ctr-3])/24;
            if(res == true_res) begin
                $display("---SUCCESS---\n\tx=0.%b\n\ty=0.%b",test_value[ctr-3], res);
            end else begin
                $display("---FALL---\n\tx=0.%b\n\ty=0.%b\n\ttrue_y=0.%b",test_value[ctr-3], res, true_res);
            end
        end
        ctr = ctr + 1;
    end else begin
        start = 0;
    end
end

endmodule


