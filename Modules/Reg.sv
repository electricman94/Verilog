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

//Testbench
module Reg_tb #(
  parameter WIDTH = 8,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
  wire [WIDTH-1:0] out;

	Reg #(8) dut (
    .out												(out),
    .in												  (8'hAB),
		.clk												(clk),
		.reset											(reset)
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
    $dumpfile("Reg.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//BEGIN
    #(clock_period / 2)
      reset = 1'b1;
    #(clock_period * 4);
      reset = 1'b0;
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule

`endif
