module cache_fsm(
		// Inputs
		addr,data_in,read,write,clk,rst,
		c_tag_out,c_data_out,c_hit,c_dirty,c_valid,c_err,
		m_data_out,m_stall,m_busy,m_err,

		// Outputs	
		fc_enable,fc_tag_in,fc_index,fc_offset,fc_data_in,fc_comp,fc_write,fc_valid_in,
		fm_addr,fm_data_in,fm_wr,fm_rd,
		fs_data_out,fs_done,fs_stall,fs_cachehit,fs_err
	);
	
	// Inputs
	input [15:0] addr,data_in,c_data_out,m_data_out;
	input [4:0] c_tag_out;
	input [3:0] m_busy;
	input c_hit,c_dirty,c_valid,c_err,m_stall,m_err,read,write,clk,rst;
	
	// Outputs	
	output reg [15:0] fm_addr,fm_data_in,fs_data_out,fc_data_in;
	output reg [7:0] fc_index;
	output reg [4:0] fc_tag_in;
	output reg [2:0] fc_offset;
	output reg fc_enable,fc_comp,fc_write,fc_valid_in,fm_wr,fm_rd,fs_done,fs_stall,fs_cachehit;

	// Outputs not in case statement
	output fs_err;
	
	// Internal wires
	reg [3:0] state,next_state;
	reg f_err;

	/*
	* _______STATE_KEY______
	*
	* 	IDLE :		0000
	* 	COMP_WRITE : 	0001
	* 	COMP_READ : 	0010
	* 	EVICT_1 :	0011
	* 	EVICT_2 :	0100
	* 	EVICT_3 :	0101
	* 	EVICT_4 :	0110
	* 	EVICT_5 :	0111
	* 	MEM_ACC_1 : 	1000
	* 	MEM_ACC_2 :	1001
	* 	MEM_ACC_3 :	1010
	* 	MEM_ACC_4 :	1011
	* 	MEM_ACC_5 :	1100
	* 	MEM_ACC_6 :	1101
	* 	
	*/


	// Holds state for state machine
	dff state_ff [3:0] (.q(next_state), .d(state), .clk(clk), .rst(rst));
	
	assign fs_err = c_err | m_err | f_err;

	always@(*) begin	
		// Set to default, only change necessary
		fm_addr 	= 16'd0;
		fm_data_in	= 16'd0;
		fc_data_in	= 16'd0;
		fc_index	= 8'd0;
		fc_tag_in	= 5'd0;
		fc_offset	= 3'd0;
		fc_enable	= 1'b0;
		fc_comp		= 1'b0;
		fc_write	= 1'b0;
		fc_valid_in	= 1'b1; // Should always be valid execpt on reset
		fm_wr		= 1'b0;
		fm_rd		= 1'b0;
		fs_done		= 1'b0;
		fs_stall	= 1'b0;
		fs_cachehit	= 1'b0;
		fs_data_out	= 16'd0;
		f_err		= 1'b0;

		next_state = 4'd0;
		case(state)
			4'b0000://IDLE
			begin
				case({write, read}):
					2'b10:
					begin
						// go to comp write
						next_state = 4'b0001;
						fc_comp = 1'b1;
						fc_write = 1'b1;
						fc_enable = 1'b1;
						fc_offset = addr[2:0];
						fc_index = addr[10:3];
						fc_tag_in = addr[15:11];
						fc_data_in = data_in;
					end
					2'b01:
					begin
						// go to comp read
						next_state = 4'b0010
						fc_comp = 1'b1;
						fc_write = 1'b0;
						fc_enable = 1'b1;
						fc_offset = addr[2:0];
						fc_index = addr[10:3];
						fc_tag_in = addr[15:11];

					end
					2'b00:
					begin
						// stay in IDLE
					end
					2'b11: // read and write at the same time, print error message      
					begin
						f_err = 1'b1;
					end
					default: // never reached, print error message
					begin
						f_err = 1'b1;
					end	
				endcase	
			end

			4'b0001://COMP_WRITE
			begin
				casex({c_hit, c_valid, c_dirty}):
					3'b11x: // Cache hit, return to idle
					begin
						fs_done = 1'b1;
						fs_cachehit = 1'b1;
						fs_data_out = c_data_out;
					end	
					3'bX0X: //Valid is 0
					begin
						next_state = 4'b1000;//MEM_ACC_1
						fm_wr = 1'b0;
						fm_rd = 1'b1;
						fm_addr = {addr[15:3], 3'b000};//bank 0
					end
					3'b010:
					begin
						next_state = 4'b1000;//MEM_ACC_1
						fm_wr = 1'b0;
						fm_rd = 1'b1;
						fm_addr = {addr[15:3], 3'b000};//bank 0
					end
					3'b011:
					begin
						next_state = 4'b0011;//EVICT_1
						fc_enable = 1'b1;
					end

					default:
					begin
						f_err = 1'b1;
					end
			end	
			default://DEFAULT to IDLE (Never reached)
			begin
				f_err = 1'b1;
			end
			
			4'b0010://COMP_READ
			begin
			end	
			default://DEFAULT to IDLE (Never reached)
			begin
				f_err = 1'b1;
			end
		endcase
	end	
endmodule

