module exmem(
	//Outputs
	PCInc_tomem, ALUOut_tomem, ReadData2_tomem, DMemWrite_tomem, DMemEn_tomem, 
	DMemDump_tomem, PCtoReg_tomem, MemtoReg_tomem, Cond_tomem, Set_tomem,
	RegWrite_tomem, RegDst_tomem, instructout, Halt_tomem, 
	//Inputs
	PCInc, ALUOut, ReadData2, DMemWrite, DMemEn, Halt, stall,
        DMemDump, PCtoReg, MemtoReg, Cond, Set, clk, en, rst, RegDst, RegWrite, instructin
	);

	output [15:0]  PCInc_tomem, ALUOut_tomem, ReadData2_tomem, instructout;
	output [1:0] RegDst_tomem;
	output DMemWrite_tomem, DMemEn_tomem, DMemDump_tomem, PCtoReg_tomem,
	       MemtoReg_tomem, Cond_tomem, Set_tomem, RegWrite_tomem, Halt_tomem;

	input [15:0] PCInc, ALUOut, ReadData2, instructin; 
	input [1:0] RegDst;
	input DMemWrite, DMemEn, DMemDump, PCtoReg, MemtoReg, Cond, Set, clk, en, rst, RegWrite, Halt, stall;

	wire DMemEn_int;
 	wire RegWrite_int; 
 	wire DMemWrite_int; 
	wire [15:0] instructInt, instrin_int;

	reg_16b_wrapper rpc0 (.clk(clk),.rst(rst),.writeData(instrin_int),.readData(instructInt),.en(en));

	reg_16b_wrapper rpc1 (.clk(clk),.rst(rst),.writeData(PCInc),.readData(PCInc_tomem),.en(en));
	reg_16b_wrapper rpc2 (.clk(clk),.rst(rst),.writeData(ALUOut),.readData(ALUOut_tomem),.en(en));
	reg_16b_wrapper rpc3 (.clk(clk),.rst(rst),.writeData(ReadData2),.readData(ReadData2_tomem),.en(en));

	dff_wrapper b_0 (.clk(clk), .rst(rst), .d(DMemWrite_int), .q(DMemWrite_tomem),.en(en));
	dff_wrapper b_1 (.clk(clk), .rst(rst), .d(DMemEn_int), .q(DMemEn_tomem),.en(en));
	dff_wrapper b_2 (.clk(clk), .rst(rst), .d(DMemDump), .q(DMemDump_tomem),.en(en));
	dff_wrapper b_3 (.clk(clk), .rst(rst), .d(PCtoReg), .q(PCtoReg_tomem),.en(en));
	dff_wrapper b_4 (.clk(clk), .rst(rst), .d(MemtoReg), .q(MemtoReg_tomem),.en(en));
	dff_wrapper b_5 (.clk(clk), .rst(rst), .d(Cond), .q(Cond_tomem),.en(en));
	dff_wrapper b_6 (.clk(clk), .rst(rst), .d(Set), .q(Set_tomem),.en(en));

	dff_wrapper df19(.q(RegDst_tomem[0]), .d(RegDst[0]), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df20(.q(RegDst_tomem[1]), .d(RegDst[1]), .en(en), .clk(clk), .rst(rst));

	dff_wrapper df21(.q(RegWrite_tomem), .d(RegWrite_int), .en(en), .clk(clk), .rst(rst));
	
	dff_wrapper df22(.q(Halt_tomem), .d(Halt), .en(en), .clk(clk), .rst(rst));

	assign instrin_int = (stall) ? 16'b0000100000000000 : instructin;
	assign DMemEn_int = DMemEn & ~stall;
 	assign RegWrite_int = ~stall & RegWrite; 
 	assign DMemWrite_int = ~stall & DMemWrite; 

	assign instructout = (rst) ? 16'b0000100000000000 : instructInt;
endmodule
