
module decode(
	//Inputs
	rst, clk, instruct, wb, 

	//Outputs
	EffReadData1, ReadData2, Imm, err, DMemWrite, DMemEn, ALUSrc2, PCSrc, MemToReg, DMemDump, Jump, PCImm, PCToReg, InvA, InvB, Sign, Cin, Op, Set, Halt, Cond, Btr
	);

	input rst;
	input clk;
	input [15:0] instruct;
	input [15:0] wb;
	
	output [15:0] ReadData2;
	output [15:0] EffReadData1;
	output [15:0] Imm;
	output err;
	output DMemWrite;
	output DMemEn;
	output ALUSrc2;
	output PCSrc;
	output MemToReg;
	output DMemDump;
	output Jump;
	output PCImm;
	output PCToReg;
	output InvA;
	output InvB;
	output Sign;
	output Cin;
	output [2:0] Op;
	output Set;
	output Halt;
	output Cond;

	wire err_0,err_1,err_2;
	wire RegWrite;
	wire [2:0] BrSel;
	wire [2:0] WriteRegSel;
	wire [2:0] SESel;
	wire [1:0] RegDst;
	wire [15:0] ReadData1;
//	wire [15:0] Read2Shift8;
	wire [15:0] int_shifted,int_lbi;
	wire Slbi;
	wire Lbi;
//	wire [15:0] CompA,CompB;
	output Btr;

	// Control logic
	control controlMod(.err(err_0), .Btr(Btr), .PCToReg(PCToReg), .RegDst(RegDst), .SESel(SESel), .RegWrite(RegWrite), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .ALUSrc2(ALUSrc2), .PCSrc(PCSrc), 
		.MemToReg(MemToReg), .DMemDump(DMemDump), .Jump(Jump), .PCImm(PCImm), .Slbi(Slbi), .invA(InvA), .invB(InvB), .Sign(Sign), .Cin(Cin), .Op(Op), 
		.BrSel(BrSel), .Set(Set), .Halt(Halt), .Lbi(Lbi), .OpCode(instruct[15:11]), .Funct(instruct[1:0]));
	
	// Condition logic
	cmper condition(.A(ReadData1), .B(ReadData2), .c_bsel(BrSel), .cond(Cond));	

	// Output is PCImm, uses SESel internally
	ImmExt ext(.instruct(instruct), .SESel(SESel), .err(err_1), .Imm(Imm));
	
	// Select write register
	assign WriteRegSel = (RegDst == 2'd0) ? instruct[4:2] :
		(RegDst == 2'd1) ? instruct[7:5] :
		(RegDst == 2'd2) ? instruct[10:8] :
		(RegDst == 2'd3) ? 3'b111 :
		3'b000;

	// Register file logic (WriteEn is control signal)
	// internally
	rf RegFile(.readData1(ReadData1), .readData2(ReadData2), .err(err_2), .clk(clk), .rst(rst), 
		.readReg1Sel(instruct[10:8]), .readReg2Sel(instruct[7:5]), .writeRegSel(WriteRegSel), 
		.writeData(wb), .writeEn(RegWrite));
	
	// Determine effective ReadData1 (Shift left 8 bits and fill with 0)
	left_shift shifter(.In(ReadData1), .Cnt(4'd8), .Fill(1'b0), .Out(int_shifted));	
	assign int_lbi = Lbi ? 16'd0 : ReadData1;
	assign EffReadData1 = (Slbi == 1'b1) ? int_shifted : int_lbi;

	// Assign error if needed (Assume any undefined input is an error)
	assign err = (err_0 | err_1 | err_2);
endmodule
