module cache_fsm(
		// Inputs
		addr,data_in,read,write,clk,rst,
		c_tag_out_1,c_data_out_1,c_hit_1,c_dirty_1,c_valid_1,c_err_1,
		c_tag_out_2,c_data_out_2,c_hit_2,c_dirty_2,c_valid_2,c_err_2,
		m_data_out,m_busy,m_err,m_stall,

		// Outputs	
		fc_enable_1,fc_tag_in_1,fc_index_1,fc_offset_1,fc_data_in_1,fc_comp_1,fc_write_1,fc_valid_in_1,
		fc_enable_2,fc_tag_in_2,fc_index_2,fc_offset_2,fc_data_in_2,fc_comp_2,fc_write_2,fc_valid_in_2,
		fm_addr,fm_data_in,fm_wr,fm_rd,
		fs_data_out,fs_done,fs_cachehit,fs_err,f_stall
	);
	
	// Inputs
	input [15:0] addr,data_in,m_data_out, c_data_out_1, c_data_out_2;
	input [4:0] c_tag_out_1, c_tag_out_2;
	input [3:0] m_busy;
	input m_err,read,write,clk,rst,m_stall;
	input c_hit_1,c_dirty_1,c_valid_1,c_err_1;
	input c_hit_2,c_dirty_2,c_valid_2,c_err_2;

	// Outputs	
	output [15:0] fm_addr,fm_data_in,fs_data_out,fc_data_in_1,fc_data_in_2;
	output [7:0] fc_index_1, fc_index_2;
	output [4:0] fc_tag_in_1, fc_tag_in_2;
	output [2:0] fc_offset_1, fc_offset_2;
	output fc_enable_1,fc_comp_1,fc_write_1,fc_valid_in_1;
	output fc_enable_2,fc_comp_2,fc_write_2,fc_valid_in_2;
	output fm_wr,fm_rd,fs_done,fs_cachehit,f_stall;

	// Outputs not in case statement
	output fs_err;
	
	// Internal regs and wires
	//wire [1:0] read_offset;
	//wire [3:0] state,next_state;
	wire [3:0] state_int, next_state_int;

	//Intermediate
	wire [15:0] data_int, data_prev, m_data_out, data_in, addr, c_data_out, c_data_out_1, c_data_out_2;
	wire [4:0] c_tag_out, c_tag_out_1, c_tag_out_2;
	wire [3:0] m_busy;
	wire write, read;
	wire c_valid_1, c_dirty_1, c_hit_1;
	wire c_valid_2, c_dirty_2, c_hit_2;
	wire idle, idle_next;
	wire read_int, write_int;

	assign idle = (state_int == 4'b0000);

	//assign read_int = (read&~read) ? 1'b0 : read;
	//assign write_int = (write&~write) ? 1'b0 : write;

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

	reg_16b reg_0 (.clk(clk),.rst(rst),.writeData(data_int),.readData(data_prev));
	
	//assign state_int = state;
	//DO WE NEED? assign next_state_int = next_state;
	//wire idle;
	//assign idle = (next_state_int == 16'd0) ? 1'b1 : 1'b0;
	
	// Holds state for state machine
	dff state_ff [3:0] (.q(state_int), .d(next_state_int), .clk(clk), .rst(rst));
	
	assign f_stall = (m_stall&~fs_cachehit) | ((write | read) & ~fs_done);
		
	wire curr_rand, rand, curr_c_sel, c_hit;
	wire fc_enable, fc_comp, fc_write, fc_valid_in;
	wire [2:0] fc_offset;
	wire [4:0] fc_tag_in;
	wire [7:0] fc_index;
	wire [15:0] fc_data_in;
	wire c_sel;

	dff victimway (.q(curr_rand), .d(rand), .clk(clk), .rst(rst));
	assign rand = ((read | write)&idle) ? ~curr_rand : curr_rand;
	
	// c_sel is 1, choose way 2
	assign c_err = c_sel ? c_err_2 : c_err_1;
	assign c_sel = (idle) ? (~c_valid_1 ? 1'b0 : 
			(c_valid_2 ? curr_rand : 1'b1) ) :
				// TODO: only for optimization
				// both are valid, cannot be both hit
				// both are valid, if one is hit, choose the one is hit
				// both are valid, if no hit
				// 							if both dirty, random
				// 							if one dirty, pick the other
				// 							if no dirty, whatever
				// (c_hit ? c_hit_2: rand) : 1'b1) :
				curr_c_sel;
	dff c_sel_f_2 (.q(curr_c_sel), .d(c_sel), .clk(clk), .rst(rst));

	// Did hit occur?	
	// // Which cache had hit (1 = way 2)
	// assign c_hit_way_num = c_hit & c_hit_2;
	// // If hit : pick correct data out. 
	
	// assign c_rep = c_hit ? c_hit_way_num : c_sel;	
	// assign c_tag_out = c_rep ? c_tag_out_2 : c_tag_out_1;
	// assign c_data_out = c_rep ? c_data_out_2 : c_data_out_1;
					
	// assign c_valid  = c_rep ? c_valid_2 : c_valid_1;
	// assign c_dirty = c_sel ? c_dirty_2 : c_dirty_1;
	
	wire c_hit_valid, c_hit_dirty, one_hit, both_hit;
	wire [15:0] c_return_data_out;
	assign one_hit = c_hit_1 ^ c_hit_2;
	assign both_hit = (c_hit_1 & c_hit_2) & (c_valid_2 | c_valid_1);
	// assume both hit, only one is valid
	assign hit_num = both_hit ? c_valid_2 :
						one_hit ? c_hit_2 : 1'b0;
	assign c_hit = one_hit | both_hit;
	
	assign c_valid  = c_hit ? c_hit_valid : 
							c_sel ? c_valid_2 : c_valid_1;
	assign c_dirty = c_hit ? c_hit_dirty : 
							c_sel ? c_valid_2 : c_valid_1;
	assign c_tag_out = c_sel ? c_tag_out_2 : c_tag_out_1;
	assign c_data_out = c_hit ? c_return_data_out :
								c_sel ? c_data_out_2 : c_data_out_1;
	
	assign c_hit_valid = (hit_num ? c_valid_2 : c_valid_1);
	assign c_hit_dirty = (hit_num ? c_dirty_2 : c_dirty_1);
	// assign c_return = c_hit & c_hit_valid;
	assign c_return_data_out = hit_num ? c_data_out_2 : c_data_out_1;
	// assign c_data_out = c_return ? c_return_data_out : 
	// 				c_rep ? c_data_out_2 : c_data_out_1;
	// assign c_valid = c_hit ? c_hit_valid : 
	// 					(c_sel ? c_valid_2 : c_valid_1);


	assign fc_data_in_1 = ~c_sel|idle ? fc_data_in: 16'b0;
	assign fc_index_1 = ~c_sel|idle ? fc_index: 8'b0;		
	assign fc_tag_in_1 = ~c_sel|idle ? fc_tag_in : 5'b0;		
	assign fc_offset_1 = ~c_sel|idle ? fc_offset : 3'b0;		
	assign fc_enable_1 = ~c_sel|idle ? fc_enable : 1'b0;		
	assign fc_comp_1 = ~c_sel|idle ?  fc_comp : 1'b0;		
	assign fc_write_1 = ~c_sel|idle ? fc_write : 1'b0;		
	assign fc_valid_in_1 = ~c_sel|idle ? fc_valid_in : 1'b1;	

	assign fc_data_in_2 = c_sel|idle ? fc_data_in : 16'b0;
	assign fc_index_2 = c_sel|idle ? fc_index : 16'b0;		
	assign fc_tag_in_2 = c_sel|idle ? fc_tag_in : 16'b0;		
	assign fc_offset_2 = c_sel|idle ? fc_offset : 16'b0;		
	assign fc_enable_2 = c_sel|idle ? fc_enable : 1'b0;		
	assign fc_comp_2 = c_sel|idle ? fc_comp : 1'b0;		
	assign fc_write_2 = c_sel|idle ? fc_write : 1'b0;		
	assign fc_valid_in_2 = c_sel|idle ? fc_valid_in : 1'b1;	

	//wire [15:0] addr_int, data_in_int, addr_int_int, data_in_int_int;

	//dff b_12 [15:0] (.d(addr), .clk(clk), .rst(rst), .q(addr_int));
	//dff b_13 [15:0] (.d(data_in), .clk(clk), .rst(rst), .q(data_in_int));

	//assign addr_int_int = (~read&~write) ? (addr) : addr_int;
	//assign data_in_int_int = (~read&~write) ? (data_in) : data_in_int;

	cache_fsm_wrapper fsm (
	                // Inputs
	                .addr(addr),.data_in(data_in),.read(read),.write(write),.rst(rst),
	                .c_tag_out(c_tag_out),.c_data_out(c_data_out),.c_hit(c_hit),.c_dirty(c_dirty),.c_valid(c_valid),.c_err(c_err),
	                .m_data_out(m_data_out),.m_busy(m_busy),.m_err(m_err),.state_int(state_int),.data_prev(data_prev),

	                // Outputs
	                .fc_enable(fc_enable),.fc_tag_in(fc_tag_in),.fc_index(fc_index),.fc_offset(fc_offset),.fc_data_in(fc_data_in),.fc_comp(fc_comp),.fc_write(fc_write),.fc_valid_in(fc_valid_in),
	                .fm_addr(fm_addr),.fm_data_in(fm_data_in),.fm_wr(fm_wr),.fm_rd(fm_rd),
	                .fs_data_out(fs_data_out),.fs_done(fs_done),.fs_cachehit(fs_cachehit),.fs_err(fs_err),.next_state_int(next_state_int),.data_int(data_int)
	        );

endmodule

