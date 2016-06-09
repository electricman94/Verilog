/*
Author: Ryan Pennell
*/
`ifndef _ALU_sv_
`define _ALU_sv_

module ALU #(
  parameter WIDTH = 32,
  parameter FUNCTION = 6
)(
  out,
  flags,
  A,
  B,
  funct,
  enable
);
  output wire [WIDTH-1:0] out;
  output wire [3:0] flags; //0 = zero, 1 = carry, 2 = negative, 3 = overflow
  input wire [WIDTH-1:0] A, B;
  input wire [FUNCTION-1:0] funct;
  input wire enable;

  parameter ADDR_SIZE = $clog2(WIDTH);

  assign out = (enable && (funct == 0)) ? 32'd0 : 32'bz;
  assign out = (enable && (funct == 1)) ? A + B : 32'bz;
  assign out = (enable && (funct == 2)) ? A - B : 32'bz;
  assign out = (enable && (funct == 3)) ? A & B : 32'bz;
  assign out = (enable && (funct == 4)) ? A | B : 32'bz;
  assign out = (enable && (funct == 5)) ? A - B : 32'bz;
  assign out = (enable && (funct == 6)) ? ((A < B) ? 1'b1 : 1'b0) : 32'bz;
  assign out = (enable && (funct == 7)) ? A << (B[4:0]) : 32'bz;

endmodule

`endif
