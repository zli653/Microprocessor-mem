/*
    CS/ECE 552 Spring '19
    Homework #4, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module left_shift (In, Cnt, Fill, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input 	   Fill;
   output [N-1:0]  Out;

   /* Intermediate wires for terms */
   wire [N-1:0]    INT1,INT2,INT3;

   /* Shift by 1 */
   mux2_1 m0 (Fill,  In[0], ~Cnt[0], INT1[0]);
   mux2_1 m1 (In[0],  In[1], ~Cnt[0], INT1[1]);
   mux2_1 m2 (In[1],  In[2], ~Cnt[0], INT1[2]);
   mux2_1 m3 (In[2],  In[3], ~Cnt[0], INT1[3]);
   mux2_1 m4 (In[3],  In[4], ~Cnt[0], INT1[4]);
   mux2_1 m5 (In[4],  In[5], ~Cnt[0], INT1[5]);
   mux2_1 m6 (In[5],  In[6], ~Cnt[0], INT1[6]);
   mux2_1 m7 (In[6],  In[7], ~Cnt[0], INT1[7]);
   mux2_1 m8 (In[7],  In[8], ~Cnt[0], INT1[8]);
   mux2_1 m9 (In[8],  In[9], ~Cnt[0], INT1[9]);
   mux2_1 m10 (In[9],  In[10], ~Cnt[0], INT1[10]);
   mux2_1 m11 (In[10],  In[11], ~Cnt[0], INT1[11]);
   mux2_1 m12 (In[11],  In[12], ~Cnt[0], INT1[12]);
   mux2_1 m13 (In[12],  In[13], ~Cnt[0], INT1[13]);
   mux2_1 m14 (In[13],  In[14], ~Cnt[0], INT1[14]);
   mux2_1 m15 (In[14],  In[15], ~Cnt[0], INT1[15]);
   
   /* Shift by 2 */
   mux2_1 m__0 (Fill,  INT1[0], ~Cnt[1], INT2[0]);
   mux2_1 m__1 (Fill,  INT1[1], ~Cnt[1], INT2[1]);
   mux2_1 m__2 (INT1[0],  INT1[2], ~Cnt[1], INT2[2]);
   mux2_1 m__3 (INT1[1],  INT1[3], ~Cnt[1], INT2[3]);
   mux2_1 m__4 (INT1[2],  INT1[4], ~Cnt[1], INT2[4]);
   mux2_1 m__5 (INT1[3],  INT1[5], ~Cnt[1], INT2[5]);
   mux2_1 m__6 (INT1[4],  INT1[6], ~Cnt[1], INT2[6]);
   mux2_1 m__7 (INT1[5],  INT1[7], ~Cnt[1], INT2[7]);
   mux2_1 m__8 (INT1[6],  INT1[8], ~Cnt[1], INT2[8]);
   mux2_1 m__9 (INT1[7],  INT1[9], ~Cnt[1], INT2[9]);
   mux2_1 m__10 (INT1[8],  INT1[10], ~Cnt[1], INT2[10]);
   mux2_1 m__11 (INT1[9],  INT1[11], ~Cnt[1], INT2[11]);
   mux2_1 m__12 (INT1[10],  INT1[12], ~Cnt[1], INT2[12]);
   mux2_1 m__13 (INT1[11],  INT1[13], ~Cnt[1], INT2[13]);
   mux2_1 m__14 (INT1[12],  INT1[14], ~Cnt[1], INT2[14]);
   mux2_1 m__15 (INT1[13],  INT1[15], ~Cnt[1], INT2[15]);


   /* Shift by 4 */
   mux2_1 m___0 (Fill,  INT2[0], ~Cnt[2], INT3[0]);
   mux2_1 m___1 (Fill,  INT2[1], ~Cnt[2], INT3[1]);
   mux2_1 m___2 (Fill,  INT2[2], ~Cnt[2], INT3[2]);
   mux2_1 m___3 (Fill,  INT2[3], ~Cnt[2], INT3[3]);
   mux2_1 m___4 (INT2[0],  INT2[4], ~Cnt[2], INT3[4]);
   mux2_1 m___5 (INT2[1],  INT2[5], ~Cnt[2], INT3[5]);
   mux2_1 m___6 (INT2[2],  INT2[6], ~Cnt[2], INT3[6]);
   mux2_1 m___7 (INT2[3],  INT2[7], ~Cnt[2], INT3[7]);
   mux2_1 m___8 (INT2[4],  INT2[8], ~Cnt[2], INT3[8]);
   mux2_1 m___9 (INT2[5],  INT2[9], ~Cnt[2], INT3[9]);
   mux2_1 m___10 (INT2[6],  INT2[10], ~Cnt[2], INT3[10]);
   mux2_1 m___11 (INT2[7],  INT2[11], ~Cnt[2], INT3[11]);
   mux2_1 m___12 (INT2[8],  INT2[12], ~Cnt[2], INT3[12]);
   mux2_1 m___13 (INT2[9],  INT2[13], ~Cnt[2], INT3[13]);
   mux2_1 m___14 (INT2[10],  INT2[14], ~Cnt[2], INT3[14]);
   mux2_1 m___15 (INT2[11],  INT2[15], ~Cnt[2], INT3[15]);

   /* Shift by 8 */
   mux2_1 m____0 (Fill,  INT3[0], ~Cnt[3], Out[0]);
   mux2_1 m____1 (Fill,  INT3[1], ~Cnt[3], Out[1]);
   mux2_1 m____2 (Fill,  INT3[2], ~Cnt[3], Out[2]);
   mux2_1 m____3 (Fill,  INT3[3], ~Cnt[3], Out[3]);
   mux2_1 m____4 (Fill,  INT3[4], ~Cnt[3], Out[4]);
   mux2_1 m____5 (Fill,  INT3[5], ~Cnt[3], Out[5]);
   mux2_1 m____6 (Fill,  INT3[6], ~Cnt[3], Out[6]);
   mux2_1 m____7 (Fill,  INT3[7], ~Cnt[3], Out[7]);
   mux2_1 m____8 (INT3[0],  INT3[8], ~Cnt[3], Out[8]);
   mux2_1 m____9 (INT3[1],  INT3[9], ~Cnt[3], Out[9]);
   mux2_1 m____10 (INT3[2],  INT3[10], ~Cnt[3], Out[10]);
   mux2_1 m____11 (INT3[3],  INT3[11], ~Cnt[3], Out[11]);
   mux2_1 m____12 (INT3[4],  INT3[12], ~Cnt[3], Out[12]);
   mux2_1 m____13 (INT3[5],  INT3[13], ~Cnt[3], Out[13]);
   mux2_1 m____14 (INT3[6],  INT3[14], ~Cnt[3], Out[14]);
   mux2_1 m____15 (INT3[7],  INT3[15], ~Cnt[3], Out[15]);


  
endmodule
