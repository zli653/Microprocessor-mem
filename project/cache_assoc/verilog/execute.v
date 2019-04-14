module execute (
	//Ouputs
	err, ALUOut, Zero, Ofl, Btr,
	//Inputs
	clk, rst, invA, invB, Sign, Cin, OpCode, ALUSrc2, ReadDataA, ReadDataB, Imm
	);

	input clk;
	input rst;
	input invA;
	input invB;
	input Sign;
	input Cin;
	input Btr;
	input [2:0] OpCode;
	input ALUSrc2;
	input [15:0] ReadDataA;
	input [15:0] ReadDataB;
	input [15:0] Imm;

	output err;
	output [15:0] ALUOut;
	output Zero;
	output Ofl;

	wire [15:0] int_B, int_rev, int_alu;

	// Selects Reg 2 Read if ALUSrc2 == 1, else selects imm
	assign int_B = (ALUSrc2 == 1'b1) ? ReadDataB : Imm;

	alu exAlu(.A(ReadDataA), .B(int_B), .Cin(Cin), .Op(OpCode), .invA(invA), .invB(invB), .sign(Sign), .Out(int_alu), 
		.Zero(Zero), .Ofl(Ofl));

	reverse rev(.In(ReadDataA), .Out(int_rev));

	assign ALUOut = Btr ? int_rev : int_alu;
	
	assign err = 0;
endmodule
