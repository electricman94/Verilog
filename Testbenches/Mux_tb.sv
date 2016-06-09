/*
Author: Ryan Pennell
*/
`include "../includes.sv"

module Mux_tb #(
  parameter CHANNELS = 4,
  parameter WIDTH = 8,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
  wire [WIDTH-1:0] out;
  reg [WIDTH*CHANNELS-1:0] in;
  reg [$clog2(CHANNELS)-1:0] sel;

	Mux #(CHANNELS, WIDTH) dut (
		.out												(out),
		.in   											(in),
    .sel                        (sel),
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
    $dumpfile("Mux.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//BEGIN
    #(clock_period / 2)
      reset = 1'b1;
      enable = 1'b0;
      for (i = 0; i < CHANNELS; i = i + 1)
      begin
        in[(i*WIDTH) +: WIDTH] = CHANNELS - i;
      end
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b1;
    for (i = 0; i < CHANNELS; i = i + 1)
    begin
    #(clock_period * 2)
      sel = i;
    end
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
