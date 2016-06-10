/*
Author: Ryan Pennell
*/
`ifndef _WriteBack_sv_
`define _WriteBack_sv_

module WriteBack (
  write_back,
  datamem,
  alu,
  ctr_mem_to_reg,
  clk,
  reset,
  enable
);
  output wire [31:0] write_back;
  input wire [31:0] datamem, alu;
  input wire clk, reset, enable, ctr_mem_to_reg;

  wire [31:0] mux_out;

  Mux #(2, 32) reg_data_mux (
		.out		(mux_out),
	  .in			({datamem, alu}),
	  .sel		(ctr_mem_to_reg),
    .enable (enable)
	);

  Reg #(32) write_back_r (write_back, mux_out, clk, reset);

endmodule

`endif
