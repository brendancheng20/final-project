module rightshift2bit(in, out);

	/* Takes in 32-bit number and always shifts it right 2 bit. To be used in barrel shifter */
	
	input[31:0] in;
	output[31:0] out;
	
	or or1(out[31], in[31], 1'b0);
	or or2(out[30], in[31], 1'b0);
	
	genvar i;
	
	generate
		for (i = 29; i >= 0; i = i -1 ) begin: loop1
			or ori(out[i], in[i+2], 1'b0);
		end
	endgenerate
	
endmodule
