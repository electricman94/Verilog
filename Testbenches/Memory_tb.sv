`include "../includes.sv"

module Memory_tb() ;
	reg clk, reset;
	parameter clock_period = 10;
	wire [15:0] out, exp_out, probe;
	reg [15:0] data;
	reg [10:0] address, exp_address;
	reg MR, MW, exp_MW, exp;

	initial
	begin
		clk = 0;
	end

	always
	begin
		#clock_period;
		clk = ~clk;
	end

	//module Memory #(ADDR_SIZE = 11, WIDTH = 16) (out, data, address, MR, MW, clk);
	Memory #(11, 16) myModule	(
		.out					(out),
		.data					(data),
		.address			(address),
		.MR						(MR),
		.MW						(MW),
		.clk					(clk),
		.exp					(exp),
		.exp_out			(exp_out),
		.exp_data			(16'hAAAA),
		.exp_address	(exp_address),
		.exp_MR				(1'b1),
		.exp_MW				(1'b1)
	);

	initial
	begin
		$dumpfile("Memory.vcd");
		$dumpvars(0, myModule);
	end

	integer i;
	parameter countTo = 8;

	initial
	begin
		#(clock_period / 2)
			reset = 1'b1;
			exp = 1'b1;
		#(clock_period * 4)
			reset = 1'b0;
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
			exp = 1'b0;
			//writing
			MW = 1'b1;
			MR = 1'b1;
		#(clock_period * 2)
			address = i;
			exp_address = i;
			data = 16'hF00F;
		#(clock_period * 4);
		$finish;
	end
endmodule
