`timescale 1ns / 1ps

module mux_21( 
	input a, 
	input x1, 
	input x2, 
	output ans
	);

wire n_x1, n_x2, n_a, a_x1, a_x2, y;

nor(n_x1, x1, x1);
nor(n_x2, x2, x2);
nor(n_a, a, a);

nor(a_x1, a, n_x1);
nor(a_x2, n_a, n_x2);

nor(y, a_x1, a_x2);
nor(ans, y, y); // n_y

endmodule