`include "../includes.sv"

//CPU testbench:
module WriteBack_tb #(
	parameter clock_period = 20,  //50 MHz in ns timescale
	parameter countTo = 2
)(
);
	reg [31:0] datamem, alu;
	wire [31:0] writeback;
	reg clk, reset, enable, ctr_mem_to_reg;

	WriteBack dut(
	  writeback,
	  datamem,
	  alu,
	  ctr_mem_to_reg,
	  clk,
	  reset,
	  enable
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
    $dumpfile("WriteBack.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//BEGIN
    #(clock_period / 2);
      reset = 1'b1;
      enable = 1'b0;
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b1;
			datamem = 32'hFFFFFFFF;
			alu = 32'h33333333;
			ctr_mem_to_reg = 1'b1;
    #(clock_period * 4);
			ctr_mem_to_reg = 1'b0;
		#(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
