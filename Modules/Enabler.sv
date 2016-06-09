/*
Author: Ryan Pennell
*/
`ifndef _Enabler_sv_
`define _Enabler_sv_

module Enabler #(
  parameter WIDTH = 8,
  parameter BUFFER = 0
)(
  out,
  in,
  enable
);
  output wire [WIDTH-1:0] out;
  input wire [WIDTH-1:0] in;
  input wire enable;

  generate
  if (BUFFER)
  begin : buffer
    wire en_buf;
    buf(en_buf, enable);
  end
  endgenerate

  genvar i;
  generate
  for (i = 0; i < WIDTH; i = i + 1)
  begin : AndGates
    and A(out[i], in[i], ((BUFFER) ? buffer.en_buf : enable));
  end
  endgenerate
endmodule

`endif
