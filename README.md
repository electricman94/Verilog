# Synopsis

Readme is intentionally left blank for anonymity.  

# Structure

* Top
	* Code:		for non-HDL code
	* Debug:	for all modules assumed to be "not under test" and for ease of debugging only
	* Modules: 	for all Verilog modules used in synthesis.  All!
		* All Modules should be formatted like the "Module.sv" in Debug
		* All Modules should have an associated testbench named <Module Name>\_tb.sv
		* All modules should have an if_n_def def wrapper.
		* No testbench shall delete the clock signal.  It is a good reference
	* Simulations: 	for vcd files of module testbenches
	* Plots:	for saved gtkwave files
