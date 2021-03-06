module leftshift2bit(in, out);

	/* Takes in a 32-bit number and always shifts it left 2. To be used in barrel shifter
		for other possible shift amounts */

	input[31:0] in; // input data
	output[31:0] out; // shifted output data
	
	genvar i;
	
	or or1(out[0], 1'b0, 1'b0);
	or or2(out[1], 1'b0, 1'b0);
	
	generate
		for (i = 2; i <= 31; i = i + 1) begin: loop1
			or ori(out[i], in[i-2], 1'b0);
		end
	endgenerate

endmodule
