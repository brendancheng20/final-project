module rightshift8bit(in, out);

	/* Takes in 32-bit number and always shifts it right 8 bits. To be used in barrel shifter */
	
	input[31:0] in;
	output[31:0] out;
	
	or or1(out[31], in[31], 1'b0);
	or or2(out[30], in[31], 1'b0);
	or or3(out[29], in[31], 1'b0);
	or or4(out[28], in[31], 1'b0);
	or or5(out[27], in[31], 1'b0);
	or or6(out[26], in[31], 1'b0);
	or or7(out[25], in[31], 1'b0);
	or or8(out[24], in[31], 1'b0);
	
	genvar i;
	
	generate
		for (i = 23; i >= 0; i = i -1 ) begin: loop1
			or ori(out[i], in[i+8], 1'b0);
		end
	endgenerate
	
endmodule
