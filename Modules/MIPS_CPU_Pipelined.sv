/*
Author: Ryan Pennell
*/
`ifndef _MIPS_CPU_Pipelined_sv_
`define _MIPS_CPU_Pipelined_sv_

module MIPS_CPU_Pipelined(
	clk,
	rst,
	enPC,
	datamem_export_out,
	datamem_export_data,
	datamem_export_address,
	datamem_export_MR,
	datamem_export_MW,
	instmem_export_out,
	instmem_export_data,
	instmem_export_address,
	instmem_export_MR,
	instmem_export_MW
);
	output wire [INST_W-1:0] instmem_export_out;
	output wire [DATA_W-1:0] datamem_export_out;

	input wire clk, rst, enPC;

	input wire [INST_W-1:0] instmem_export_data;
	input wire [INST_A-1:0] instmem_export_address;
	input wire [DATA_W-1:0] datamem_export_data;
	input wire [DATA_A-1:0] datamem_export_address;
	input wire datamem_export_MR, datamem_export_MW, instmem_export_MR, instmem_export_MW;

	// enPC debouncer_____________________________________________________________
	wire enPC_safe;
	//register only enables PC on posedge clk
	Reg	#(1) enPC_deb (enPC_safe, enPC, clk, rst);

	// Instruction Fetch of Pipeline______________________________________________
	InstructionFetch IF_Pipe(
		.out_PC									(PC[0]),
		.PCin										(branch),
		.ctr_PC_src							(ctr_PC_src),
		.ctr_nop								(ctr_nop),
		.clk										(clk),
		.rst										(reset),
		.enable									(enPC_safe),

		.instmem_export_out			(instmem_export_out),
		.instmem_export_data		(instmem_export_data),
		.instmem_export_address	(instmem_export_address),
		.instmem_export_MR			(instmem_export_MR),
		.instmem_export_MW			(instmem_export_MW)
	);

	// Instruction Decode of Pipeline_____________________________________________
	wire [31:0] immediate_ext, reg1, reg2;
	wire [4:0] wsel, rt, rd;
	wire ctr_PC_src, ctr_alu_src, ctr_alu_op, ctr_reg_dest, ctr_datamem_MR, ctr_datamem_MW, ctr_mem_to_reg;

	InstructionDecode ID_Pipe (
		.ctr_PC_src							(ctr_PC_src),
		.ctr_nop								(ctr_nop)
		.ctr_alu_src						(ctr_alu_src),
		.ctr_alu_op							(ctr_alu_op),
		.ctr_reg_dest						(ctr_reg_dest),
		.ctr_datamem_MR					(ctr_datamem_MR),
		.ctr_datamem_MW					(ctr_datamem_MW),
		.ctr_mem_to_reg					(ctr_mem_to_reg),
	  .wsel										(wsel),
	  .reg1_out								(reg1),
	  .reg2_out								(reg2),
	  .immediate_ext					(immediate_ext),
	  .rt											(rt),
	  .rd											(rd),
		.we											(we),
	  .clk										(clk),
	  .reset									(reset),
	  .enable									(enPC_safe)
	);

	Reg #(32) IF_ID_r (PC[1], PC[0], clk, reset);

	// Execute of Pipeline________________________________________________________
	wire [31:0] branch, alu, reg2_out;
	wire [3:0] flags;

	Execute EX_Pipe(
		.branch_out							(branch),
		.flags									(flags),
		.alu										(alu),
		.reg2_out								(reg2_out),
		.PC_next								(PC[1]),
		.wsel										(wsel),
		.reg1										(reg1),
		.reg2										(reg2),
		.ext_immediate					(immediate_ext),
		.funct									(funct),
		.rt											(rt),
		.rd											(rd),
		.ctr_reg_dest						(ctr_reg_dest),
		.ctr_alu_op							(ctr_alu_op),
		.ctr_alu_src						(ctr_alu_src),
		.clk										(clk),
		.reset									(reset)
	);

	Reg #(32) alu_r (alu_MA, alu, clk, reset);

	// Memory Access of Pipeline__________________________________________________
	wire [15:0] datamem_out;
	wire [31:0] alu_MA;

	MemoryAccess MA_Pipe(
		.data_out								(datamem_out),
		.datamem_data						(reg2[15:0]),
		.datamem_address				(alu),
		.ctr_datamem_MR					(ctr_datamem_MR),
		.ctr_datamem_MW					(ctr_datamem_MW),
		.clk										(clk),
		.reset									(reset),
		.enable									(enPC_safe),
		.datamem_export_out			(datamem_export_out),
		.datamem_export_data		(datamem_export_data),
		.datamem_export_address	(datamem_export_address),
		.datamem_export_MR			(datamem_export_MR),
		.datamem_export_MW			(datamem_export_MW)
	);

	// Write Back of Pipeline_____________________________________________________
	wire [31:0] writeback;

	WriteBack WB_Pipe(
	  .writeback							(writeback),
	  .datamem								(datamem_out),
	  .alu										(),
	  .ctr_mem_to_reg					(ctr_mem_to_reg),
	  .clk										(clk),
	  .reset									(reset),
	  .enable									(enPC_safe)
	);

endmodule

`endif
