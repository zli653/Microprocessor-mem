/*
    CS/ECE 552 Spring '19
    Homework #4, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
	Opcode	Function	Result
	000	rll		Rotate left
	001	sll		Shift left logical
	010	rrr		Shift right arithmetic
	011	srl		Shift right logical
	100	ADD		A+B
	101	AND		A AND B
	110	OR		A OR B
	111	XOR		A XOR B

*/
module alu (A, B, Cin, Op, invA, invB, sign, Out, Zero, Ofl);

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 3;
   
   input [N-1:0] A;
   input [N-1:0] B;
   input         Cin;
   input [O-1:0] Op;
   input         invA;
   input         invB;
   input         sign;
   output [N-1:0] Out;
   output         Ofl;
   output         Zero;

   wire s_ofl,us_ofl,int_ofl,s_int_ofl, dont_care;
   wire[N-1:0] InA,InB,rll,sll,rrr,srl,us_add,s_add,b_and,b_or,b_xor,final_add;

   // Invert input if needed
   assign InA = (invA == 1'b1) ? ~A : A;
   assign InB = (invB == 1'b1) ? ~B : B;

   // rll
   barrelShifter b1 (.In(InA), .Cnt(InB[3:0]), .Op(2'b00), .Out(rll));

   // sll
   barrelShifter b2 (.In(InA), .Cnt(InB[3:0]), .Op(2'b01), .Out(sll));

   // rrr
   barrelShifter b3 (.In(InA), .Cnt(InB[3:0]), .Op(2'b10), .Out(rrr));

   // srl
   barrelShifter b4 (.In(InA), .Cnt(InB[3:0]), .Op(2'b11), .Out(srl));
   
   // ADD
   rca_16b r1 (.A(InA), .B(InB), .C_in(Cin), .C_out(us_ofl), .S(us_add)); // Unsigned overflow occurs if carry at last bit
   rca_16b r2 (.A(InA), .B(InB), .C_in(Cin), .C_out(dont_care), .S(s_add)); 
  
   //  Signed overflow occurs if operands have same sign, but diff sign result
   assign s_int_ofl = (InA[N] == InB[N]) ? 1'b1 : 1'b0; // Intermediate for determining signed overflow
   assign s_int1_ofl = (InA[N] != s_add[N]) ? 1'b1 : 1'b0; // Intermediate for determining signed overflow
   assign s_ofl = (s_int_ofl == s_int1_ofl) ? 1'b1 : 1'b0;

   assign final_add = (sign == 1'b1) ? s_add : us_add; // Use s_add if signed number
   
   assign int_ofl = (sign == 1'b1) ? s_ofl : us_ofl;
   assign Ofl = (Op == 3'b100) ? int_ofl : 1'b0; // Assign Ofl to output only if add, else logic low 
   
   // AND -> Use bitwise AND
   assign b_and = InA & InB;

   // OR -> Use bitwise OR
   assign b_or = InA | InB;

   // XOR -> Use bitwise XOR
   assign b_xor = InA ^ InB;

   assign Out = (Op == 3'b000) ? rll
   	      : (Op == 3'b001) ? sll
   	      : (Op == 3'b010) ? rrr
   	      : (Op == 3'b011) ? srl
   	      : (Op == 3'b100) ? final_add
   	      : (Op == 3'b101) ? b_and
   	      : (Op == 3'b110) ? b_or
   	      : (Op == 3'b111) ? b_xor
	      : 16'd0;

   // Zero=1 if output is exactly zero else logic low
   assign Zero = (Out == 16'd0) ? 1'b1 : 1'b0;
endmodule
