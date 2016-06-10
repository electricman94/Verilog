/*
Author: Ryan Pennell
*/
`ifndef _Execute_sv_
`define _Execute_sv_

module Execute (
  branch_out,
  flags,
  alu,
  reg2_out,
  PC_next,
  wsel,
  reg1,
  reg2,
  ext_immediate,
  funct,
  rt,
  rd,
  ctr_reg_dest,
  ctr_alu_op,
  ctr_alu_src,
  clk,
  reset
);
  output wire [31:0] branch_out, alu, reg2_out;
  output wire [3:0] flags;
  output wire [4:0] wsel;
  input wire [31:0] PC_next, reg1, reg2, ext_immediate;
  input wire [5:0] funct;
  input wire [4:0] rt, rd;
  input wire ctr_reg_dest, ctr_alu_op, ctr_alu_src, clk, reset;

  // Branch Modules_____________________________________________________________
  wire [31:0] branch_dest;
  Adder PC_brancher(
		.out      (branch_dest),
		.A		    (PC_next),
		.B		    ({ext_immediate[31:2], 2'd0}),
		.enable	  (1'b1)
	);

  Reg #(32) PC_branch_r (branch_out, branch_dest, clk, reset);

  // ALU________________________________________________________________________
  wire [31:0] alu_next, alu_in;
  wire [3:0] flags_next; //overflow, carryout, negative, zero
  wire [2:0] ctr;
  ALU ALUvera ( //for that mathematical burn!!!
    alu_next,
    flags_next,
    reg1,
    alu_in,
    ctr
  );
  ALUcontrol ALUlimit(
    ctr,
    funct,
    ctr_alu_op
  );

  Reg #(32) reg2_r (reg2_out, reg2,       clk, reset);
  Reg #(32) alu_r  (alu,      alu_next,   clk, reset);
  Reg #( 4) flag_r (flags,    flags_next, clk, reset);

  Mux #(2, 32) alu_mux (
		.out		(alu_in),
	  .in			({ext_immediate, reg2}),
	  .sel		(ctr_alu_src)
	);

  // Destination Select_________________________________________________________
  wire [4:0] wsel_next;
  Mux #(2, 5) wsel_mux (
		.out		(wsel_next),
	  .in			({rd, rt}),
	  .sel		(ctr_reg_dest)
	);

  Reg #(5) wsel_r (wsel, wsel_next, clk, reset);

endmodule

`endif
