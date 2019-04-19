

module fetch (
	//outputs
	err, PCInc, Instr, nop,
	//inputs
	clk, rst, PCSrc, Halt, Branch_PC, Cond, PCImm, Jump, En, Dmem_Stall
	);

	//inputs
	input clk;
	input rst;
	input PCSrc;
	input Halt;
	input PCImm;
	input Jump;
	input Cond;	
	input En;
	input [15:0] Branch_PC;
	input Dmem_Stall;
	
	//outputs
	output [15:0] PCInc; 
	output err;
	output [15:0] Instr;
	output nop;

	wire [15:0] PCCur; 
	wire mux1_ctrl;
	wire [15:0] mux1_out;	
	wire [15:0] mux2_out;
	wire dc;
	wire [15:0] Instr_int;
	wire [15:0] PCIn;
	wire Stall, Done, CacheHit;

	//wire cond_out;
	//wire pc_src_out;
	//assign pc_src_out = rst ? 1'b0 : PCSrc;
	//assign cond_out = rst ? 1'b0 : Cond;
	//assign mux1_ctrl = PCImm | Jump | (pc_src_out & cond_out);

	assign mux1_ctrl = PCImm | Jump | (PCSrc & Cond);
	assign mux1_out = mux1_ctrl ? Branch_PC : PCInc;
	assign mux2_out = (~En | Halt | ((Stall|Dmem_Stall) & ~mux1_ctrl)) ? PCIn : mux1_out;
	assign PCCur = rst ? 16'h0000 : mux2_out;
	
	reg_16b pc_reg (.clk(clk),.rst(rst),.writeData(PCCur),.readData(PCIn));
	
	// Add two to PC (Dont care about carry)
	rca_16b add_2(.A(PCIn), .B(16'd2), .C_in(1'b0), .S(PCInc), .C_out(dc));

	//dont care about datain, never writing to this mem
	//started addr at zero on Rst
	
	
	mem_system imem(.DataOut(Instr_int), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), .Addr(PCIn), 
			.DataIn(16'd0), .Rd(1'b1), .Wr(1'b0), .createdump(1'b1), .clk(clk), .rst(rst));
	/*assign Stall = 1'b0;
	assign Done = 1'b1;
	assign CacheHit = 1'b1;
	memory2c_align imem(.data_out(Instr_int), .data_in(16'd0), .addr(PCIn), .enable(1'b1), .wr(1'b0), .createdump(1'b0), 
		.clk(clk), .rst(rst), .err(err));*/
	assign Instr = Instr_int;
	assign nop = (mux1_ctrl & ~rst) | Stall; 
endmodule
