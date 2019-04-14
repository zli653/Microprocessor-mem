module cmper (A, B, c_bsel, cond);
	parameter    N = 16;
	input [N-1:0] A;
	input [N-1:0] B;
	input [2:0] c_bsel;
	output cond;
	reg cond;

	input [N-1:0] A;
	input [N-1:0] B;
	wire cin, cout, Ofl, Zero, Neg;
	wire cond_lt, cond_ge, cond_le, nv_diff;
	wire [N-1:0] B_in, cmper_out;

	// do subtraction
	// C set to 1 when generates a carry out
	assign B_in = (c_bsel == 7) ? B : ((c_bsel[2] == 0) ? 16'b0 : ~B);
	assign cin = (c_bsel == 7) ? 1'b0 : ((c_bsel[2] == 0) ? 1'b0 : 1'b1);
	rca_16b cmp(.A(A), .B(B_in), .C_in(cin),.S(cmper_out), .C_out(cout));

	// Z set to 1 when result is exactly zero
	assign Zero = ~|cmper_out;

	// N set to 1 when result is negative
	assign Neg =  cmper_out[N-1];

	// V set to 1 when overflow occurs
	assign Ofl = (A[N-1] & B_in[N-1] & ~cmper_out[N-1]) | (~A[N-1] & ~B_in[N-1] & cmper_out[N-1]);

	// signed comparsion
	assign nv_diff = Ofl ^ Neg;
	// assign cond_gt = ~nv_diff | ~Zero;
	assign cond_lt = nv_diff;
	assign cond_ge = ~nv_diff;
	assign cond_le = nv_diff | Zero;

	// BNEZ(01100): rs != 0
	// BEQZ(01101): rs == 0
	// BLTZ(01110): rs < 0
	// BGEZ(01111): rs >= 0
	// (|A)
	// (~|A)
	// A[15]
	// ~A[15]

	always @ (*)
	begin
		case (c_bsel)
			3'd0 : cond = ~Zero;	
			3'd1 : cond = Zero;	
			3'd2 : cond = cond_lt;	
			3'd3 : cond = cond_ge;	
			3'd4 : cond = Zero;	
			3'd5 : cond = cond_lt;	
			3'd6 : cond = cond_le;	
			3'd7 : cond = cout;	
			default : cond = 1'd0;
		endcase		
	end	
endmodule
