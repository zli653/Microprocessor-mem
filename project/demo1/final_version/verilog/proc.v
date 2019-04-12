/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
	// Outputs
	err, 
	// Inputs
	clk, rst
	);

	input clk;
	input rst;

	output err;

	// None of the above lines can be modified

	// OR all the err ouputs for every sub-module and assign it as this
	// err output

	// As desribed in the homeworks, use the err signal to trap corner
	// cases that you think are illegal in your statemachines

	// Added signals
	// Fetch
	wire err_0, err_1, err_2;
	wire PCSrc;
	wire Halt;
	wire PCImm;
	wire Jump;
	wire Cond;
	wire [15:0] Branch_PC;
	wire [15:0] PCInc;
	wire [15:0] Instr;

	// Decode
	wire [15:0] wb;
	wire [15:0] EffReadData1;
	wire [15:0] ReadData2;
	wire [15:0] Imm;
	wire DMemWrite;
	wire DMemEn;
	wire ALUSrc2;
	wire MemToReg;
	wire DMemDump;
	wire PCToReg;
	wire InvA;
	wire InvB;
	wire Sign;
	wire Cin;
	wire [2:0] Op;
	wire Set;
	wire Btr;

	// Execute
	wire [15:0] ALUOut;
	wire Zero;
	wire Ofl;

	// Memory
	wire [15:0] MemOut;

	// Instantiate the fetch stage
	fetch FetchStage(.err(err_0), .PCInc(PCInc), .Instr(Instr), .clk(clk), .rst(rst), .PCSrc(PCSrc), .Halt(Halt), .Branch_PC(Branch_PC), .Cond(Cond), .PCImm(PCImm), .Jump(Jump));

	// Instantiate the decode stage
	decode DecodeStage(.rst(rst), .clk(clk), .instruct(Instr), .wb(wb), .ReadData2(ReadData2), .EffReadData1(EffReadData1), .Imm(Imm), .err(err_1), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .Btr(Btr),
	       .ALUSrc2(ALUSrc2), .PCSrc(PCSrc), .MemToReg(MemToReg), .DMemDump(DMemDump), .Jump(Jump), .PCImm(PCImm), .PCToReg(PCToReg), .InvA(InvA), .InvB(InvB), .Sign(Sign), .Cin(Cin), .Op(Op),
	       .Set(Set), .Halt(Halt), .Cond(Cond));


	// Instantiate the execute stage
	execute ExecuteStage(.err(err_2), .Branch_PC(Branch_PC), .ALUOut(ALUOut), .Zero(Zero), .Ofl(Ofl), .clk(clk), .rst(rst), .PCImm(PCImm), .invA(InvA), .invB(InvB), .Sign(Sign), .Cin(Cin), .Btr(Btr), 
		.OpCode(Op), .ALUSrc2(ALUSrc2), .ReadDataA(EffReadData1), .ReadDataB(ReadData2), .PCInc(PCInc), .Imm(Imm), .Jump(Jump));

	// Instantiate the memory stage
	memory MemoryStage(.MemOut(MemOut), .ReadData2(ReadData2), .ALUOut(ALUOut), .C_DMemEn(DMemEn), .C_DMemWrite(DMemWrite), .C_DMemDump(DMemDump), .clk(clk), .rst(rst));

	// Instantiate the writeback stage
	writeback WritebackStage(.wb(wb), .clk(clk), .rst(rst), .PCInc(PCInc), .MemOut(MemOut), .Data(ALUOut), .Cond(Cond), .PCToReg(PCToReg), .MemToReg(MemToReg), .Set(Set));
	
	assign err = (err_0 | err_1 | err_2);

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
