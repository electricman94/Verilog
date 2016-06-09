/*
Author: Ryan Pennell
*/
`include "../includes.sv"

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
