module add_sub(in1, in2, sub, ovf, result);

	/* 32-bit adder/subtractor. Uses adder32bit for both, however also has functionality to convert
		in2 to -in2 for subtraction */
		
	input [31:0] in1, in2; // data operands
	input sub; // toggle addition (0) and subtraction (1)
	output ovf; // true if overflow
	output[31:0] result; // result of operation
	
	/* Create negative version of in2 and wire to mux */
	
	wire[31:0] inv, operand2; // inv = inverse of in2, operand2 = whichever of in2 and inv are selected by mux
	wire cout; // carry-out of addition operation
	
	convert_neg invert(in2, inv); // invert
	mux2_1 mux(in2, inv, operand2, sub); // wire to mux
	
	/* Perform addition */
	
	adder32bit add_data(in1, operand2, cout, result);
	
	/* Check overflow */

	wire nin1, nin2, nresult;
	not notin1(nin1, in1[31]); // inverse of MSB operand 1
	not notin2(nin2, operand2[31]); // inverse of MSB of operand 2
	not notres(nresult, result[31]); // inverse of MSB of result
	
	wire cond1, cond2;
	
	wire temp, check_min;
	
	check_min_bound min_bound(in1, operand2, check_min);
	
	and and1(cond1, nin1, nin2, result[31]);
	and and2(cond2, in1[31], operand2[31], nresult);
	
	or or1(temp, cond1, cond2);
	wire err_ovf, neo; // check_min AND sub
	and check_false_ovf(err_ovf, check_min, sub);
	not noteo(neo, err_ovf);
	
	and out(ovf, neo, temp);

endmodule
