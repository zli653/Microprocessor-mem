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
	wire [3:0] state,next_state;

	/*
	* _______STATE_KEY______
	*
	* 	IDLE : 00000
	* 	
	* 	
	*/


	// Holds state for state machine
	dff state_ff [3:0] (.q(next_state), .d(state), .clk(clk), .rst(rst));

	assign fs_err = c_err | m_err;

	always@(*) begin
		case(state)

	end	
endmodule

