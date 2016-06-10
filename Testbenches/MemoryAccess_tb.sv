`include "../includes.sv"

//CPU testbench:
module MemoryAccess_tb #(
	parameter countTo = 4,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	reg clk, reset, enable;
	wire [31:0] out;
	reg [15:0] data;
	reg [10:0] address;
	reg MR, MW;

	MemoryAccess #(16, 11) dut (
	  .data_out								(out),
	  .datamem_data						(data),
	  .datamem_address				(address),
	  .ctr_datamem_MR					(MR),
	  .ctr_datamem_MW					(MW),
	  .clk										(clk),
	  .reset									(reset),
	  .enable									(enable),
	  .datamem_export_out			(),
	  .datamem_export_data		(),
	  .datamem_export_address	(),
	  .datamem_export_MR			(),
	  .datamem_export_MW			()
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
    $dumpfile("MemoryAccess.vcd");
    $dumpvars(0, dut);
  end

  integer i;

	initial
	begin
		#(clock_period )
			reset = 1'b1;
		#(clock_period * 4)
			reset = 1'b0;
			enable = 1'b1;
			//writing
			MW = 1'b1;
			MR = 1'b0;
		for (i = 0; i < countTo; i = i + 1)
		begin
		#(clock_period * 2)
			address = i;
			data = (countTo - i);
		end
		#(clock_period * 4);
			//reading
			MW = 1'b0;
			MR = 1'b1;
		for (i = 0; i < countTo; i = i + 1)
		begin
		#(clock_period * 2)
			address = i;

		end

		#(clock_period * 4)
			reset = 1'b0;
			//writing
			MW = 1'b1;
			MR = 1'b1;
		for (i = 0; i < countTo; i = i + 1)
		begin
		#(clock_period * 2)
			address = i;
			data = 16'hF00F;
		end

		#(clock_period * 4)
			reset = 1'b0;
			//writing
			MW = 1'b1;
			MR = 1'b1;
		#(clock_period * 2)
			address = i;
			data = 16'hF00F;
		#(clock_period * 4);
		$finish;
  end
endmodule
