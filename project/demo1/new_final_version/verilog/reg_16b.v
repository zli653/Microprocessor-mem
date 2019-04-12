/*
   CS/ECE 552, Spring '19
   Homework #5, Problem #1
  
   This module creates a 16-bit register. It has 1 16bit write input,
   a reset, and a clock input.  All register state changes occur on the 
   rising edge of the clock. 
*/
module reg_16b (
           // Outputs
           readData,
           // Inputs
           clk, rst, writeData
           );
   
   input        clk, rst;
   input [15:0] writeData;

   output [15:0] readData;

   // 16 bit register as dff's
   dff b_0 (.d(writeData[0]), .clk(clk), .rst(rst), .q(readData[0]));
   dff b_1 (.d(writeData[1]), .clk(clk), .rst(rst), .q(readData[1]));
   dff b_2 (.d(writeData[2]), .clk(clk), .rst(rst), .q(readData[2]));
   dff b_3 (.d(writeData[3]), .clk(clk), .rst(rst), .q(readData[3]));
   dff b_4 (.d(writeData[4]), .clk(clk), .rst(rst), .q(readData[4]));
   dff b_5 (.d(writeData[5]), .clk(clk), .rst(rst), .q(readData[5]));
   dff b_6 (.d(writeData[6]), .clk(clk), .rst(rst), .q(readData[6]));
   dff b_7 (.d(writeData[7]), .clk(clk), .rst(rst), .q(readData[7]));
   dff b_8 (.d(writeData[8]), .clk(clk), .rst(rst), .q(readData[8]));
   dff b_9 (.d(writeData[9]), .clk(clk), .rst(rst), .q(readData[9]));
   dff b_10 (.d(writeData[10]), .clk(clk), .rst(rst), .q(readData[10]));
   dff b_11 (.d(writeData[11]), .clk(clk), .rst(rst), .q(readData[11]));
   dff b_12 (.d(writeData[12]), .clk(clk), .rst(rst), .q(readData[12]));
   dff b_13 (.d(writeData[13]), .clk(clk), .rst(rst), .q(readData[13]));
   dff b_14 (.d(writeData[14]), .clk(clk), .rst(rst), .q(readData[14]));
   dff b_15 (.d(writeData[15]), .clk(clk), .rst(rst), .q(readData[15]));

endmodule
