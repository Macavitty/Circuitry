`timescale 1ns / 1ps

module mux_41(
	input a1,
	input a2,
	input x1,
	input x2,
	input x3,
	input x4,
	output ans
	);

wire out_x12, out_x34;

mux_21 x12_mux( //for x1 and x2
	.a(a1),
	.x1(x1),
	.x2(x2),
	.ans(out_x12)
	);

mux_21 x34_mux( //for x3 and x4
	.a(a1),
	.x1(x3),
	.x2(x4),
	.ans(out_x34)
	);

mux_21 last_mux( 
	.a(a2),
	.x1(out_x12),
	.x2(out_x34),
	.ans(ans)
	);

endmodule