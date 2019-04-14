/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    wire x0, x1, n0, c0, c1, c2;

    xor3
    	xo(.in1(A), .in2(B), .in3(C_in), .out(x1));
    not1
    	no(.in1(x1), .out(x0));
    nand3
        na(.in1(A), .in2(B), .in3(C_in), .out(n0));
    nand2
    	a0(.in1(x0), .in2(n0), .out(S)),
	a1(.in1(A), .in2(B), .out(c0)),
	a2(.in1(A), .in2(C_in), .out(c1)),
	a3(.in1(B), .in2(C_in), .out(c2));
    nand3
    	a4(.in1(c0), .in2(c1), .in3(c2), .out(C_out));

endmodule
