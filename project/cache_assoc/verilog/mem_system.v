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
    .c_tag_out(c_tag_out),.c_data_out(c_data_out),.c_hit(c_hit),.c_dirty(c_dirty),.c_valid(c_valid),.c_err(c_err),
    .m_data_out(m_data_out),.m_busy(m_busy),.m_err(m_err),.m_stall(m_stall),

    // Outputs  
    .fc_enable(fc_enable),.fc_tag_in(fc_tag_in),.fc_index(fc_index),.fc_offset(fc_offset),.fc_data_in(fc_data_in),.fc_comp(fc_comp),.fc_write(fc_write),.fc_valid_in(fc_valid_in),
    .fm_addr(fm_addr),.fm_data_in(fm_data_in),.fm_wr(fm_wr),.fm_rd(fm_rd),
    .fs_data_out(DataOut),.fs_done(Done),.fs_cachehit(CacheHit),.fs_err(err),.f_stall(Stall)
  );
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
