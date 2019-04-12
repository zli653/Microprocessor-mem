module idex (
	//Outputs	
	InvA_toex, InvB_toex, Sign_toex, Cin_toex, Op_toex, PCInc_toex,
	ALUSrc2_toex, Btr_toex, ReadData2_toex, EffReadData1_toex,
	Imm_toex, DMemWrite_toex, DMemEn_toex, DMemDump_toex, PCtoReg_toex,
	MemtoReg_toex, Cond_toex, Set_toex, instructout, RegWrite_toex,RegDst_toex, Halt_toex,
	//Inputs
	//

	InvA, InvB, Sign, Cin, Op, Halt, PCInc,
        ALUSrc2, Btr, ReadData2, EffReadData1,
        Imm, DMemWrite, DMemEn, DMemDump, PCtoReg,
        MemtoReg, Cond, Set, clk, En, rst, instructin, RegDst, RegWrite
	);

	output [15:0] ReadData2_toex, EffReadData1_toex, Imm_toex, instructout, PCInc_toex;
	output [2:0] Op_toex; 
	output [1:0] RegDst_toex;
	output  InvA_toex, InvB_toex, Sign_toex, Cin_toex,
        ALUSrc2_toex, Btr_toex, DMemWrite_toex, DMemEn_toex,
       	DMemDump_toex, PCtoReg_toex, MemtoReg_toex, Cond_toex, Set_toex,
	RegWrite_toex, Halt_toex;

	input [15:0] ReadData2, EffReadData1, Imm, instructin, PCInc;
	input [2:0] Op;
	input [1:0] RegDst;
	input InvA, InvB, Sign, Cin, ALUSrc2, Btr,
        DMemWrite, DMemEn, DMemDump, PCtoReg,
        MemtoReg, Cond, Set, clk, En, rst,
	RegWrite, Halt;

	wire [15:0] instructInt;
	wire RegWrite_toex_int;
	wire DMemWrite_toex_int;
	wire DMemEn_toex_int;
	wire Halt_toex_int;
	wire en;

	assign en = 1'b1;
	assign DMemEn_toex_int = DMemEn & En;
 	assign RegWrite_toex_int = En & RegWrite; 
 	assign DMemWrite_toex_int = En & DMemWrite; 
 	assign Halt_toex_int = Halt;

	//assign DMemEn_toex_int = En ? DMemEn : 1'b0; 
	reg_16b_wrapper r1(.writeData(ReadData2), .clk(clk), .rst(rst), .en(en), .readData(ReadData2_toex));
	reg_16b_wrapper r2(.writeData(EffReadData1), .clk(clk), .rst(rst), .en(en), .readData(EffReadData1_toex));
	reg_16b_wrapper r3(.writeData(Imm), .clk(clk), .rst(rst), .en(en), .readData(Imm_toex));
	reg_16b_wrapper r4(.writeData(PCInc), .clk(clk), .rst(rst), .en(en), .readData(PCInc_toex));
	reg_16b_wrapper r5(.writeData(instructin), .clk(clk), .rst(rst), .en(en), .readData(instructInt));

	dff_wrapper df1(.q(InvA_toex), .d(InvA), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df2(.q(InvB_toex), .d(InvB), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df3(.q(Sign_toex), .d(Sign), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df4(.q(Cin_toex), .d(Cin), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df5(.q(ALUSrc2_toex), .d(ALUSrc2), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df6(.q(Btr_toex), .d(Btr), .en(en), .clk(clk), .rst(rst));
	//dff_wrapper df7(.q(PCImm_toex), .d(PCImm), .en(en), .clk(clk), .rst(rst));
	//dff_wrapper df8(.q(DMemWrite_toex), .d(DMemWrite), .en(en), .clk(clk), .rst(rst));
	//dff_wrapper df9(.q(DMemEn_toex), .d(DMemEn), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df10(.q(DMemDump_toex), .d(DMemDump), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df11(.q(PCtoReg_toex), .d(PCtoReg), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df12(.q(MemtoReg_toex), .d(MemtoReg), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df13(.q(Cond_toex), .d(Cond), .en(en), .clk(clk), .rst(rst));
	//dff_wrapper df14(.q(Jump_toex), .d(Jump), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df15(.q(Set_toex), .d(Set), .en(en), .clk(clk), .rst(rst));
	
	dff_wrapper df16(.q(Op_toex[0]), .d(Op[0]), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df17(.q(Op_toex[1]), .d(Op[1]), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df18(.q(Op_toex[2]), .d(Op[2]), .en(en), .clk(clk), .rst(rst));

	dff_wrapper df19(.q(RegDst_toex[0]), .d(RegDst[0]), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df20(.q(RegDst_toex[1]), .d(RegDst[1]), .en(en), .clk(clk), .rst(rst));

	dff_wrapper df21(.q(DMemWrite_toex), .d(DMemWrite_toex_int), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df22(.q(DMemEn_toex), .d(DMemEn_toex_int), .en(en), .clk(clk), .rst(rst));
	dff_wrapper df23(.q(RegWrite_toex), .d(RegWrite_toex_int), .en(en), .clk(clk), .rst(rst));
	
	dff_wrapper df24(.q(Halt_toex), .d(Halt_toex_int), .en(en), .clk(clk), .rst(rst));

	assign instructout = (rst) ? 16'b0000100000000000 : instructInt;
endmodule
