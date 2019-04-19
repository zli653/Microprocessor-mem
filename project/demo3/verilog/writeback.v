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
	
	wire [15:0] CondExt;
	wire [15:0] int_a, int_b;
	
	// Zero	extend Cond
	assign CondExt = {{15{1'b0}}, Cond};

	// Determine if saving pc
	assign int_a = (PCtoReg == 1'b1) ? PCInc : MemOut;

	// Determine if saving memory output
	assign int_b = (MemtoReg == 1'b1) ? int_a : Data;

	// Check if condition is used
	assign wb = (Set == 1'b1) ? CondExt : int_b;
endmodule
