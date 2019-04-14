module rotate_right (In, Cnt, Out);
   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   output [N-1:0]  Out;

   assign Out = (Cnt == 4'd0) ? In[15:0]
	      : (Cnt == 4'd1) ? {In[0],In[15:1]}
	      : (Cnt == 4'd2) ? {In[1:0],In[15:2]} 
	      : (Cnt == 4'd3) ? {In[2:0],In[15:3]}
	      : (Cnt == 4'd4) ? {In[3:0],In[15:4]}
	      : (Cnt == 4'd5) ? {In[4:0],In[15:5]}
	      : (Cnt == 4'd6) ? {In[5:0],In[15:6]}
	      : (Cnt == 4'd7) ? {In[6:0],In[15:7]}
	      : (Cnt == 4'd8) ? {In[7:0],In[15:8]}
	      : (Cnt == 4'd9) ? {In[8:0],In[15:9]}
	      : (Cnt == 4'd10) ? {In[9:0],In[15:10]}
	      : (Cnt == 4'd11) ? {In[10:0],In[15:11]}
	      : (Cnt == 4'd12) ? {In[11:0],In[15:12]}
	      : (Cnt == 4'd13) ? {In[12:0],In[15:13]}
	      : (Cnt == 4'd14) ? {In[13:0],In[15:14]}
	      : (Cnt == 4'd15) ? {In[14:0],In[15]}
	      : 16'd0;
endmodule
