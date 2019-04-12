/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 2
    
    a 4-bit RCA module
*/
module rca_4b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
	input          C_in;
    output [N-1:0] S;
    output         C_out;
    
    wire c0, c1, c2; 

    fullAdder_1b bit_0(A[0], B[0], C_in, S[0], c0);
    fullAdder_1b bit_1(A[1], B[1], c0, S[1], c1);
    fullAdder_1b bit_2(A[2], B[2], c1, S[2], c2);
    fullAdder_1b bit_3(A[3], B[3], c2, S[3], C_out);

endmodule
