module ImmExt (
	// Inputs
	instruct, SESel,

	// Outputs
	err, Imm
	);

	input [15:0] instruct;
	input [2:0] SESel;

	output err;
	output [15:0] Imm;

	wire [15:0] sign_11, sign_8, sign_5, zero_8, zero_5;

	// Fill top 5 bits with the sign bit of instruct[10:0]
	assign sign_11 = {{5{instruct[10]}},instruct[10:0]};
	assign sign_8 = {{8{instruct[7]}},instruct[7:0]};
	assign sign_5 = {{11{instruct[4]}},instruct[4:0]};
	assign zero_8 = {{8{1'b0}},instruct[7:0]};
	assign zero_5 = {{11{1'b0}},instruct[4:0]};

	assign Imm = (SESel == 3'd0) ? zero_5 :
		(SESel == 3'd1) ? zero_8 :
		(SESel[2:1] == 2'd1) ? sign_5 :
		(SESel[2:1] == 2'd2) ? sign_8 :
		(SESel[2:1] == 2'd3) ? sign_11 :
		16'd0;

	assign err = 0;
endmodule
