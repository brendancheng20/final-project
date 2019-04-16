module convert_neg(in, out);

	/* Converts input to 2's complement negative by flipping bits and adding 1 */
	
	input[31:0] in; // input
	output[31:0] out; // output - inverted bits + 1
	
	wire[31:0] inv; // inverted bits before adding 1
	wire temp;
	
	/* Invert bits */
	
	genvar i;
	
	generate
		for (i = 0; i <= 31; i = i + 1) begin: loop1
			not invert(inv[i], in[i]);
		end
	endgenerate
	
	/* Add 1 */
	
	adder32bit add1(inv, 1, temp, out);

endmodule
