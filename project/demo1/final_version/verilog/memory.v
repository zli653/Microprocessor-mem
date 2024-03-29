module memory(MemOut, ReadData2, ALUOut, C_DMemEn, C_DMemWrite, C_DMemDump, clk, rst);
	input [15:0] ReadData2, ALUOut;
	input C_DMemEn, C_DMemWrite, C_DMemDump, clk, rst;
	output [15:0] MemOut;

	memory2c data_mem(.data_out(MemOut), .data_in(ReadData2), .addr(ALUOut), .enable(C_DMemEn), 
		.wr(C_DMemWrite), .createdump(C_DMemDump), .clk(clk), .rst(rst));
endmodule
