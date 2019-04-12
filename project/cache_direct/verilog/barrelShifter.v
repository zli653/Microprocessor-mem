/*
    CS/ECE 552 Spring '19
    Homework #4, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.

    Opcode:
	00 - Rotate left
	01 - Shift left
	10 - Shift right arithmetic
	11 - Shift right logical
 */
module barrelShifter (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input [O-1:0]   Op;
   output [N-1:0]  Out;

   wire[N-1:0] W,X,Y,Z,TMP,INT1,INT2,INT3;

   reverse x (.In(In), .Out(TMP));
   /* Rotate left */
   rotate_right a (.In(TMP), .Cnt(Cnt), .Out(INT3));
   reverse n (.In(INT3), .Out(W));

   /* Shift left */
   left_shift b (.In(In), .Cnt(Cnt), .Fill(1'b0), .Out(X));
   
   /* Rotate Right */
   rotate_right r (.In(In), .Cnt(Cnt), .Out(Y));

   /* Shift right logical */
   left_shift d (.In(TMP), .Cnt(Cnt), .Fill(1'b0), .Out(INT2));
   reverse z (.In(INT2), .Out(Z));

   assign Out = (Op == 2'b00) ? W
	      : (Op == 2'b01) ? X
	      : (Op == 2'b10) ? Y
              : (Op == 2'b11) ? Z
	      : 16'd0;
 
endmodule
