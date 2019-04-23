/*
   CS/ECE 552, Spring '19
   Homework #5, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module rf_bypass (
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

   wire[15:0] 	rd1,rd2;
   wire 	int1,int2;

   // Using original rf module
   rf rf_0 (.clk(clk),.rst(rst),.readReg1Sel(readReg1Sel),.readReg2Sel(readReg2Sel),
	   .writeRegSel(writeRegSel),.writeData(writeData),.writeEn(writeEn),.readData1(rd1),
	   .readData2(rd2),.err(err));

   // Determine readData
   assign int1 = (writeRegSel == readReg1Sel) ? 1'b1 : 1'b0;
   assign readData1 = (int1 & writeEn) == 1'b1 ? writeData : rd1; 
   
   assign int2 = (writeRegSel == readReg2Sel) ? 1'b1 : 1'b0;
   assign readData2 = (int2 & writeEn) == 1'b1 ? writeData : rd2; 

endmodule
