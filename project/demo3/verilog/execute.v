module execute (
	//Ouputs
	err, ALUOut, Zero, Ofl, Btr, ReadData2,
	//Inputs
	clk, rst, invA, invB, Sign, Cin, OpCode, ALUSrc2, ReadDataA, ReadDataB, Imm, fwd_A, fwd_B, data_exmem, data_memwb,
	PCtoReg, Cond, Set, PCInc, Lbi, Slbi, BrSel, St	
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
	input [15:0] Imm, data_exmem, data_memwb;
	input [1:0] fwd_A, fwd_B;
	input PCtoReg, Set, Cond;
	input [15:0] PCInc;
	input Lbi, Slbi;
	input [2:0] BrSel;
	input St;

	output err;
	output [15:0] ALUOut;
	output Zero;
	output Ofl;
	output [15:0] ReadData2;

	wire [15:0] int_B, int_rev, int_alu, int_B_int, int_A;
	wire [15:0] ALUOut_1, ALUOut_2;

	wire [15:0] int_lbi, EffReadDataA, int_shifted;
	// Selects Reg 2 Read if ALUSrc2 == 1, else selects imm
	assign int_B_int = (ALUSrc2 == 1'b1) ? ReadDataB : Imm;

	alu exAlu(.A(EffReadDataA), .B(int_B), .Cin(Cin), .Op(OpCode), .invA(invA), .invB(invB), .sign(Sign), .Out(int_alu), 
		.Zero(Zero), .Ofl(Ofl));

	reverse rev(.In(int_A), .Out(int_rev));
	
	// Determine effective ReadData1 (Shift left 8 bits and fill with 0)
	left_shift shifter(.In(int_A), .Cnt(4'd8), .Fill(1'b0), .Out(int_shifted));	
	assign int_lbi = Lbi ? 16'd0 : int_A;
	assign EffReadDataA = (Slbi == 1'b1) ? int_shifted : int_lbi;

	// Condition logic
	wire [15:0] int_B_cmp;
	wire Eff_Cond;
	assign int_B_cmp = fwd_B[1] ? data_exmem : fwd_B[0] ? data_memwb : ReadDataB;
	cmper condition(.A(int_A), .B(int_B_cmp), .c_bsel(BrSel), .cond(Eff_Cond));	


	assign ALUOut_1 = Btr ? int_rev : int_alu;
	assign ALUOut_2 = PCtoReg ? PCInc : ALUOut_1;
	assign ALUOut = Set ? {15'd0, Eff_Cond} : ALUOut_2;
	assign int_A = fwd_A[1] ? data_exmem : fwd_A[0] ? data_memwb : ReadDataA;
	assign int_B = (~St & fwd_B[1]) ? data_exmem : (~St & fwd_B[0]) ? data_memwb : int_B_int;
	assign ReadData2 = int_B_cmp;
	// assign ReadData2 = int_B;

assign err = 0;
endmodule
