module leftshift8bit(in, out);

	/* Takes in a 32-bit number and always shifts it left 8. To be used in barrel shifter
		for other possible shift amounts */

	input[31:0] in; // input data
	output[31:0] out; // shifted output data
	
	genvar i;
	
	or or1(out[0], 1'b0, 1'b0);
	or or2(out[1], 1'b0, 1'b0);
	or or3(out[2], 1'b0, 1'b0);
	or or4(out[3], 1'b0, 1'b0);
	or or5(out[4], 1'b0, 1'b0);
	or or6(out[5], 1'b0, 1'b0);
	or or7(out[6], 1'b0, 1'b0);
	or or8(out[7], 1'b0, 1'b0);
	
	generate
		for (i = 8; i <= 31; i = i + 1) begin: loop1
			or ori(out[i], in[i-8], 1'b0);
		end
	endgenerate

endmodule
