/*
    CS/ECE 552 Spring '19
    Homework #3, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    wire s0,a0,b0;

    not1 f (.in1(S), .out(s0));
    nand2 s (InA, s0, a0);
    nand2 t (InB, S, b0);
    nand2 fo (a0, b0, Out);

endmodule  // mux2
