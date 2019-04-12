/*
   CS/ECE 552, Spring '19
   Homework #5, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module rf (
           // Outputs
           readData1, readData2, err,
           // Inputs
           clk, rst, readReg1Sel, readReg2Sel, writeRegSel, writeData, writeEn
           );
   
   input        clk, rst;
   input [2:0]  readReg1Sel;
   input [2:0]  readReg2Sel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] readData1;
   output [15:0] readData2;
   output        err;

   wire dec_0,dec_1,dec_2,dec_3,dec_4,dec_5,dec_6,dec_7,err_0,err_1,err_2,err_3,err_4;
   wire[15:0] write_0,write_1,write_2,write_3,write_4,write_5,write_6,write_7;
   wire[15:0] read_0,read_1,read_2,read_3,read_4,read_5,read_6,read_7;	

   // Assign error if needed (Assume any undefined input is an error)
   assign err_0 = (^readReg1Sel === 1'bX) ? 1'b1 : 1'b0;
   assign err_1 = (^readReg2Sel === 1'bX) ? 1'b1 : 1'b0;
   assign err_2 = (^writeRegSel === 1'bX) ? 1'b1 : 1'b0;
   assign err_3 = (^writeData === 1'bX) ? 1'b1 : 1'b0;
   assign err_4 = (^writeEn === 1'bX) ? 1'b1 : 1'b0;
 //  assign err = (err_0 | err_1 | err_2 | err_3 | err_4);
   assign err = 0;

   // Array of registers
   reg_16b reg_0 (.clk(clk),.rst(rst),.writeData(write_0),.readData(read_0));
   reg_16b reg_1 (.clk(clk),.rst(rst),.writeData(write_1),.readData(read_1));
   reg_16b reg_2 (.clk(clk),.rst(rst),.writeData(write_2),.readData(read_2));
   reg_16b reg_3 (.clk(clk),.rst(rst),.writeData(write_3),.readData(read_3));
   reg_16b reg_4 (.clk(clk),.rst(rst),.writeData(write_4),.readData(read_4));
   reg_16b reg_5 (.clk(clk),.rst(rst),.writeData(write_5),.readData(read_5));
   reg_16b reg_6 (.clk(clk),.rst(rst),.writeData(write_6),.readData(read_6));
   reg_16b reg_7 (.clk(clk),.rst(rst),.writeData(write_7),.readData(read_7));

   // Determine which register to write to (Decoder like)
   assign dec_0 = (writeRegSel == 3'd0) ? 1'b1 : 1'b0;
   assign dec_1 = (writeRegSel == 3'd1) ? 1'b1 : 1'b0;
   assign dec_2 = (writeRegSel == 3'd2) ? 1'b1 : 1'b0;
   assign dec_3 = (writeRegSel == 3'd3) ? 1'b1 : 1'b0;
   assign dec_4 = (writeRegSel == 3'd4) ? 1'b1 : 1'b0;
   assign dec_5 = (writeRegSel == 3'd5) ? 1'b1 : 1'b0;
   assign dec_6 = (writeRegSel == 3'd6) ? 1'b1 : 1'b0;
   assign dec_7 = (writeRegSel == 3'd7) ? 1'b1 : 1'b0;

   // Decide what to write to each register
   assign write_0 = (writeEn & dec_0) == 1'd1 ? writeData : read_0;
   assign write_1 = (writeEn & dec_1) == 1'd1 ? writeData : read_1;
   assign write_2 = (writeEn & dec_2) == 1'd1 ? writeData : read_2;
   assign write_3 = (writeEn & dec_3) == 1'd1 ? writeData : read_3;
   assign write_4 = (writeEn & dec_4) == 1'd1 ? writeData : read_4;
   assign write_5 = (writeEn & dec_5) == 1'd1 ? writeData : read_5;
   assign write_6 = (writeEn & dec_6) == 1'd1 ? writeData : read_6;
   assign write_7 = (writeEn & dec_7) == 1'd1 ? writeData : read_7;

   // Decide which register to read
   assign readData1 = (readReg1Sel == 3'd0) ? read_0
   	: (readReg1Sel == 3'd1) ? read_1
   	: (readReg1Sel == 3'd2) ? read_2
   	: (readReg1Sel == 3'd3) ? read_3
   	: (readReg1Sel == 3'd4) ? read_4
   	: (readReg1Sel == 3'd5) ? read_5
   	: (readReg1Sel == 3'd6) ? read_6
   	: (readReg1Sel == 3'd7) ? read_7
	: 16'd0;
	       
   assign readData2 = (readReg2Sel == 3'd0) ? read_0
   	: (readReg2Sel == 3'd1) ? read_1
   	: (readReg2Sel == 3'd2) ? read_2
   	: (readReg2Sel == 3'd3) ? read_3
   	: (readReg2Sel == 3'd4) ? read_4
   	: (readReg2Sel == 3'd5) ? read_5
   	: (readReg2Sel == 3'd6) ? read_6
   	: (readReg2Sel == 3'd7) ? read_7
	: 16'd0;

endmodule
