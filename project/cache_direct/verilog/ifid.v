module ifid (
	// Inputs
	PCInc, Instr, clk, rst, en, nop,

	// Outputs
	PCIncOut, DecInstrOut
	);

	input [15:0] PCInc;
	input [15:0] Instr;
	input clk, rst, en, nop;

	output [15:0] PCIncOut;
	output [15:0] DecInstrOut;
	wire nop_toid;

	wire rst_prev;
	wire [15:0] InstrInt;
	//wire [15:0] PCIncInt;

	// Store PCInc
	reg_16b_wrapper rpc (.clk(clk),.rst(rst),.writeData(PCInc),.readData(PCIncOut),.en(en));
	
	// Store Instr
	reg_16b_wrapper rins (.clk(clk),.rst(rst),.writeData(Instr),.readData(InstrInt),.en(en));

	dff_wrapper rst_old (.clk(clk), .rst(rst), .d(1'b1), .q(rst_prev),.en(en));
	dff_wrapper nop_hold (.clk(clk), .rst(rst), .d(nop), .q(nop_toid),.en(en));
	
	assign DecInstrOut = (nop_toid | ~rst_prev) ? 16'b0000100000000000 : InstrInt;
	//assign DecInstrOut = rst_prev ? InstrInt : 16'b0000100000000000; 
	//assign DecInstrOut = rst_prev ? Instr : Instr; 
	//assign PCIncOut = PCInc; 

endmodule
