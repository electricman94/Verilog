/*
Author: Ryan Pennell
*/
`ifndef _InstructionFetch_sv_
`define _InstructionFetch_sv_

module InstructionFetch #(
  parameter PC_W = 32,
  parameter INST_W = 32,
  parameter INST_A = 8
)(
  PC,
  PCin,
  ctr_PC_src,
  ctr_nop,
  clk,
  reset,
  enable,

  instmem_export_out,
  instmem_export_data,
  instmem_export_address,
  instmem_export_MR,
  instmem_export_MW
);
  output wire [INST_W-1:0] instruction;
  output reg [PC_W-1:0] PC;
  input wire [PC_W-1:0] PCin;
  input wire clk, reset, enable, ctr_PC_src, ctr_nop;

  output wire [INST_W-1:0] instmem_export_out;
  input wire [INST_W-1:0] instmem_export_data;
  input wire [INST_A-1:0] instmem_export_address;
  input wire instmem_export_MR, instmem_export_MW;

  // Instruction Memory_________________________________________________________
  wire [INST_A-1:0] instmem_address;
  wire [INST_W-1:0] instmem_out;
  assign instmem_address = PC[INST_A+1:2];

  Memory #(INST_A, INST_W) inst_mem	(
    .out					(instmem_out),
    .data					({INST_W{1'b0}}),
    .address			(instmem_address),
    .MR						(1'b1),
    .MW						(1'b1),
    .clk					(clk),

    .exp					(enable),
    .exp_out			(instmem_export_out),
    .exp_data			(instmem_export_data),
    .exp_address	(instmem_export_address),
    .exp_MR				(instmem_export_MR),
    .exp_MW				(instmem_export_MW)
  );

  Reg #(32) instruction_r (instruction, instmem_out, clk, reset);

  // PC_________________________________________________________________________
  always @ (posedge clk)
  begin
    if (reset)
      PC = 32'd0;
    else if (enable)
    begin
      if (ctr_nop)
        PC = PC;
      else if (ctr_PC_src)
        PC = PCin;
      else
        PC = PC + 4;
    end
  end
endmodule

`endif
