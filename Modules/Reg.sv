/*
Author: Ryan Pennell
*/
`ifndef _Reg_sv_
`define _Reg_sv_

module Reg #(
  parameter WIDTH = 8
)(
  out,
  in,
  clk,
  reset
);
  output reg [WIDTH-1:0] out;
  input wire [WIDTH-1:0] in;
  input wire clk, reset;

  always @ (posedge clk)
  begin
    if (reset)
      out = {WIDTH{1'b0}};
    else
      out = in;
  end
endmodule

`endif
