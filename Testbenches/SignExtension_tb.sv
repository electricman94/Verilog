`include "../includes.sv"
`timescale 1 ns/1 ns

//CPU testbench:
module SignExtension_tb #(
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
	reg [3:0] in;
	wire [5:0] out;

	SignExtension #(6, 4) dut (
		.out		(out),
		.in			(in)
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
    $dumpfile("SignExtension.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//BEGIN
    #(clock_period / 2)
      reset = 1'b1;
      enable = 1'b0;
    #(clock_period * 2);
      in = 4'h0;
		#(clock_period * 2);
			in = 4'hF;
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
