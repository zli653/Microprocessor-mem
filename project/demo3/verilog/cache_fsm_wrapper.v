module cache_fsm_wrapper(
		// Inputs
		addr,data_in,read,write,rst,
		c_tag_out,c_data_out,c_hit,c_dirty,c_valid,c_err,
		m_data_out,m_busy,m_err,state_int,data_prev,

		// Outputs	
		fc_enable,fc_tag_in,fc_index,fc_offset,fc_data_in,fc_comp,fc_write,fc_valid_in,
		fm_addr,fm_data_in,fm_wr,fm_rd,
		fs_data_out,fs_done,fs_cachehit,fs_err,next_state_int,data_int
	);

	//initial begin
	//	 $monitor("err=%d values = %d%d%d \n", fs_err, c_hit, c_valid, c_dirty );
	//end
	
	// Inputs
	input [15:0] addr,data_in,c_data_out,m_data_out;
	input [4:0] c_tag_out;
	input [3:0] m_busy;
	input c_hit,c_dirty,c_valid,c_err,m_err,read,write,rst;
		
	// Outputs	
	output reg [15:0] fm_addr,fm_data_in,fs_data_out,fc_data_in;
	output reg [7:0] fc_index;
	output reg [4:0] fc_tag_in;
	output reg [2:0] fc_offset;
	output reg fc_enable,fc_comp,fc_write,fc_valid_in,fm_wr,fm_rd,fs_done,fs_cachehit;

	// Outputs not in case statement
	output fs_err;
	
	// Internal regs and wires
	reg [2:0] read_offset;
	reg [3:0] state,next_state;
	input [3:0] state_int;
	output [3:0] next_state_int;
	reg f_err;

	//Intermediate
	input [15:0] data_prev;
	output [15:0] data_int;
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
	* 	ACC_WRITE :     1110
	*/

        assign data_int = write ? data_in : 
			  ~read ? 16'd0 :
			  ({addr[2:1],1'b1} == read_offset) ? m_data_out :
			  data_prev;

	//assign state_int = state;
	assign next_state_int = next_state;
	
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
		fs_cachehit	= 1'b0;
		fs_data_out	= 16'd0;
		f_err		= 1'b0;
		read_offset 	= 3'b000;
		
		state = state_int;	
		next_state = state;
		case(state)
			4'b0000://IDLE
			begin
				next_state = ({write, read} == 2'b10) ? 4'b0001
					: ({write, read} == 2'b01) ? 4'b0010 
					: 4'b0000;

				fc_comp = ({write, read} == 2'b00) ? 1'b0 : 1'b1;
				fc_write = ({write, read} == 2'b10) ? 1'b1 : 1'b0;
				fc_enable = 1'b1;
				fc_offset = addr[2:0];
				fc_index = addr[10:3];
				fc_tag_in = addr[15:11];
				fc_data_in = ({write, read} == 2'b10) ? data_in : 16'd0;
				f_err = read & write;
			end

			4'b0001://COMP_WRITE
			begin
				next_state = ({c_hit, c_valid, c_dirty} == 3'b010) ? 4'b1000
					: ({c_hit, c_valid, c_dirty} == 3'b011) ? 4'b0011
					: ({c_hit, c_valid} == 2'b11) ? 4'b0000
					: (c_valid == 1'b0) ? 4'b1000 
					: state;	
				fs_done = ({c_hit, c_valid} == 2'b11) ? 1'b1 : 1'b0;
				fs_cachehit = ({c_hit, c_valid} == 2'b11) ? 1'b1 : 1'b0;
				fs_data_out = ({c_hit, c_valid} == 2'b11) ? data_in : 16'd0;
				fm_rd = ((c_valid == 1'b0) | ({c_hit, c_valid, c_dirty} == 3'b010)) ? 1'b1 : 1'b0;
				fm_addr = ((c_valid == 1'b0) | ({c_hit, c_valid, c_dirty} == 3'b010)) ? {addr[15:3], 3'b000}  : 16'd0;
				
				// Read from cache word 0
				fc_enable = ({c_hit, c_valid, c_dirty} == 3'b011) ? 1'b1 : 1'b0;
				fc_tag_in = ({c_hit, c_valid, c_dirty} == 3'b011) ? c_tag_out : 3'd0;
				fc_index = ({c_hit, c_valid, c_dirty} == 3'b011) ? addr[10:3] : 8'd0;
			end	

			4'b1000: // MEM_ACC_1
			begin
				fm_wr = 1'b0;
				fm_rd = 1'b1;
				
				next_state = (m_busy[0]) ? 4'b1000 : 4'b1001;
				fm_addr = (m_busy[0]) ? {addr[15:3], 3'b000} : {addr[15:3], 3'b010};
			end

			4'b1001://MEM_ACC_2
			begin
				fm_wr = 1'b0;
				fm_rd = 1'b1;
				
				next_state = (m_busy[1]) ? 4'b1001 : 4'b1010;
				fm_addr = (m_busy[1]) ? {addr[15:3], 3'b010} : {addr[15:3], 3'b100};
			end

			4'b1010://MEM_ACC_3
			begin
				fm_wr = 1'b0;
				fm_rd = 1'b1;
				
				next_state = (m_busy[2]) ? 4'b1010 : 4'b1011;
				fm_addr = (m_busy[2]) ? {addr[15:3], 3'b100} : {addr[15:3], 3'b110};
				
				fc_enable = (m_busy[2]) ? 1'b0 : 1'b1;
				fc_write = (m_busy[2]) ? 1'b0 : 1'b1;
				fc_tag_in = (m_busy[2]) ? 5'd0 : addr[15:11];
				fc_index = (m_busy[2]) ? 8'd0 : addr[10:3];
				fc_data_in = (m_busy[2]) ? 16'd0 : m_data_out;//writing word 0 in cache
				read_offset = (m_busy[2]) ? 3'b000 : 3'b001;
			end

			4'b1011://MEM_ACC_4
			begin
				fm_rd = (m_busy[3]) ? 1'b1 : 1'b0;
				
				next_state = (m_busy[3]) ? 4'b1011 : 4'b1100;
				fm_addr = (m_busy[3]) ? {addr[15:3], 3'b110} : 16'd0;
				
				fc_enable = 1'b1;
				fc_write = 1'b1;
				fc_tag_in = addr[15:11];
				fc_index = addr[10:3];
				fc_offset = (m_busy[3]) ? 3'b000 : 3'b010;
				fc_data_in = m_data_out;//writing word in cache
				read_offset = (m_busy[3]) ? 3'b001 : 3'b011;
			end

			4'b1100://MEM_ACC_5
			begin
				next_state = 4'b1101;//MEM_ACC_6
				fc_enable = 1'b1;
				fc_write = 1'b1;
				fc_offset = 3'b100;
				fc_tag_in = addr[15:11];
				fc_index = addr[10:3];
				fc_data_in = m_data_out; //writing word 2 in cache
				read_offset = 3'b101;

			end
			
			4'b1101://MEM_ACC_6
			begin
				fc_enable = 1'b1;
				fc_write = 1'b1;
				fc_offset = 3'b110;
				fc_tag_in = addr[15:11];
				fc_index = addr[10:3];
				fc_data_in = m_data_out; //writing word 3 in cache
				read_offset = 3'b111;
				
				fs_done = (write) ? 1'b0 : 1'b1;
				next_state = (write) ? 4'b1110 : 4'b0000;
				fs_data_out = (write) ? 16'd0 : data_int;
			end


			4'b0010://COMP_READ
			begin
				next_state = ({c_hit, c_valid, c_dirty} == 3'b010) ? 4'b1000
					: ({c_hit, c_valid, c_dirty} == 3'b011) ? 4'b0011
					: ({c_hit, c_valid} == 2'b11) ? 4'b0000
					: (c_valid == 1'b0) ? 4'b1000 
					: state;	
				fs_done = ({c_hit, c_valid} == 2'b11) ? 1'b1 : 1'b0;
				fs_cachehit = ({c_hit, c_valid} == 2'b11) ? 1'b1 : 1'b0;
				fs_data_out = ({c_hit, c_valid} == 2'b11) ? c_data_out : 16'd0;
				fm_rd = ((c_valid == 1'b0) | ({c_hit, c_valid, c_dirty} == 3'b010)) ? 1'b1 : 1'b0;
				fm_addr = ((c_valid == 1'b0) | ({c_hit, c_valid, c_dirty} == 3'b010)) ? {addr[15:3], 3'b000}  : 16'd0;
				
				// Read from cache word 0
				fc_enable = ({c_hit, c_valid, c_dirty} == 3'b011) ? 1'b1 : 1'b0;
				fc_tag_in = ({c_hit, c_valid, c_dirty} == 3'b011) ? c_tag_out : 3'd0;
				fc_index = ({c_hit, c_valid, c_dirty} == 3'b011) ? addr[10:3] : 8'd0;
			end

			4'b0011: // EVICT_1
			begin
				next_state = 4'b0100; // EVICT_2
				fc_enable = 1'b1;
				fc_index = addr[10:3];
				fc_tag_in = c_tag_out;
				fc_offset = 3'b010; // Read word 1
				
				// Write to mem
				fm_wr = 1'b1;
				fm_rd = 1'b0;
				fm_addr = {c_tag_out, addr[10:3], 3'b000}; // bank 0
				fm_data_in = c_data_out;
			end


			4'b0100: // EVICT_2
			begin
				next_state = m_busy[0] ? 4'b0100 : 4'b0101;
				fc_enable = 1'b1;
				fc_index = addr[10:3];
				fc_tag_in = c_tag_out;
				fc_offset = m_busy[0] ? 3'b010 : 3'b100;
				
				fm_wr = 1'b1;
				fm_rd = 1'b0;
				fm_addr = m_busy[0] ?  {c_tag_out, addr[10:3], 3'b000} :  // bank 0
					{c_tag_out, addr[10:3], 3'b010}; // bank 1
				fm_data_in = c_data_out;
			end	
			
			4'b0101: // EVICT_3
			begin
				next_state = (m_busy[1]) ? 4'b0101 : 4'b0110;
				fc_enable = 1'b1;
				fc_index = addr[10:3];
				fc_tag_in = c_tag_out;
				fc_offset = (m_busy[1]) ? 3'b100 : 3'b110; 
				
				// Write to mem
				fm_wr = 1'b1;
				fm_addr = (m_busy[1]) ? {c_tag_out, addr[10:3], 3'b010} : {c_tag_out, addr[10:3], 3'b100}; 
				fm_data_in = c_data_out;
			end

			4'b0110: // EVICT_4
			begin
				next_state = (m_busy[2]) ? 4'b0110 : 4'b0111;
				fc_enable = (m_busy[2]) ? 1'b1 : 1'b0;
				fc_index = (m_busy[2]) ? addr[10:3] : 8'd0;
				fc_tag_in = (m_busy[2]) ? c_tag_out : 5'd0;
				fc_offset = (m_busy[2]) ? 3'b110 : 3'b000; 
				
				// Write to mem
				fm_wr = 1'b1;
				fm_addr = (m_busy[2]) ? {c_tag_out, addr[10:3], 3'b100} : {c_tag_out, addr[10:3], 3'b110}; 
				fm_data_in = c_data_out;
			end

			4'b0111: // EVICT_5
			begin
				next_state = (m_busy[3]) ? 4'b0111 : 4'b1000;
				fm_wr = (m_busy[3]) ? 1'b1 : 1'b0;
				fm_rd = (m_busy[3]) ? 1'b0 : 1'b1;
				fm_addr = (m_busy[3]) ? {c_tag_out, addr[10:3], 3'b110} : {addr[15:3], 3'b000};
				fm_data_in = (m_busy[3]) ? c_data_out : 16'd0;
			end

			4'b1110: // ACC_WRITE
			begin
				next_state = 4'b0000;
				fc_comp = 1'b1;
				fc_write = 1'b1;
				fc_enable = 1'b1;
				fc_offset = addr[2:0];
				fc_index = addr[10:3];
				fc_tag_in = addr[15:11];
				fc_data_in = data_in;
				fs_done = 1'b1;
				fs_data_out = data_in;
			end	


			default://DEFAULT to IDLE (Never reached)
			begin
				f_err = 1'b1;
			end
		endcase
	end	
endmodule

