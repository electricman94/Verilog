/*
Author: Ryan Pennell
*/
`ifndef _Regfile_sv_
`define _Regfile_sv_

module Regfile (
  reg1,
  reg2,
  r1sel,
  r2sel,
  wsel,
  data,
  we,
  clk,
  reset
);
  output wire [31:0] reg1, reg2;
  input wire [4:0] r1sel, r2sel, wsel;
  input wire [31:0] data;
  input wire we, clk, reset;

  reg [1023:0] file;

  assign reg1 = file[(32*r1sel) +: 31];
  assign reg2 = file[(32*r2sel) +: 31];

  always @ (posedge clk)
  begin
    if (we & (wsel != 5'd0))
      file[(32*wsel)+31 -: 31] = data;
    if (reset)
      file = {1024{1'b0}};
  end

  //for convenience
  wire [31:0] zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7;
  wire [31:0] s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra;
  assign zero = file [(32 * 0) +: 32];
  assign at = file [(32 *  1) +: 32];
  assign v0 = file [(32 *  2) +: 32];
  assign v1 = file [(32 *  3) +: 32];
  assign a0 = file [(32 *  4) +: 32];
  assign a1 = file [(32 *  5) +: 32];
  assign a2 = file [(32 *  6) +: 32];
  assign a3 = file [(32 *  7) +: 32];
  assign t0 = file [(32 *  8) +: 32];
  assign t1 = file [(32 *  9) +: 32];
  assign t2 = file [(32 *  10) +: 32];
  assign t3 = file [(32 *  11) +: 32];
  assign t4 = file [(32 *  12) +: 32];
  assign t5 = file [(32 *  13) +: 32];
  assign t6 = file [(32 *  14) +: 32];
  assign t7 = file [(32 *  15) +: 32];
  assign s0 = file [(32 *  16) +: 32];
  assign s1 = file [(32 *  17) +: 32];
  assign s2 = file [(32 *  18) +: 32];
  assign s3 = file [(32 *  19) +: 32];
  assign s4 = file [(32 *  20) +: 32];
  assign s5 = file [(32 *  21) +: 32];
  assign s6 = file [(32 *  22) +: 32];
  assign s7 = file [(32 *  23) +: 32];
  assign t8 = file [(32 *  24) +: 32];
  assign t9 = file [(32 *  25) +: 32];
  assign k0 = file [(32 *  26) +: 32];
  assign k1 = file [(32 *  27) +: 32];
  assign gp = file [(32 *  28) +: 32];
  assign sp = file [(32 *  29) +: 32];
  assign fp = file [(32 *  30) +: 32];
  assign ra = file [(32 *  31) +: 32];
endmodule

`endif
