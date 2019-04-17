//module yahtzee(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button);
module yahtzee(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button, currpc, data_reg1, A, B,
					fd, dx, xm, mw, data_reg2);
/*		yahtzee module is top-level module in project. Contains the processor (in the form of a skeleton module, based
 *		on the processor project checkpoint) and other behavioral Verilog modules used for other project purposes, such
 *		as I/O.
 */

	input clock, reset, reg1Button, reg2Button, reg3Button, reg4Button;

	skeleton my_processor(.clock(clock), .reset(reset), .reg1Button(reg1Button), .reg2Button(reg2Button),
						  .reg3Button(reg3Button), .reg4Button(reg4Button), .currpc(currpc), .data_reg1(data_reg1),
						  .A(A), .B(B), .fd(fd), .dx(dx), .xm(xm), .mw(mw), .data_reg2(data_reg2));
						  
						  
	/* TESTING WIRES */
	output[11:0] currpc;
	output[31:0] data_reg1, A, B, fd, dx, xm, mw, data_reg2;

endmodule
