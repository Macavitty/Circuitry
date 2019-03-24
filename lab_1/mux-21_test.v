`timescale 1ns / 1ps

module mux_21_td;

	reg a_in, x1_in, x2_in;
	wire y_out;

	mux_21 m_mux(
		.a(a_in),
		.x1(x1_in),
		.x2(x2_in),
		.ans(y_out)
		);

	integer i;
	reg [2:0] foo; 
	reg [1:0] xx; 
	reg expect;

	initial begin
		for (i = 0; i < 8; i = i + 1) begin
			foo = i;
			a_in = foo[0];
			
			xx[0] = foo[1];
			x1_in = foo[1];
			
			xx[1] = foo[2]; 
			x2_in = foo[2];
			
			expect = xx[a_in];

			#10 

			if (y_out == expect) begin
				$display("***** GOOD: a = %b, x1 = %b, x2 = %b, ans = %b", a_in, x1_in, x2_in, expect);
			end else begin
				$display("----- NOT GOOD: a = %b, x1 = %b, x2 = %b, exp = %b, out = %b", a_in, x1_in, x2_in, expect, y_out);
			end 
		end
		#10 $stop;
	end

endmodule