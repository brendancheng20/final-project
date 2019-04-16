module cladder4bit(in1, in2, cin, sum, cout, P, G);

	/* 4-bit CLA adder using carry-lookahead and 1-bit adders that ignore carry out */
	
	input[3:0] in1, in2; // data operands
	input cin;
	output[3:0] sum;
	output cout, P, G;
	
	wire[3:0] claout; // output of cla
	
	cla4bit calccarry(in1, in2, cin, claout, P, G); // compute carries, P, G
	
	/* Compute sum bits */
	adder1bit sum0(cin, in1[0], in2[0], sum[0]);
	adder1bit sum1(claout[0], in1[1], in2[1], sum[1]);
	adder1bit sum2(claout[1], in1[2], in2[2], sum[2]);
	adder1bit sum3(claout[2], in1[3], in2[3], sum[3]);
	
	/* Wire cout */
	or orcout(cout, 1'b0, claout[3]);

endmodule
