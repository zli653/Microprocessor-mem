module decode(
	//Inputs
	rst, clk, instruct, wb, RegWrite_todec, RegDst_todec, WriteInstruct, PCInc,
	fwd_A, fwd_B, data_memwb, data_exmem,	
	//Outputs
	EffReadData1, ReadData2, Imm, err, DMemWrite, DMemEn, ALUSrc2, PCSrc, MemtoReg, DMemDump, Jump, PCImm, PCtoReg, InvA, InvB, Sign, Cin, Op, Set, Halt, Cond, Btr, RegDstout, RegWriteout, Lbi, Branch_PC, Slbi
	, BrSel
	);

	input rst;
	input clk;
	input RegWrite_todec;
	input [1:0] RegDst_todec;
	input [15:0] instruct;
	input [15:0] wb;
	input [15:0] WriteInstruct;
	input [15:0] PCInc;
	input [15:0] data_memwb, data_exmem;
	input [1:0] fwd_A, fwd_B;
	
	output [15:0] ReadData2;
	output [15:0] EffReadData1;
	output [15:0] Imm;
	output err;
	output DMemWrite;
	output DMemEn;
	output ALUSrc2;
	output PCSrc;
	output MemtoReg;
	output DMemDump;
	output Jump;
	output PCImm;
	output PCtoReg;
	output InvA;
	output InvB;
	output Sign;
	output Cin;
	output [2:0] Op;
	output Set;
	output Halt;
	output Cond;
	output [1:0] RegDstout;
	output RegWriteout;
	output Btr;
	output Lbi;
	output [15:0] Branch_PC;
	output Slbi;
	output [2:0] BrSel;

	wire err_0,err_1,err_2;
	wire [15:0] int_jump;
	wire dc;
	wire RegWrite;
	wire [2:0] SESel;
	wire [1:0] RegDst;
	wire [15:0] ReadData1;
	wire [2:0] WriteRegSel;

	assign RegDstout = RegDst; 
	assign RegWriteout = RegWrite;

	// Control logic
	control controlMod(.err(err_0), .Btr(Btr), .PCtoReg(PCtoReg), .RegDst(RegDst), .SESel(SESel), .RegWrite(RegWrite), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .ALUSrc2(ALUSrc2), .PCSrc(PCSrc), 
		.MemtoReg(MemtoReg), .DMemDump(DMemDump), .Jump(Jump), .PCImm(PCImm), .Slbi(Slbi), .invA(InvA), .invB(InvB), .Sign(Sign), .Cin(Cin), .Op(Op), 
		.BrSel(BrSel), .Set(Set), .Halt(Halt), .Lbi(Lbi), .OpCode(instruct[15:11]), .Funct(instruct[1:0]));
	
	// Condition logic
	wire [15:0] int_A, int_B;
	assign int_A = fwd_A[1] ? data_exmem : fwd_A[0] ? data_memwb : ReadData1;
	assign int_B = fwd_B[1] ? data_exmem : fwd_B[0] ? data_memwb : ReadData2;
	cmper condition(.A(int_A), .B(int_B), .c_bsel(BrSel), .cond(Cond));

	// Output is PCImm, uses SESel internally
	immext ext(.instruct(instruct), .SESel(SESel), .err(err_1), .Imm(Imm));
	
	// Select write register
	assign WriteRegSel = (RegDst_todec == 2'd0) ? WriteInstruct[4:2] :
		(RegDst_todec == 2'd1) ? WriteInstruct[7:5] :
		(RegDst_todec == 2'd2) ? WriteInstruct[10:8] :
		(RegDst_todec == 2'd3) ? 3'b111 :
		3'b000;
	
	assign int_jump = Jump ?  EffReadData1 : PCInc;
	
	// Adds immediate to incremented PC
	// Dont care about carry out
	rca_16b PC_Imm (.A(Imm), .B(int_jump), .C_in(1'b0), .S(Branch_PC), .C_out(dc));

	// Register file logic (WriteEn is control signal)
	// internally
	rf_bypass RegFile(.readData1(ReadData1), .readData2(ReadData2), .err(err_2), .clk(clk), .rst(rst), 
		.readReg1Sel(instruct[10:8]), .readReg2Sel(instruct[7:5]), .writeRegSel(WriteRegSel), 
		.writeData(wb), .writeEn(RegWrite_todec));
	
	// Determine effective ReadData1 (Shift left 8 bits and fill with 0)
	assign EffReadData1 = int_A;

	// Assign error if needed (Assume any undefined input is an error)
	assign err = (err_0 | err_1 | err_2);
endmodule
