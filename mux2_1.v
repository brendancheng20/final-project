module mux2_1(in1, in2, out, ctrl);

	/* 2:1 mux. Outputs in1 if ctrl is 0 and outputs in2 if ctrl is 1 */

	input[31:0] in1, in2;
	input ctrl;
	output[31:0] out;
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: loop1
			wire m1, m2, m3, not_ctrl, m4;
			and and1(m1, in2[i], ctrl);
			and and2(m2, in1[i], in2[i]);
			not not1(not_ctrl, ctrl);
			and and3(m3, in1[i], not_ctrl);
			
			or or1(m4, m1, m2);
			or or2(out[i], m4, m3);
			
		end
	endgenerate
	
	

endmodule
