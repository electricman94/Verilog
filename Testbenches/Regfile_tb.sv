`include "../includes.sv"

module Regfile_tb() ;
	reg clk, reset;
	parameter clock_period = 10;
  reg [31:0] data;
  wire [31:0] reg1, reg2;
  reg [4:0] r1sel, r2sel, wsel;
  reg we;

	initial
	begin
		clk = 0;
	end

	always
	begin
		#clock_period;
		clk = ~clk;
	end

	//Regfile (reg1, reg2, r1sel, r2sel, wsel, data, we, reset, clk);
  Regfile myModule(reg1, reg2, r1sel, r2sel, wsel, data, we, clk, reset);

	//!CS && OE && !RW = writing
	//!CS && !OE && RW = reading
	//assign data = (!CS && OE && !RW) ? sent : 16'bz;

	initial
	begin
		$dumpfile("Regfile.vcd");
		$dumpvars(0, myModule);
	end

  integer i;
  parameter countTo = 32;

	initial
	begin
		#(clock_period / 2)
			reset = 1'b1;
      we = 1'b0;
			data = 32'h0000;
		#(clock_period * 4)
			reset = 1'b0;
			//writing
		for (i = 0; i < countTo; i = i + 1)
		begin
		#(clock_period * 2)
      we = 1'b1;
			r1sel = i;
      r2sel = i - 2;
      wsel = i;
	    data = countTo - i;
		end
		#(clock_period * 4);
		$finish;
	end
endmodule
