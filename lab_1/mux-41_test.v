`timescale 1ns / 1ps

module mux_41_td;

	reg a1_in, a2_in, x1_in, x2_in, x3_in, x4_in;
	wire y_out;

	mux_41 m_mux(
		.a1(a1_in),
		.a2(a2_in),
		.x1(x1_in),
		.x2(x2_in),
		.x3(x3_in),
		.x4(x4_in),
		.ans(y_out)
		);

	integer i, n;
	reg [5:0] test_val; 
	reg [3:0] all_x; 
	reg expect;

	initial begin
		for (i = 0; i < 64; i = i + 1) begin
			test_val = i;
			a1_in = test_val[0];
			a2_in = test_val[1];
			
			all_x[0] = test_val[2];
			x1_in = test_val[2];
			
			all_x[1] = test_val[3]; 
			x2_in = test_val[3];
			
			all_x[2] = test_val[4];
			x3_in = test_val[4];
			
			all_x[3] = test_val[5];
			x4_in = test_val[5];
			
			n = test_val[1:0];
			
			expect = all_x[n];
			
			#10 
			
			if (y_out == expect) begin
				$display("GOOD: /t a1 = %b, a2 = %b, x1 = %b, x2 = %b, x3 = %b, x4 = %b, ans = %b", 
						a1_in, a2_in, x1_in, x2_in, x3_in, x4_in, expect);
			end else begin
				$display("NOT GOOD: /t a1 = %b, a2 = %b, x1 = %b, x2 = %b, x3 = %b, x4 = %b, exp = %b, out = %b",
							a1_in, a2_in, x1_in, x2_in, x3_in, x4_in, expect, ans);
			end 
		end
		#10 $stop;
	end

endmodule