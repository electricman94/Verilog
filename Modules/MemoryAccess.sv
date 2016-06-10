/*
Author: Ryan Pennell
*/
`ifndef _MemoryAccess_sv_
`define _MemoryAccess_sv_

module MemoryAccess #(
  parameter DATA_W = 16,
  parameter DATA_A = 11
)(
  data_out,
  datamem_data,
  datamem_address,
  ctr_datamem_MR,
  ctr_datamem_MW,
  clk,
  reset,
  enable,
  datamem_export_out,
  datamem_export_data,
  datamem_export_address,
  datamem_export_MR,
  datamem_export_MW
);

  output wire [31:0] data_out;
  output wire [DATA_W-1:0] datamem_export_out;
  input wire [DATA_W-1:0] datamem_data, datamem_export_data;
  input wire [DATA_A-1:0] datamem_address, datamem_export_address;
  input wire ctr_datamem_MR, ctr_datamem_MW, datamem_export_MR, datamem_export_MW;
  input wire clk, enable, reset;

  // Data Memory Buffer Reg_____________________________________________________
  wire [31:0] after_ext;

  SignExtension #(32, 16) datamem_ext (after_ext, datamem_out);
  Reg #(32) memReg (data_out, after_ext, clk, reset);

  // Data Memory________________________________________________________________
  wire [DATA_W-1:0] datamem_out;

  Memory #(DATA_A, DATA_W) data_mem	(
    .out					(datamem_out),
    .data					(datamem_data),
    .address			(datamem_address),
    .MR						(ctr_datamem_MR),
    .MW						(ctr_datamem_MW),
    .clk					(clk),
    .exp          (enable),
    .exp_out			(datamem_export_out),
    .exp_data			(datamem_export_data),
    .exp_address	(datamem_export_address),
    .exp_MR				(datamem_export_MR),
    .exp_MW				(datamem_export_MW)
  );
endmodule

`endif
