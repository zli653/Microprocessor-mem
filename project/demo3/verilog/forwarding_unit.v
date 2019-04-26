module fwding_unit(
	//Outputs
	fwd_A, fwd_B, data_memwb, exex_stall,

	//input
	// idex
	ALUSrc2, Set, DMemWrite, Lbi, PCImm, instr,

	// exmem
	RegDst_exmem, instr_exmem, DMemEn_exmem, RegWrite_exmem,

	// memwb
	RegDst_memwb, instr_memwb, RegWrite_memwb,
	MemOut_memwb, ALUOut_memwb, MemtoReg_memwb	
	);

	// Inputs
	// idex
	input ALUSrc2, Set, DMemWrite, Lbi, PCImm;
        input [15:0] instr;
	// exmem
	input [1:0] RegDst_exmem; 
	input [15:0] instr_exmem;
       	input DMemEn_exmem, RegWrite_exmem;
	// memwb
	input [1:0] RegDst_memwb;
       	input [15:0] instr_memwb;
       	input RegWrite_memwb;
	input [15:0] MemOut_memwb, ALUOut_memwb;
        input MemtoReg_memwb;	
	
	// Outputs
	output [1:0] fwd_A, fwd_B;
	output [15:0] data_memwb;
	output exex_stall;
	// Wires
	wire rtUsed, rsUsed, fwd_exex_A, fwd_exex_B, fwd_memex_A, fwd_memex_B;
        wire [2:0] WriteRegSel_exmem, WriteRegSel_memwb;	
	wire fwd_exex_A_int, fwd_exex_B_int;
	wire nop;

	assign nop = (instr == 16'b0000100000000000);

	// idex	
	assign rtUsed = (ALUSrc2 | Set);
	assign rsUsed = ~(Lbi | PCImm | (instr[15:12] == 4'b0000));

	
	// exmem
	//assign rtUsed_exmem = (ALUSrc2_exmem | Set_exmem | DMemWrite_exmem);
	//assign rsUsed_exmem = ~(Lbi_exmem | PCImm_exmem | (instr_exmem[15:12] == 4'b0000));
	assign WriteRegSel_exmem = (RegDst_exmem == 2'd0) ? instr_exmem[4:2] :
		(RegDst_exmem == 2'd1) ? instr_exmem[7:5] :
		(RegDst_exmem == 2'd2) ? instr_exmem[10:8] :
		(RegDst_exmem == 2'd3) ? 3'b111 :
		3'b000;

	// memwb
	//assign rtUsed_memwb = (ALUSrc2_memwb | Set_memwb | DMemWrite_memwb);
	//assign rsUsed_memwb = ~(Lbi_memwb | PCImm_memwb | (instr_memwb[15:12] == 4'b0000));
	assign WriteRegSel_memwb = (RegDst_memwb == 2'd0) ? instr_memwb[4:2] :
		(RegDst_memwb == 2'd1) ? instr_memwb[7:5] :
		(RegDst_memwb == 2'd2) ? instr_memwb[10:8] :
		(RegDst_memwb == 2'd3) ? 3'b111 :
		3'b000;

	// Forward exex	
	assign fwd_exex_A_int = rsUsed & RegWrite_exmem & (WriteRegSel_exmem == instr[10:8]);
	assign fwd_exex_B_int = rtUsed & RegWrite_exmem & (WriteRegSel_exmem == instr[7:5]);
	assign fwd_exex_A = fwd_exex_A_int & ~DMemEn_exmem;
	assign fwd_exex_B = fwd_exex_B_int & ~DMemEn_exmem;
	assign exex_stall = (fwd_exex_A_int | fwd_exex_B_int) & DMemEn_exmem;

	// Forward memex	
	assign fwd_memex_A = rsUsed & RegWrite_memwb & (WriteRegSel_memwb == instr[10:8]);
	assign fwd_memex_B = rtUsed & RegWrite_memwb & (WriteRegSel_memwb == instr[7:5]);
	
	assign fwd_A = {fwd_exex_A, fwd_memex_A};
	assign fwd_B = {fwd_exex_B, fwd_memex_B};
	assign data_memwb = MemtoReg_memwb ? MemOut_memwb :  ALUOut_memwb;
endmodule
