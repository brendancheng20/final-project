module leftshift16bit(in, out);

	/* Takes in a 32-bit number and always shifts it left 8. To be used in barrel shifter
		for other possible shift amounts */

	input[31:0] in; // input data
	output[31:0] out; // shifted output data
	
	genvar i;
	
	generate
		for (i = 0; i <= 15; i = i + 1) begin: loop0
			or orn(out[i], 1'b0, 1'b0);
		end
	endgenerate
	
	genvar k;
	
	generate
		for (k = 16; k <= 31; k = k + 1) begin: loop1
			or ori(out[k], in[k-16], 1'b0);
		end
	endgenerate

endmodule
