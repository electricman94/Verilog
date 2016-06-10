/*
Author: Ryan Pennell
*/
`ifndef _SignExtension_sv_
`define _SignExtension_sv_

module SignExtension #(
  parameter OUT = 32,
  parameter IN = 16
)(
  out,
  in
);
  output wire [OUT-1:0] out;
  input  wire [IN-1:0]  in;

  assign out = {{(OUT-IN){in[IN-1]}}, in};

endmodule

`endif
