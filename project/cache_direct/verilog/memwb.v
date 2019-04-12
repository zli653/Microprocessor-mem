module memwb (
	//Output
	PCInc_towb, MemOut_towb, PCtoReg_towb, MemtoReg_towb, Cond_towb, Set_towb, ALUOut_towb,
	instructout, RegWrite_todec, RegDst_todec, Halt_tof,
	//Input
	ALUOut, PCInc, MemOut, PCtoReg, MemtoReg, Cond, Set, rst, clk, en, 
	instructin, RegWrite, RegDst, Halt, Dmem_Stall
	);
	
	output [15:0] PCInc_towb, MemOut_towb, ALUOut_towb, instructout;
	output PCtoReg_towb, MemtoReg_towb, Cond_towb, Set_towb, RegWrite_todec, Halt_tof;
	output [1:0] RegDst_todec;
	input [15:0] PCInc, MemOut, ALUOut, instructin;
	input PCtoReg, MemtoReg, Cond, Set, rst, clk, en, RegWrite, Halt, Dmem_Stall;
	input [1:0] RegDst;

	wire [15:0] instructInt;

	reg_16b_wrapper r1(.writeData(PCInc), .clk(clk), .rst(rst), .en(en), .readData(PCInc_towb));
	reg_16b_wrapper r2(.writeData(MemOut), .clk(clk), .rst(rst), .en(en), .readData(MemOut_towb));
	reg_16b_wrapper r3(.writeData(ALUOut), .clk(clk), .rst(rst), .en(en), .readData(ALUOut_towb));

	reg_16b_wrapper r4(.writeData(instructin), .clk(clk), .rst(rst), .en(en), .readData(instructInt));
	
	dff_wrapper b_0 (.clk(clk), .rst(rst), .d(PCtoReg), .q(PCtoReg_towb),.en(en));
	dff_wrapper b_1 (.clk(clk), .rst(rst), .d(MemtoReg), .q(MemtoReg_towb),.en(en));
	dff_wrapper b_2 (.clk(clk), .rst(rst), .d(Cond), .q(Cond_towb),.en(en));
	dff_wrapper b_3 (.clk(clk), .rst(rst), .d(Set), .q(Set_towb),.en(en));

	dff_wrapper b_4(.q(RegDst_todec[0]), .d(RegDst[0]), .en(en), .clk(clk), .rst(rst));
	dff_wrapper b_5(.q(RegDst_todec[1]), .d(RegDst[1]), .en(en), .clk(clk), .rst(rst));

	dff_wrapper b_6(.q(RegWrite_todec_int), .d(RegWrite), .en(en), .clk(clk), .rst(rst));
	assign RegWrite_todec = RegWrite_todec_int &~ Dmem_Stall; 	
	dff_wrapper b_7(.q(Halt_tof), .d(Halt), .en(en), .clk(clk), .rst(rst));

	assign instructout = (rst | Dmem_Stall) ? 16'b0000100000000000 : instructInt;
endmodule
