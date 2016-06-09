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
    assign out[i] = enable & (& (sel[ADDR_SIZE-1:0] ^ i[ADDR_SIZE-1:0]));
  end
  endgenerate

endmodule

//Testbench
module Decoder_tb #(
  parameter WIDTH = 16,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
  reg [$clog2(WIDTH)-1:0] sel;
  wire [WIDTH-1:0] out;

	Decoder #(WIDTH) dut (
    .out										    (out),
    .sel										    (sel),
		.enable											(enable)
  );

  initial
  begin
    clk = 0;
  end

  always
  begin
    #clock_period;
    clk = ~clk;
  end

  initial
  begin
    $dumpfile("Decoder.vcd");
    $dumpvars(0, dut);
  end

  integer i;
  parameter countTo = WIDTH;

  initial
  begin
	//BEGIN
    #(clock_period / 2)
      reset = 1'b1;
      enable = 1'b0;
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b1;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      sel = i;
    end
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b0;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      sel = i;
    end
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule

`endif
