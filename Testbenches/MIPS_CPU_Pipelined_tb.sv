`include "../includes.sv"
`timescale 1 ns/1 ns

//CPU testbench:
module MIPS_CPU_Pipelined_tb #(
	parameter clock_period = 20  //50 MHz in ns timescale
)(

);
	reg clk, reset;


	reg enPC, datamem_export_MR, datamem_export_MW, instmem_export_MR, instmem_export_MW;
	reg [15:0] datamem_export_data;
  reg [31:0] instmem_export_data;
	reg [10:0] datamem_export_address;
  reg [6:0] instmem_export_address;
	wire [15:0] datamem_export_out;
	wire [31:0] instmem_export_out;

	MIPS_CPU_Pipelined dut (
		.clk											(clk),
		.rst											(reset),
		.enPC											(enPC),
		.datamem_export_out				(datamem_export_out),
		.datamem_export_data			(datamem_export_data),
		.datamem_export_address		(datamem_export_address),
		.datamem_export_MR				(datamem_export_MR),
		.datamem_export_MW				(datamem_export_MW),
		.instmem_export_out				(instmem_export_out),
		.instmem_export_data			(instmem_export_data),
		.instmem_export_address		(instmem_export_address),
		.instmem_export_MR				(instmem_export_MR),
		.instmem_export_MW				(instmem_export_MW)
  );

	//this is where we store data and instuctions to upload to the CPU
  reg [31:0] inst [50:0];
  reg [16:0] data [50:0];
	parameter countTo = 30; //must be larger than the amount of inst or data uploaded

  initial
  begin
		inst[0] = 32'd0;
		inst[1] = 32'b100011_00000_01000_0000000000000010; // offset 2 load 0 to t0
		inst[2] = 32'b101011_00000_01000_0000000000000001;
		inst[3] = 32'd0;

		data[0] = 16'd0;
		data[1] = 16'd0;
		data[2] = 16'd1;
		data[3] = 16'd0;
		data[4] = 16'd0;
		data[5] = 16'd0;
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
    $dumpfile("MIPS_CPU_Pipelined.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//PROGRAM UPLOAD
    #(clock_period / 2)
      reset = 1'b1;
      enPC = 1'b0;
      instmem_export_MW = 1'b1;
      instmem_export_MR = 1'b1;
      datamem_export_MW = 1'b1;
      datamem_export_MR = 1'b1;
    #(clock_period * 4)
      reset = 1'b0;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      instmem_export_address = i;
      instmem_export_data = inst[i];
			datamem_export_address = i;
      datamem_export_data = data[i];
    end
    #(clock_period * 4);

	//CPU ENABLED
		enPC = 1'b1;
		#(clock_period * 16);

	//SIMULATION END
    $finish;
  end
endmodule
