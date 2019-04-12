module dff_wrapper (q, d, en, clk, rst);

	output         q;
	input          d;
	input          clk;
	input          rst;
	input	       en;

	wire din;

	assign din = (en) ? d : q;

	dff d1 (.q(q),.d(din),.clk(clk),.rst(rst));

endmodule
// DUMMY LINE FOR REV CONTROL :0:
