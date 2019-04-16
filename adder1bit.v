module adder1bit(cin, in1, in2, sum);

	/* Carry-lookahead adder implementation; only computes sum */

	input cin, in1, in2;
	output sum;
	
	xor sumxor(sum, cin, in1, in2);

endmodule

