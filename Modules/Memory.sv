/*
Author: Ryan Pennell
*/

`ifndef _Memory_sv_
`define _Memory_sv_

module Memory #(
	parameter ADDR_SIZE = 8,
	parameter WIDTH = 16
)(
	out,
	data,
	address,
	MR,
	MW,
	clk,
	exp,
	exp_out,
	exp_data,
	exp_address,
	exp_MR,
	exp_MW
);
	output wire [WIDTH-1:0] out, exp_out;
	input wire [WIDTH-1:0] data, exp_data;
	input wire [ADDR_SIZE-1:0] address, exp_address;
	input wire MR, MW, exp_MR, exp_MW, clk, exp;

	//goes columns by rows
	reg [WIDTH-1:0] mem [(2**ADDR_SIZE)-1:0];

	assign out = 			(MR) 			? mem[address] 			: {WIDTH{1'b0}};
	assign exp_out = 	(exp_MR) 	? mem[exp_address] 	: {WIDTH{1'b0}};

	always @ (posedge clk)
	begin
		if (exp & MW)
		begin
			mem[address] = data;
		end
		else if (!exp & exp_MW)
		begin
			mem[exp_address] = exp_data;
		end
	end
endmodule

`endif
