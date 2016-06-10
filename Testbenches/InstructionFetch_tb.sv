`include "../includes.sv"
`timescale 1 ns/1 ns

//CPU testbench:
module InstructionFetch_tb #(
	parameter clock_period = 20  //50 MHz in ns timescale
)(

);
	reg clk, reset;


	reg enPC, instmem_export_MR, instmem_export_MW, sel, ctr_nop;
  reg [31:0] instmem_export_data;
  reg [7:0] instmem_export_address;
	wire [31:0] instmem_export_out;
	wire [31:0] PC;

	InstructionFetch dut(
	  .PC											(PC),
	  .PCin										(32'd32),
	  .ctr_PC_src							(sel),
		.ctr_nop								(ctr_nop),
	  .clk										(clk),
	  .reset									(reset),
	  .enable									(enPC),
	  .instmem_export_out			(instmem_export_out),
	  .instmem_export_data		(instmem_export_data),
	  .instmem_export_address	(instmem_export_address),
	  .instmem_export_MR			(instmem_export_MR),
	  .instmem_export_MW			(instmem_export_MW)
	);

	//this is where we store data and instuctions to upload to the CPU
  reg [31:0] inst [50:0];
	parameter countTo = 30; //must be larger than the amount of inst or data uploaded

  initial
  begin
		inst[0] = 32'd0;
		inst[1] = 32'b100011_00000_01000_0000000000000010; // offset 2 load 0 to t0
		inst[2] = 32'b101011_00000_01000_0000000000000001;
		inst[3] = 32'd0;
		inst[8] = 32'hFFFFFFFF;
  end

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
    $dumpfile("InstructionFetch.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//PROGRAM UPLOAD
    #(clock_period / 2)
      reset = 1'b1;
      enPC = 1'b0;
			sel = 1'b0;
			ctr_nop = 1'b0;
      instmem_export_MW = 1'b1;
      instmem_export_MR = 1'b1;
    #(clock_period * 4)
      reset = 1'b0;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      instmem_export_address = i;
      instmem_export_data = inst[i];
    end
    #(clock_period * 4);

	//CPU ENABLED
		enPC = 1'b1;
		#(clock_period * 8);
	//JUMP
		sel = 1'b1;
		#(clock_period * 2);
		sel = 1'b0;
		#(clock_period * 8);
	//NOP INJECTION
		ctr_nop = 1'b1;
		#(clock_period * 8);
	//SIMULATION END
    $finish;
  end
endmodule
