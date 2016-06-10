/*
Author: Ryan Pennell
*/
`ifndef _Adder_sv_
`define _Adder_sv_

module Adder #(
  parameter WIDTH = 32
)(
  out,
  A,
  B,
  enable
);
  output wire [WIDTH-1:0] out;
  input wire [WIDTH-1:0] A, B;
  input wire enable;

  assign out = (enable) ? A + B : {WIDTH{1'b0}};
endmodule

`endif
