module rightshift16bit(in, out);

	/* Takes in 32-bit number and always shifts it right 16 bits. To be used in barrel shifter */
	
	input[31:0] in;
	output[31:0] out;
	
	genvar k;
	
	generate
		for (k = 31; k >=16; k = k - 1) begin: loop0
			or ork(out[k], in[31], 1'b0);
		end
	endgenerate
	
	genvar i;
	
	generate
		for (i = 15; i >= 0; i = i -1 ) begin: loop1
			or ori(out[i], in[i+16], 1'b0);
		end
	endgenerate
	
endmodule
