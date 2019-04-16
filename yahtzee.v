module yahtzee(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button);
/*		yahtzee module is top-level module in project. Contains the processor (in the form of a skeleton module, based
 *		on the processor project checkpoint) and other behavioral Verilog modules used for other project purposes, such
 *		as I/O.
 */

//data_reg3,
//					 fd, dx, xm, mw, fdout, A, B, data_reg4, assertHazard, currpc, branchout, readA, readB, ALUOUT, jalreg,
//					 ALUA, ALUB, outA, xout,bypass, isLessThan, branchtaken, data_reg1,

	input clock, reset, reg1Button, reg2Button, reg3Button, reg4Button;

	skeleton my_processor(.clock(clock), .reset(reset), .reg1Button(reg1Button), .reg2Button(reg2Button),
						  .reg3Button(reg3Button), .reg4Button(reg4Button));

endmodule
