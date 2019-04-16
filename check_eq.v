module check_eq(in, assert_eq);

	/* outputs 1 if all bits of in = 0, otherwise outputs 0 */
	
	input[31:0] in;
	output assert_eq;
	
	/* Check all bits are 0 */
	
	wire[31:0] nin;
	
	genvar i;
	
	generate
		for (i = 0; i <= 31; i = i + 1) begin: loop1
			not noti(nin[i], in[i]);
		end
	endgenerate
	
	wire check1, check2, check3, check4, check5;
	and and1(check1, nin[0], nin[1], nin[2], nin[3], nin[4], nin[5], nin[6]);
	and and2(check2, nin[7], nin[8], nin[9], nin[10], nin[11], nin[12], nin[13]);
	and and3(check3, nin[14], nin[15], nin[16], nin[17], nin[18], nin[19], nin[20]);
	and and4(check4, nin[21], nin[22], nin[23], nin[24], nin[25], nin[26]);
	and and5(check5, nin[27], nin[28], nin[29], nin[30], nin[31]);
	
	and finalcombination(assert_eq, check1, check2, check3, check4, check5);
	

endmodule
