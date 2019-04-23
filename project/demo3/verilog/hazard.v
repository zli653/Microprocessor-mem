module hazard(
	//Inputs
	rst, clk
	, DecInstruct
	, ExInstruct, ExRegWrite, ExRegDst 
	, MemInstruct, MemRegWrite, MemRegDst
	, WbInstruct, WbRegWrite, WbRegDst	
	, ALUSrc2, DMemWrite, PCImm, Lbi, Set
	//Outputs
	, En
	);
	
	input rst, clk, ExRegWrite, MemRegWrite, WbRegWrite;
	input ALUSrc2, DMemWrite, PCImm, Lbi, Set;
	input [15:0] ExInstruct, MemInstruct, WbInstruct, DecInstruct;
	input [1:0] ExRegDst, MemRegDst, WbRegDst;

	wire stallWb, stallMem, stallEx;

	output En;
	

	regwrite MemRegWrite_stallunit(.RegDst(MemRegDst), .instruct(MemInstruct), .decInstruct(DecInstruct), .stall(stallMem),
	       	.RegWrite(MemRegWrite), .ALUSrc2(ALUSrc2), .DMemWrite(DMemWrite), .PCImm(PCImm), .Lbi(Lbi), .Set(Set));

	regwrite ExRegWrite_stallunit(.RegDst(ExRegDst), .instruct(ExInstruct), .decInstruct(DecInstruct), .stall(stallEx),
	       	.RegWrite(ExRegWrite), .ALUSrc2(ALUSrc2), .DMemWrite(DMemWrite), .PCImm(PCImm), .Lbi(Lbi), .Set(Set));

	assign En = ~( stallMem | stallEx);

endmodule
