module ForwardUnit(

  input logic [4:0] id_ex_dest_reg_idx,
  input logic [4:0] ex_mem_dest_reg_idx,

  input logic [4:0] if_id_rs1,
  input logic [4:0] if_id_rs2,

  input logic [31:0] ex_alu_result_out,
  input logic [31:0] mem_result_out,
  input logic [31:0] wb_reg_wr_data_out,

  input logic ex_mem_rd_mem,
  input logic id_ex_rd_mem,
  input logic [4:0]mem_wb_dest_reg_idx,

  input logic stall,

  output logic forward_rs1,
  output logic forward_rs2,

  output logic [31:0] forward_rega_out,
  output logic [31:0] forward_regb_out

);
 
  // Check for forwarding from EXstage

  assign forward_rs1_ex = !id_ex_rd_mem & (id_ex_dest_reg_idx != 0) & (id_ex_dest_reg_idx == if_id_rs1);
  assign forward_rs2_ex = !id_ex_rd_mem & (id_ex_dest_reg_idx != 0) & (id_ex_dest_reg_idx == if_id_rs2);

  // Check for forwarding from MEM stage
  assign forward_rs1_mem = !ex_mem_rd_mem & (ex_mem_dest_reg_idx != 0) & (ex_mem_dest_reg_idx == if_id_rs1) &!forward_rs1_ex;
  assign forward_rs2_mem = !ex_mem_rd_mem & (ex_mem_dest_reg_idx != 0) & (ex_mem_dest_reg_idx == if_id_rs2) &!forward_rs2_ex;

  // Check for forwarding from MEM stage
  assign forward_rs1_wb = (mem_wb_dest_reg_idx!=0) & (mem_wb_dest_reg_idx==if_id_rs1)&!forward_rs1_ex &!(!ex_mem_rd_mem & (ex_mem_dest_reg_idx != 0) & (ex_mem_dest_reg_idx == if_id_rs1));
  assign forward_rs2_wb = (mem_wb_dest_reg_idx!=0) & (mem_wb_dest_reg_idx==if_id_rs2)&!forward_rs2_ex &!(!ex_mem_rd_mem & (ex_mem_dest_reg_idx != 0) & (ex_mem_dest_reg_idx == if_id_rs2));


  assign forward_rs1=(forward_rs1_ex|forward_rs1_mem|forward_rs1_wb);
  assign forward_rs2=(forward_rs2_ex|forward_rs2_mem|forward_rs2_wb);

  always_comb begin


    if (forward_rs1_ex )
      forward_rega_out=ex_alu_result_out; // Forward from EX stage
    else if (forward_rs1_mem)
      forward_rega_out = mem_result_out; // Forward from MEM stage
    else if (forward_rs1_wb )
      forward_rega_out=wb_reg_wr_data_out;//FORWARD FROM WB STAGE
    else
      forward_rega_out=0;

    if (forward_rs2_ex )
      forward_regb_out=ex_alu_result_out; // Forward from EX stage
    else if (forward_rs2_mem)
      forward_regb_out = mem_result_out; // Forward from MEM stage
    else if (forward_rs2_wb )
      forward_regb_out=wb_reg_wr_data_out;//FORWARD FROM WB STAGE
    else
      forward_regb_out=0;

  end
endmodule