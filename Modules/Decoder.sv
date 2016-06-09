/*
Author: Ryan Pennell
*/
`ifndef _Decoder_sv_
`define _Decoder_sv_

module Decoder #(
  parameter WIDTH = 16
)(
  out,
  sel,
  enable
);
  output wire [WIDTH-1:0] out;
  input wire [ADDR_SIZE-1:0] sel;
  input wire enable;

  wire [ADDR_SIZE-1:0] code_h, code_l;

  parameter ADDR_SIZE = $clog2(WIDTH);

  genvar i;
  //
  // generate
  // for (i = 0; i < ADDR_SIZE; i = i + 1)
  // begin : Buffers
  //   buf (code_h[i], sel[i]);
  //   not (code_l[i], sel[i]);
  // end
  // endgenerate

  generate
  for (i = 0; i < WIDTH; i = i + 1)
  begin : Gates
    assign out[i] = enable & (& (sel[ADDR_SIZE-1:0] ~^ i[ADDR_SIZE-1:0]));
  end
  endgenerate

endmodule

`endif
