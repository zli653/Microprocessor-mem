/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 2
    
    a 16-bit RCA module
*/
module rca_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1:0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    wire c0, c1, c2;

     rca_4b bits_0_3(A[3:0], B[3:0], C_in, S[3:0], c0); 
     rca_4b bits_4_7(A[7:4], B[7:4], c0, S[7:4], c1); 
     rca_4b bits_8_11(A[11:8], B[11:8], c1, S[11:8], c2); 
     rca_4b bits_12_15(A[15:12], B[15:12], c2, S[15:12], C_out); 

endmodule
