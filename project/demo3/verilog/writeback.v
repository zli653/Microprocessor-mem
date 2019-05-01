module writeback(
	//Ouputs
        wb, 
        //Inputs
        clk, rst, PCInc, MemOut, Data, Cond, PCtoReg, MemtoReg, Set
        );

	input clk;
	input rst;
	input [15:0] PCInc;
	input [15:0] MemOut;
	input [15:0] Data;
	input Cond;
	input PCtoReg;
	input MemtoReg;
	input Set;

	output [15:0] wb;
	
	assign wb = (MemtoReg == 1'b1) ? MemOut : Data;

endmodule
