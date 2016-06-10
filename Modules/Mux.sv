/*
Author: Ryan Pennell
*/
`ifndef _Mux_sv_
`define _Mux_sv_

module Mux #(
  parameter CHANNELS = 2,
  parameter WIDTH = 1
)(
  out,
  in,
  sel,
  enable
);
  output wire [WIDTH-1:0] out;
  input wire [(WIDTH*CHANNELS)-1:0] in;
  input wire [ADDR_SIZE-1:0] sel;
  input wire enable;

  wire [WIDTH-1:0] in_e [CHANNELS-1:0];
  wire [CHANNELS-1:0] rotate [WIDTH-1:0];
  wire [CHANNELS-1:0] selected;

  parameter ADDR_SIZE = $clog2(CHANNELS);

  Decoder #(CHANNELS) dec (selected, sel, enable);

  genvar i, j;

  generate
  for (i = 0; i < CHANNELS; i = i + 1)
  begin : Enabling
    Enabler #(WIDTH, 0) en(
      in_e  [i],
      in    [(WIDTH*i) +: WIDTH],
      selected[i]
    );
  end
  endgenerate

  generate
  for (i = 0; i < CHANNELS; i = i + 1)
  begin : Rotation
    for (j = 0; j < WIDTH; j = j + 1)
    begin : RotationInner
      assign rotate[j][i] = in_e [i][j];
    end
  end
  endgenerate

  generate
  for (i = 0; i < WIDTH; i = i + 1)
  begin : OrReduction
    assign out[i] = (| rotate[i]);
  end
  endgenerate
endmodule

`endif
