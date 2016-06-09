/*
Author: Ryan Pennell
*/
`include "../includes.sv"

module ALU_tb #(
  parameter WIDTH = 32,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
  reg [WIDTH-1:0] A, B;
  reg [5:0] funct;
  wire [WIDTH-1:0] out;
  wire [3:0] flags;

	ALU #(WIDTH) dut (
    .out                        (out),
    .flags                      (flags),
		.A                          (A),
    .B                          (B),
    .funct                      (funct),
		.enable											(1'b1)
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
    $dumpfile("ALU.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  parameter countTo = 8;

  initial
  begin
	//BEGIN
    #(clock_period / 2)
      reset = 1'b1;
      enable = 1'b0;
      A = 32'hFA10_070F;
      B = 32'h0000_010F;
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b1;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      funct = i;
    end
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
