module regwrite(
	//output
	stall,
	//input
	RegDst, instruct, decInstruct, RegWrite, ALUSrc2, DMemWrite, PCImm, Lbi, Set
	);

	input [15:0] instruct, decInstruct;
	input [1:0] RegDst;
	input RegWrite, ALUSrc2, DMemWrite, PCImm, Lbi, Set;
	
	wire [2:0] WriteRegSel;
	wire rtUsed, rtstall, rsUsed, rsstall;

	output stall;

	assign WriteRegSel = (RegDst == 2'd0) ? instruct[4:2] :
		(RegDst == 2'd1) ? instruct[7:5] :
		(RegDst == 2'd2) ? instruct[10:8] :
		(RegDst == 2'd3) ? 3'b111 :
		3'b000;

	
	//assign rtUsed = (AluSrc2 | Set | (instr[15:11] == 5'b10000) | (instr[15:11] == 5'b10011) ) ? 1'b1 : 1'b0; //store check is instr
	assign rtUsed = (ALUSrc2 | Set | DMemWrite) ? 1'b1 : 1'b0; //store check is instr

	//DMemWrite signal added to this because Rd is in the same position as
	//rt for those instructions'

	assign rtstall = rtUsed & RegWrite & (WriteRegSel == decInstruct[7:5]);
	
	assign rsUsed = ~(Lbi | PCImm | (decInstruct[15:12] == 4'b0000));

	assign rsstall = rsUsed & RegWrite & (WriteRegSel == decInstruct[10:8]) ;
	
	assign stall =  rsstall | rtstall;
	

endmodule
	 
	// Detect Ex Hazard
//	if (ExRegWrite == 1 && (ExWriteReg == DecInstruct[10:8] || ExWriteReg == DecInstruct[4:2]): // Hazard detected
		
	// Detect Mem Hazard
//	if (MemRegWrite == 1 && (MemWriteReg == DecInstruct[10:8] || MemWriteReg == DecInstruct[4:2]): // Hazard detected

	// Detect Wb Hazard
//	if (WbRegWrite == 1 && (WbWriteReg == DecInstruct[10:8] || WbWriteReg == DecInstruct[4:2]): // Hazard detected
