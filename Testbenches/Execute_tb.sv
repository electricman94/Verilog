`include "../includes.sv"

//CPU testbench:
module Execute_tb #(
	parameter countTo = 9,
	parameter clock_period = 20  //50 MHz in ns timescale
)(
);
	wire [31:0] branch_out, alu, reg2;
	wire [3:0] flags;
	wire [4:0] wsel;
	reg [31:0] PC_next, alu1, alu2, ext_immediate;
	reg [5:0] funct;
	reg [4:0] rt, rd;
	reg reg_dest, alu_op, alu_src, clk, reset, enable;

	Execute dut(
	  .branch_out			(branch_out),
	  .flags					(flags),
	  .alu						(alu),
	  .reg2_out				(reg2),
	  .PC_next				(PC_next),
		.wsel						(wsel),
	  .reg1						(alu1),
	  .reg2						(alu2),
	  .ext_immediate	(ext_immediate),
	  .funct					(funct),
	  .rt							(rt),
	  .rd							(rd),
	  .ctr_reg_dest		(reg_dest),
	  .ctr_alu_op			(alu_op),
	  .ctr_alu_src		(alu_src),
	  .clk						(clk),
	  .reset					(reset)
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
    $dumpfile("Execute.vcd");
    $dumpvars(0, dut);
  end

  integer i;

  initial
  begin
	//BEGIN
    #(clock_period)
      reset = 1'b1;
      enable = 1'b1;
    #(clock_period * 4);
      reset = 1'b0;
			enable = 1'b1;
			PC_next = 32'd64;
			alu1 = 32'd8;
			alu2 = 32'd8;
			ext_immediate = 32'd16;
			rt = 5'd2;
			rd = 5'd4;
    for (i = 0; i < countTo; i = i + 1)
    begin
    #(clock_period * 2)
      reg_dest = i[0];
			alu_op = i[1];
			alu_src = i[2];
    end
    #(clock_period * 4);

	//SIMULATION END
    $finish;
  end
endmodule
