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
wire [4:0] c_tag_out_1;
wire [15:0] c_data_out_1;
wire c_hit_1;
wire c_dirty_1;
wire c_valid_1;
wire c_err_1;

wire [4:0] c_tag_out_2;
wire [15:0] c_data_out_2;
wire c_hit_2;
wire c_dirty_2;
wire c_valid_2;
wire c_err_2;

// Mem outputs
wire [15:0] m_data_out;
wire [3:0] m_busy;
wire m_err;

// Cache inputs
wire fc_enable_1;
wire [4:0] fc_tag_in_1;
wire [7:0] fc_index_1;
wire [2:0] fc_offset_1;
wire [15:0] fc_data_in_1;
wire fc_comp_1;
wire fc_write_1;
wire fc_valid_in_1;

wire fc_enable_2;
wire [4:0] fc_tag_in_2;
wire [7:0] fc_index_2;
wire [2:0] fc_offset_2;
wire [15:0] fc_data_in_2;
wire fc_comp_2;
wire fc_write_2;
wire fc_valid_in_2;

// Mem inputs
wire [15:0] fm_addr;
wire [15:0] fm_data_in;
wire fm_wr;
wire fm_rd;
wire m_stall;

  /* data_mem = 1, inst_mem = 0 *
  * needed for cache parameter */
  parameter memtype = 0;
  cache #(0 + memtype) c0(// Outputs
        .tag_out              (c_tag_out_1),
        .data_out             (c_data_out_1),
        .hit                  (c_hit_1),
        .dirty                (c_dirty_1),
        .valid                (c_valid_1),
        .err                  (c_err_1),
        // Inputs
        .enable               (fc_enable_1),
        .clk                  (clk),
        .rst                  (rst),
        .createdump           (createdump),
        .tag_in               (fc_tag_in_1),
        .index                (fc_index_1),
        .offset               (fc_offset_1),
        .data_in              (fc_data_in_1),
        .comp                 (fc_comp_1),
        .write                (fc_write_1),
        .valid_in             (fc_valid_in_1));
  cache #(2 + memtype) c1(// Outputs
        .tag_out              (c_tag_out_2),
        .data_out             (c_data_out_2),
        .hit                  (c_hit_2),
        .dirty                (c_dirty_2),
        .valid                (c_valid_2),
        .err                  (c_err_2),
        // Inputs
        .enable               (fc_enable_2),
        .clk                  (clk),
        .rst                  (rst),
        .createdump           (createdump),
        .tag_in               (fc_tag_in_2),
        .index                (fc_index_2),
        .offset               (fc_offset_2),
        .data_in              (fc_data_in_2),
        .comp                 (fc_comp_2),
        .write                (fc_write_2),
        .valid_in             (fc_valid_in_2));

  four_bank_mem mem(// Outputs
    .data_out          (m_data_out),
    .stall             (m_stall),
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
   
   // your code here
  cache_fsm fsm(
    // Inputs
    .addr(Addr),.data_in(DataIn),.read(Rd),.write(Wr),.clk(clk),.rst(rst),
    .c_tag_out_1(c_tag_out_1),.c_data_out_1(c_data_out_1),.c_hit_1(c_hit_1),.c_dirty_1(c_dirty_1),.c_valid_1(c_valid_1),.c_err_1(c_err_1),
    .c_tag_out_2(c_tag_out_2),.c_data_out_2(c_data_out_2),.c_hit_2(c_hit_2),.c_dirty_2(c_dirty_2),.c_valid_2(c_valid_2),.c_err_2(c_err_2),
    .m_data_out(m_data_out),.m_busy(m_busy),.m_err(m_err),.m_stall(m_stall),

    // Outputs  
    .fc_enable_1(fc_enable_1),.fc_tag_in_1(fc_tag_in_1),.fc_index_1(fc_index_1),.fc_offset_1(fc_offset_1),
    .fc_data_in_1(fc_data_in_1),.fc_comp_1(fc_comp_1),.fc_write_1(fc_write_1),.fc_valid_in_1(fc_valid_in_1),
    .fc_enable_2(fc_enable_2),.fc_tag_in_2(fc_tag_in_2),.fc_index_2(fc_index_2),.fc_offset_2(fc_offset_2),
    .fc_data_in_2(fc_data_in_2),.fc_comp_2(fc_comp_2),.fc_write_2(fc_write_2),.fc_valid_in_2(fc_valid_in_2),
    .fm_addr(fm_addr),.fm_data_in(fm_data_in),.fm_wr(fm_wr),.fm_rd(fm_rd),
    .fs_data_out(DataOut),.fs_done(Done),.fs_cachehit(CacheHit),.fs_err(err),.f_stall(Stall)
  );
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
