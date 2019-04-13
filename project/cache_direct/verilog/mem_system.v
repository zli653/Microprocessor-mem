/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
	// Outputs
	DataOut, Done, Stall, CacheHit, err,
	// Inputs
	Addr, DataIn, Rd, Wr, createdump, clk, rst
	);

	input [15:0] Addr;
	input [15:0] DataIn;
	input        Rd;
	input        Wr;
	input        createdump;
	input        clk;
	input        rst;

	output [15:0] DataOut;
	output Done;
	output Stall;
	output CacheHit;
	output err;

	// Cache outputs
	wire [4:0] c_tag_out;
	wire [15:0] c_data_out;
	wire c_hit;
	wire c_dirty;
	wire c_valid;
	wire c_err;
	
	// Mem outputs
	wire [15:0] m_data_out;
	wire m_stall;
	wire [3:0] m_busy;
	wire m_err;

	/* data_mem = 1, inst_mem = 0 *
	* needed for cache parameter */
	parameter memtype = 0;
	cache #(0 + memtype) c0(// Outputs
		.tag_out              (c_tag_out),
		.data_out             (c_data_out),
		.hit                  (c_hit),
		.dirty                (c_dirty),
		.valid                (c_valid),
		.err                  (c_err),
		// Inputs
		.enable               (fc_enable),
		.clk                  (clk),
		.rst                  (rst),
		.createdump           (createdump),
		.tag_in               (fc_tag_in),
		.index                (fc_index),
		.offset               (fc_offset),
		.data_in              (fc_data_in),
		.comp                 (fc_comp),
		.write                (fc_write),
		.valid_in             (fc_valid_in));

	four_bank_mem mem(// Outputs
		.data_out          (m_data_out),
		.stall             (Stall),
		.busy              (m_busy),
		.err               (m_err),
		// Inputs
		.clk               (clk),
		.rst               (rst),
		.createdump        (createdump),
		.addr              (fm_addr),
		.data_in           (fm_data_in),
		.wr                (fm_wr),
		.rd                (fm_rd));


	cache_fsm fsm(
		// Inputs
		.addr(Addr),.data_in(DataIn),.read(Rd),.write(Wr),.clk(clk),.rst(rst),
		.c_tag_out(c_tag_out),.c_data_out(c_data_out),.c_hit(c_hit),.c_dirty(c_dirty),.c_valid(c_valid),.c_err(c_err),
		.m_data_out(m_data_out),.m_stall(m_stall),.m_busy(m_busy),.m_err(m_err),

		// Outputs	
   		.fc_enable(fc_enable),.fc_tag_in(fc_tag_in),.fc_index(fc_index),.fc_offset(fc_offset),.fc_data_in(fc_data_in),.fc_comp(fc_comp),.fc_write(fc_write),.fc_valid_in(fc_valid_in),
		.fm_addr(fm_addr),.fm_data_in(fm_data_in),.fm_wr(fm_wr),.fm_rd(fm_rd),
		.fs_data_out(DataOut),.fs_done(Done),.fs_cachehit(CacheHit),.fs_err(err)
	);

endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
