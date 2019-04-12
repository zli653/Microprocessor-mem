
/*
   CS/ECE 552, Spring '19
   Homework #6, Problem #1
  
   This module determines all of the control logic for the processor.
*/
module control (/*AUTOARG*/
                // Outputs
                err, 
                RegDst,
                SESel,
                RegWrite,
                DMemWrite,
                DMemEn,
                ALUSrc2,
                PCSrc,
                MemToReg,
                DMemDump,
                Jump,
		PCImm,
		//added after hw6 PCToReg =
		Slbi,
		Lbi,
		invA,
		invB,
		Sign,
		Cin,
		Op,
		BrSel,
		Set,
		Halt,
		PCToReg,
		Btr,

                // Inputs
                OpCode,
                Funct
                );

	// inputs
	input [4:0]  OpCode;
	input [1:0]  Funct;

	// outputs
	output reg   err;
	output reg   RegWrite, DMemWrite, DMemEn, ALUSrc2, PCSrc, 
		MemToReg, DMemDump, Jump, PCImm, Slbi, Lbi, invA,
		invB, Sign, Cin, Set, Halt, PCToReg, Btr;

	output reg [2:0] Op; 
	output reg[1:0] RegDst;
	output reg [2:0] BrSel;
	output reg[2:0] SESel;

	always@(*) begin
  		Btr = 1'b0;
		Slbi = 1'b0;
		Lbi = 1'b0;
		Halt = 1'b0;
		case(OpCode)
			5'b00000://HALT
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'bXXX;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0;
				MemToReg = 1'bX; //changed from zero
     				DMemDump = 1'b1;
				Jump = 1'b0;
				PCImm = 1'b0;
				//added after hw6 
				PCToReg = 1'bX;
				Slbi = 1'bX;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel =  3'bXXX;
				Set = 1'bX;
				Halt = 1'b1;
				Lbi = 1'bX;
			end

			5'b00001://NOP
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'bXXX;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'bX;
				Slbi = 1'bX;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 2'bXX; 
				Set = 1'bX;
				Lbi = 1'bX;
			end

			5'b01000://SUBI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b01X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b1; //invert bits -rs
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b1; //add 1 for 2's comp
				Op = 3'b100;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end

			5'b01001://ADDI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b01X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b0;
				Op = 3'b100;
				BrSel = 3'bXXX;
				Set = 1'b0;
			end
			
			5'b01010://ANDNI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b1;
				Sign = 1'b0;
				Cin = 1'b0;
				Op = 3'b101;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end
			
			5'b01011://XORI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b0;
				Cin = 1'b0;
				Op = 3'b111;
				BrSel = 3'bXXX;
				Set = 1'b0;
			end
			
			5'b10100://ROLI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000; // Need lowest 4 bits, so doesn't matter which
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b0;
				Cin = 1'b0;
				Op = 3'b000;
				BrSel = 3'bXXX;
				Set = 1'b0;			
			end
			
			5'b10101://SLLI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000; //could also be 3'b011
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b0;
				Cin = 1'b0;
				Op = 3'b001;
				BrSel = 3'bXXX;
				Set = 1'b0;
			end
			
			5'b10110://RORI      //Changed SRA to this
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000; // Lowest 4, so dc
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'b010; //REPLACED shift right arithmetic
				BrSel = 3'bXXX;
				Set = 1'b0;
			end
				
			5'b10111://SRLI
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b000; //Also 011 is ok
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b0;
				Cin = 1'b0;
				Op = 3'b011;
				BrSel = 3'bXXX;
				Set = 1'b0;			
			end

			5'b10000://ST
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b01X;
				RegWrite = 1'b0;
				DMemWrite = 1'b1;
				DMemEn = 1'b1;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b0;
				Op = 3'b100;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end
			
			5'b10001://LD
			begin
				err = 1'b0;				
				RegDst = 2'b01;
				SESel = 3'b01X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b1;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b1; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b0;
				Op = 3'b100;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end

			5'b10011://STU
			begin
				err = 1'b0;				
				RegDst = 2'b10;
				SESel = 3'b01X;
				RegWrite = 1'b1;
				DMemWrite = 1'b1;
				DMemEn = 1'b1;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b0;
				Op = 3'b100;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end

			5'b11001://BTR          CAN WE DO THIS WITH ALU
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b1;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
     				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 3'bXXX; 
				Set = 1'b0;
				Halt = 1'b0;
				Btr = 1'b1;
			end

			5'b11011://ADD, SUB, XOR, ANDN
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b1;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				BrSel = 3'bXXX; 
				Set = 1'b0;
				
				case(Funct)
					2'b00://ADD
					begin				
						invA = 1'b0;
						invB = 1'b0;
						Sign = 1'b1;
						Cin = 1'b0;
						Op = 3'b100;//ADD/SUB
					end

					2'b01://SUB
					begin				
						invA = 1'b1;
						invB = 1'b0;
						Sign = 1'b1;
 						Cin = 1'b1;
						Op = 3'b100;//ADD/SUB
					end

					2'b10://XOR
					begin				
						invA = 1'b0;
						invB = 1'b0;
						Sign = 1'bX;
						Cin = 1'bX;
						Op = 3'b111;//XOR
					end

					2'b11: //ANDN
					begin				
						invA = 1'b0;
						invB = 1'b1; //~rt
						Sign = 1'bX;
						Cin = 1'bX;
						Op = 3'b101;//AND
					end

				endcase
			end

			5'b11010://ROL, SLL, ROR, SRL
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b1;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				BrSel = 3'bXXX; 
				Set = 1'b0;

				case(Funct)
					2'b00://ROL
					begin				
						invA = 1'b0;
						invB = 1'b0;
						Sign = 1'bX;
						Cin = 1'bX;
						Op = 3'b000;
					end

					2'b01://SLL
					begin				
						invA = 1'b0;
						invB = 1'b0;
						Sign = 1'bX;
 						Cin = 1'bX;
						Op = 3'b001;
					end

					2'b10://ROR
					begin				
						invA = 1'b0;
						invB = 1'b0;
						Sign = 1'bX;
						Cin = 1'bX;
						Op = 3'b010;
					end

					2'b11: //SRL
					begin				
						invA = 1'b0;
						invB = 1'b0; 
						Sign = 1'bX;
						Cin = 1'bX;
						Op = 3'b011;
					end

				endcase

			end

			5'b11100: //SEQ
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //100
				Set = 1'b1;  //set to cond
			end
			
			5'b11101: //SLT
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //101
				Set = 1'b1;  //set to cond
			end

			5'b11110: //SLE
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //110
				Set = 1'b1;  //set to cond
			end
			
			5'b11111: //SCO
			begin
				err = 1'b0;				
				RegDst = 2'b00;
				SESel = 3'bXXX;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b1;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;
				
				//added after hw6
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //111
				Set = 1'b1;  //set to cond
			end
			
			5'b01100: //BNEZ
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b10X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b1;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //000
				Set = 1'bX;  
			end

			5'b01101: //BEQZ
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b10X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b1;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //001
				Set = 1'b1;  //set to cond
			end

			5'b01110: //BLTZ
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b10X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b1;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //010
				Set = 1'bX;  
			end

			5'b01111: //BGEZ
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b10X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b1;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = {OpCode[4], OpCode[1:0]}; //011
				Set = 1'bX;  
			end

			5'b11000: //LBI
			begin
				err = 1'b0;				
				RegDst = 2'b10;
				SESel = 3'b10X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'bX;
				invA = 1'b0;
				invB = 1'b0;
				Sign = 1'b1;
				Cin = 1'b0;
				Op = 3'b100;
				BrSel = 3'bXXX; 
				Set = 1'b0;
				Lbi = 1'b1;
			end

			5'b10010: //SLBI
			begin
				err = 1'b0;				
				RegDst = 2'b10;
				SESel = 3'b001;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0;
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				Slbi = 1'b1;
				invA = 1'b0; 
				invB = 1'b0;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'b110; //OR
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end

			5'b00100: //J
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b11X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0; //changed to Zero, PCsrc is only branch
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b1;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
 				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 3'bXXX; 
				Set = 1'bX;
			end

			5'b00101: //JR
			begin
				err = 1'b0;				
				RegDst = 2'bXX;
				SESel = 3'b10X;
				RegWrite = 1'b0;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'bX;
				PCSrc = 1'b0; //changed to Zero, PCsrc is only branch
				MemToReg = 1'b0; 
				DMemDump = 1'b0;
				Jump = 1'b1;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b0;
				invA = 1'bX;
 				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 3'bXXX; 
				Set = 1'bX;
			end

			5'b00110: //JAL
			begin
				err = 1'b0;				
				RegDst = 2'b11;
				SESel = 3'b11X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0; //changed to Zero, PCsrc is only branch
				MemToReg = 1'b1; //Changed to 1 from hw to match drawing
				DMemDump = 1'b0;
				Jump = 1'b0;
				PCImm = 1'b1;

				//added after hw6 
				PCToReg = 1'b1; ///set to 1
				invA = 1'bX;
 				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 3'bXXX; 
				Set = 1'b0;

			end

			5'b00111: //JALR
			begin
				err = 1'b0;				
				RegDst = 2'b11;
				SESel = 3'b10X;
				RegWrite = 1'b1;
				DMemWrite = 1'b0;
				DMemEn = 1'b0;
				ALUSrc2 = 1'b0;
				PCSrc = 1'b0; //changed to Zero, PCsrc is only branch
				MemToReg = 1'b1; //Changed to 1 from hw to match drawing
				DMemDump = 1'b0;
				Jump = 1'b1;
				PCImm = 1'b0;

				//added after hw6 
				PCToReg = 1'b1; ///set to 1
				invA = 1'bX;
 				invB = 1'bX;
				Sign = 1'bX;
				Cin = 1'bX;
				Op = 3'bXXX;
				BrSel = 3'bXXX; 
				Set = 1'b0;
			end

		endcase
	end
   
endmodule
