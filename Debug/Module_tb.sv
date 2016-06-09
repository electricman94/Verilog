/*
Author: Ryan Pennell
*/
`include "../includes.sv"

module <Name>_tb #(
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;

	<Name> #() dut (
		.clk												(clk),
		.reset											(reset),
		.enable											(enable),
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
    $dumpfile("<Name>.vcd");
    $dumpvars(0, dut);
  end

  integer i;

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
      //doStuff
    end
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
