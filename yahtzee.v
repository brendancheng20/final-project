module yahtzee(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button);
//module yahtzee(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button, currpc);
/*		yahtzee module is top-level module in project. Contains the processor (in the form of a skeleton module, based
 *		on the processor project checkpoint) and other behavioral Verilog modules used for other project purposes, such
 *		as I/O.
 */

	input clock, reset, reg1Button, reg2Button, reg3Button, reg4Button;

	skeleton my_processor(.clock(clock), .reset(reset), .reg1Button(reg1Button), .reg2Button(reg2Button),
						  .reg3Button(reg3Button), .reg4Button(reg4Button)
//						  .currpc(currpc)
								);
						  
						  
	/* TESTING WIRES */
//	output[11:0] currpc;

endmodule
