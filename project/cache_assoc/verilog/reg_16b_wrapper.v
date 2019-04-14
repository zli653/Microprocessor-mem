module reg_16b_wrapper (
           // Outputs
           readData,
           // Inputs
           clk, rst, writeData, en
           );
   
   input        clk, rst, en;
   input [15:0] writeData;

   output [15:0] readData;

   // 16 bit register as dff_wrapper's
   dff_wrapper b_0 (.d(writeData[0]), .clk(clk), .rst(rst), .q(readData[0]),.en(en));
   dff_wrapper b_1 (.d(writeData[1]), .clk(clk), .rst(rst), .q(readData[1]),.en(en));
   dff_wrapper b_2 (.d(writeData[2]), .clk(clk), .rst(rst), .q(readData[2]),.en(en));
   dff_wrapper b_3 (.d(writeData[3]), .clk(clk), .rst(rst), .q(readData[3]),.en(en));
   dff_wrapper b_4 (.d(writeData[4]), .clk(clk), .rst(rst), .q(readData[4]),.en(en));
   dff_wrapper b_5 (.d(writeData[5]), .clk(clk), .rst(rst), .q(readData[5]),.en(en));
   dff_wrapper b_6 (.d(writeData[6]), .clk(clk), .rst(rst), .q(readData[6]),.en(en));
   dff_wrapper b_7 (.d(writeData[7]), .clk(clk), .rst(rst), .q(readData[7]),.en(en));
   dff_wrapper b_8 (.d(writeData[8]), .clk(clk), .rst(rst), .q(readData[8]),.en(en));
   dff_wrapper b_9 (.d(writeData[9]), .clk(clk), .rst(rst), .q(readData[9]),.en(en));
   dff_wrapper b_10 (.d(writeData[10]), .clk(clk), .rst(rst), .q(readData[10]),.en(en));
   dff_wrapper b_11 (.d(writeData[11]), .clk(clk), .rst(rst), .q(readData[11]),.en(en));
   dff_wrapper b_12 (.d(writeData[12]), .clk(clk), .rst(rst), .q(readData[12]),.en(en));
   dff_wrapper b_13 (.d(writeData[13]), .clk(clk), .rst(rst), .q(readData[13]),.en(en));
   dff_wrapper b_14 (.d(writeData[14]), .clk(clk), .rst(rst), .q(readData[14]),.en(en));
   dff_wrapper b_15 (.d(writeData[15]), .clk(clk), .rst(rst), .q(readData[15]),.en(en));

endmodule
