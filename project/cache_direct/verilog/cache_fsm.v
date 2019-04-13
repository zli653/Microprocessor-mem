module cache_fsm(
		// Inputs
		addr,data_in,read,write,clk,rst,
		c_tag_out,c_data_out,c_hit,c_dirty,c_valid,c_err,
		m_data_out,m_busy,m_err,

		// Outputs	
		fc_enable,fc_tag_in,fc_index,fc_offset,fc_data_in,fc_comp,fc_write,fc_valid_in,
		fm_addr,fm_data_in,fm_wr,fm_rd,
		fs_data_out,fs_done,fs_cachehit,fs_err
	);
	
	// Inputs
	input [15:0] addr,data_in,c_data_out,m_data_out;
	input [4:0] c_tag_out;
	input [3:0] m_busy;
	input c_hit,c_dirty,c_valid,c_err,m_err,read,write,clk,rst;
		
	// Outputs	
	output [15:0] fm_addr,fm_data_in,fs_data_out,fc_data_in;
	output [7:0] fc_index;
	output [4:0] fc_tag_in;
	output [2:0] fc_offset;
	output fc_enable,fc_comp,fc_write,fc_valid_in,fm_wr,fm_rd,fs_done,fs_cachehit;

	// Outputs not in case statement
	output fs_err;
	
	// Internal regs and wires
	//wire [1:0] read_offset;
	//wire [3:0] state,next_state;
	wire [3:0] state_int, next_state_int;

	//Intermediate
	wire [15:0] data_int, data_prev, curr_m_data_out, curr_c_data_out, curr_data_in, curr_addr;
	wire [4:0] curr_c_tag_out;
	wire [3:0] curr_m_busy;
	wire curr_write, curr_read, curr_c_valid, curr_c_dirty, curr_c_hit;

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
	dff write_ff (.q(curr_write), .d(write), .clk(clk), .rst(rst));	
	dff read_ff (.q(curr_read), .d(read), .clk(clk), .rst(rst));
	dff addr_f [15:0] (.q(curr_addr), .d(addr), .clk(clk), .rst(rst));
	dff data_in_f [15:0] (.q(curr_data_in), .d(data_in), .clk(clk), .rst(rst));
	dff c_data_out_f [15:0] (.q(curr_c_data_out), .d(c_data_out), .clk(clk), .rst(rst));
	dff m_data_out_f [15:0] (.q(curr_m_data_out), .d(m_data_out), .clk(clk), .rst(rst));
	dff c_tag_out_f [4:0] (.q(curr_c_tag_out), .d(c_tag_out), .clk(clk), .rst(rst));
	dff m_busy_f [3:0] (.q(curr_m_busy), .d(m_busy), .clk(clk), .rst(rst));
	dff c_hit_f (.q(curr_c_hit), .d(c_hit), .clk(clk), .rst(rst));
	dff c_dirty_f (.q(curr_c_dirty), .d(c_dirty), .clk(clk), .rst(rst));
	dff c_valid_f (.q(curr_c_valid), .d(c_valid), .clk(clk), .rst(rst));

		
	
	cache_fsm_wrapper fsm (
                // Inputs
                .addr(curr_addr),.data_in(curr_data_in),.read(curr_read),.write(curr_write),.rst(rst),
                .c_tag_out(curr_c_tag_out),.c_data_out(curr_c_data_out),.c_hit(curr_c_hit),.c_dirty(curr_c_dirty),.c_valid(curr_c_valid),.c_err(c_err),
                .m_data_out(curr_m_data_out),.m_busy(curr_m_busy),.m_err(m_err),.state_int(state_int),.data_prev(data_prev),

                // Outputs
                .fc_enable(fc_enable),.fc_tag_in(fc_tag_in),.fc_index(fc_index),.fc_offset(fc_offset),.fc_data_in(fc_data_in),.fc_comp(fc_comp),.fc_write(fc_write),.fc_valid_in(fc_valid_in),
                .fm_addr(fm_addr),.fm_data_in(fm_data_in),.fm_wr(fm_wr),.fm_rd(fm_rd),
                .fs_data_out(fs_data_out),.fs_done(fs_done),.fs_cachehit(fs_cachehit),.fs_err(fs_err),.next_state_int(next_state_int),.data_int(data_int)
        );

endmodule

