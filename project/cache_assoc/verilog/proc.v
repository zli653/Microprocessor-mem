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
	wire err_fetch, err_decode, err_execute, err_mem;
	wire PCSrc;
	wire Halt;
	wire Jump;
	wire Cond;
	wire [15:0] Branch_PC;
	wire [15:0] PCInc;
	wire [15:0] Instr;
	wire PCImm;

	//Ifid
	wire [15:0] PCIncOut;

	// Decode
	wire [15:0] wb;
	wire [15:0] EffReadData1;
	wire [15:0] ReadData2;
	wire [15:0] Imm;
	wire DMemWrite;
	wire DMemEn;
	wire ALUSrc2;
	wire MemtoReg;
	wire DMemDump;
	wire PCtoReg;
	wire InvA;
	wire InvB;
	wire Sign;
	wire Cin;
	wire [2:0] Op;
	wire Set;
	wire Btr;

	//Idex
	wire [15:0] ReadData2_toex, EffReadData1_toex, Imm_toex, PCInc_toex;
        wire [2:0] Op_toex;
        wire  InvA_toex, InvB_toex, Sign_toex, Cin_toex,
        ALUSrc2_toex, Btr_toex, DMemWrite_toex, DMemEn_toex,
        DMemDump_toex, PCtoReg_toex, MemtoReg_toex, Cond_toex, Set_toex;

	// Execute
	wire [15:0] ALUOut;
	wire Zero;
	wire Ofl;

	//Ex to mem
	wire [15:0]  PCInc_tomem, ALUOut_tomem, ReadData2_tomem;
        wire DMemWrite_tomem, DMemEn_tomem, DMemDump_tomem, PCtoReg_tomem,
               MemtoReg_tomem, Cond_tomem, Set_tomem;

	// Memory
	wire [15:0] MemOut;
	wire Dmem_Stall;

	// Mem to Wb
	wire PCtoReg_towb, MemtoReg_towb, Cond_towb, Set_towb;
	wire [15:0] PCInc_towb, MemOut_towb, ALUOut_towb;


	//pipeline wires
	wire DecRegWriteout;
	wire [1:0] DecRegDstout;
	wire [15:0] DecInstrOut;

	wire RegWrite_toex, Halt_toex;
	wire [1:0] RegDst_toex;
	wire [15:0] ExInstr;

	wire RegWrite_tomem, Halt_tomem;
	wire [1:0] RegDst_tomem;
	wire [15:0] MemInstr;

	wire RegWrite_todec, Halt_tof;
	wire [1:0] RegDst_todec;
	wire [15:0] WbInstr;
	wire En;
	wire Lbi, nop;

	// Instantiate the fetch stage
	fetch FetchStage(.err(err_fetch), .PCInc(PCInc), .Instr(Instr), .clk(clk), .rst(rst), .PCSrc(PCSrc), .Halt(Halt_tof), .Branch_PC(Branch_PC), .Cond(Cond), .PCImm(PCImm), .Jump(Jump), .En(En), .nop(nop), .Dmem_Stall(Dmem_Stall));

	//Instantiate Fetch to Decode Pipeline 
	ifid fetchToDec(.PCInc(PCInc), .Instr(Instr), .clk(clk), .rst(rst), .en(En&~Dmem_Stall), .PCIncOut(PCIncOut), .DecInstrOut(DecInstrOut), .nop(nop));

	// Instantiate the decode stage
	decode DecodeStage(.rst(rst), .clk(clk), .instruct(DecInstrOut), .wb(wb), .ReadData2(ReadData2), .EffReadData1(EffReadData1), .Imm(Imm), .err(err_decode), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .Btr(Btr),
	       .ALUSrc2(ALUSrc2), .PCSrc(PCSrc), .MemtoReg(MemtoReg), .DMemDump(DMemDump), .Jump(Jump), .PCImm(PCImm), .PCtoReg(PCtoReg), .InvA(InvA), .InvB(InvB), .Sign(Sign), .Cin(Cin), .Op(Op), .PCInc(PCIncOut),
	       .Set(Set), .Halt(Halt), .Cond(Cond), .RegDstout(DecRegDstout), .RegWriteout(DecRegWriteout), .RegWrite_todec(RegWrite_todec)
       		, .RegDst_todec(RegDst_todec), .Lbi(Lbi), .WriteInstruct(WbInstr), .Branch_PC(Branch_PC));


	 // Hazard detection unit
        hazard HazardUnit(.rst(rst), .clk(clk),
                //Inputs
                .DecInstruct(DecInstrOut), .ExInstruct(ExInstr), .ExRegWrite(RegWrite_toex), .ExRegDst(RegDst_toex)
                , .MemInstruct(MemInstr), .MemRegWrite(RegWrite_tomem), .MemRegDst(RegDst_tomem)
                , .WbInstruct(WbInstr), .WbRegWrite(RegWrite_todec), .WbRegDst(RegDst_todec)
		, .ALUSrc2(ALUSrc2), .DMemWrite(DMemWrite), .PCImm(PCImm), .Lbi(Lbi), .Set(Set),        	

		//Outputs
                .En(En)
                );


	//Instantiate Decode To Execute Pipeline
	idex decToEx(
		.InvA_toex(InvA_toex), .InvB_toex(InvB_toex), .Sign_toex(Sign_toex), .Cin_toex(Cin_toex), .Op_toex(Op_toex), .PCInc_toex(PCInc_toex),
		.ALUSrc2_toex(ALUSrc2_toex), .Btr_toex(Btr_toex), .ReadData2_toex(ReadData2_toex), .EffReadData1_toex(EffReadData1_toex),
		.Imm_toex(Imm_toex), .DMemWrite_toex(DMemWrite_toex), .DMemEn_toex(DMemEn_toex), .DMemDump_toex(DMemDump_toex), .PCtoReg_toex(PCtoReg_toex),
		.MemtoReg_toex(MemtoReg_toex), .Cond_toex(Cond_toex), .Set_toex(Set_toex), .instructout(ExInstr), .RegWrite_toex(RegWrite_toex), .RegDst_toex(RegDst_toex), .Halt_toex(Halt_toex),
		//Inputs
		.InvA(InvA), .InvB(InvB), .Sign(Sign), .Cin(Cin), .Op(Op), .Halt(Halt), .PCInc(PCIncOut),
		.ALUSrc2(ALUSrc2), .Btr(Btr), .ReadData2(ReadData2), .EffReadData1(EffReadData1),
		.Imm(Imm), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .DMemDump(DMemDump), .PCtoReg(PCtoReg),
		.MemtoReg(MemtoReg), .Cond(Cond), .Set(Set), .clk(clk), .En(En), .en(~Dmem_Stall), .rst(rst), .instructin(DecInstrOut), .RegWrite(DecRegWriteout), .RegDst(DecRegDstout)
		);


	// Instantiate the execute stage
	execute ExecuteStage(.err(err_execute), .ALUOut(ALUOut), .Zero(Zero), .Ofl(Ofl), .clk(clk), .rst(rst), .invA(InvA_toex), .invB(InvB_toex), .Sign(Sign_toex), .Cin(Cin_toex), .Btr(Btr_toex), 
		.OpCode(Op_toex), .ALUSrc2(ALUSrc2_toex), .ReadDataA(EffReadData1_toex), .ReadDataB(ReadData2_toex), .Imm(Imm_toex));

	//Instantiate the Execute to Memory Pipeline
	exmem ExToMem(
	       	//Outputs
		.PCInc_tomem(PCInc_tomem), .ALUOut_tomem(ALUOut_tomem), .ReadData2_tomem(ReadData2_tomem), .DMemWrite_tomem(DMemWrite_tomem), .DMemEn_tomem(DMemEn_tomem),
		.DMemDump_tomem(DMemDump_tomem), .PCtoReg_tomem(PCtoReg_tomem), .MemtoReg_tomem(MemtoReg_tomem), .Cond_tomem(Cond_tomem), .Set_tomem(Set_tomem), .instructout(MemInstr), .RegWrite_tomem(RegWrite_tomem), .RegDst_tomem(RegDst_tomem), .Halt_tomem(Halt_tomem),
		//Inputs
		.PCInc(PCInc_toex), .ALUOut(ALUOut), .ReadData2(ReadData2_toex), .DMemWrite(DMemWrite_toex), .DMemEn(DMemEn_toex), .Halt(Halt_toex),
		.DMemDump(DMemDump_toex), .PCtoReg(PCtoReg_toex), .MemtoReg(MemtoReg_toex), .Cond(Cond_toex), .Set(Set_toex), .clk(clk), .en(~Dmem_Stall), .rst(rst), .instructin(ExInstr), .RegWrite(RegWrite_toex), .RegDst(RegDst_toex)
		);

	// Instantiate the memory stage
	memory MemoryStage(.MemOut(MemOut), .ReadData2(ReadData2_tomem), .ALUOut(ALUOut_tomem), .C_DMemEn(DMemEn_tomem & ~Halt_tof), .C_DMemWrite(DMemWrite_tomem), .C_DMemDump(DMemDump_tomem), .clk(clk), .rst(rst), .err(err_mem), .Dmem_Stall(Dmem_Stall));

	//Instantiate mem to writeback

	memwb MemToWb(.Dmem_Stall(Dmem_Stall), .PCInc_towb(PCInc_towb), .MemOut_towb(MemOut_towb), .PCtoReg_towb(PCtoReg_towb),
	       	.MemtoReg_towb(MemtoReg_towb), .Cond_towb(Cond_towb), .Set_towb(Set_towb), .ALUOut_towb(ALUOut_towb), .ALUOut(ALUOut_tomem),
		.PCInc(PCInc_tomem), .MemOut(MemOut), .PCtoReg(PCtoReg_tomem), .MemtoReg(MemtoReg_tomem), .Halt(Halt_tomem),
		.Cond(Cond_tomem), .Set(Set_tomem), .rst(rst), .clk(clk), .en(~Dmem_Stall), .instructin(MemInstr), .RegDst(RegDst_tomem), .RegWrite(RegWrite_tomem),
       		.instructout(WbInstr), .RegDst_todec(RegDst_todec), .RegWrite_todec(RegWrite_todec), .Halt_tof(Halt_tof));

	


	// Instantiate the writeback stage
	writeback WritebackStage(.wb(wb), .clk(clk), .rst(rst), .PCInc(PCInc_towb), .MemOut(MemOut_towb), .Data(ALUOut_towb), .Cond(Cond_towb), .PCtoReg(PCtoReg_towb), .MemtoReg(MemtoReg_towb), .Set(Set_towb));
	
	assign err = (err_fetch | err_decode | err_execute | err_mem);

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
