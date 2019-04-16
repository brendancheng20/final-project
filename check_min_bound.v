module check_min_bound(in1, in2, check_min);

	/* Checks if two 32-bit operands are both the smallest possible negative number
		to see if subtraction could result in erroneous overflow */
	input[31:0] in1, in2;
	output check_min; // 1 if both are smallest possible negative number
	
	wire MSB;
	
	/* Check MSBs are both 1 */
	
	and check_MSB(MSB, in1[31], in2[31]);
	
	/* Check all other bits are 0 */
	
	wire[30:0] zeros; // wire bus - each wire asserts 1 if both in1[i] and in2[i] are 0
	
	genvar i;
	
	generate
		for (i = 0; i < 31; i = i + 1) begin: loop1
			wire n1, n2;
			not not1(n1, in1[i]);
			not not2(n2, in2[i]);
			and andi(zeros[i], n1, n2);
		end
	endgenerate
	
	wire check1, check2, check3, check4, check5;
	and and1(check1, MSB, zeros[0], zeros[1], zeros[2], zeros[3], zeros[4], zeros[5]);
	and and2(check2, zeros[6], zeros[7], zeros[8], zeros[9], zeros[10], zeros[11], zeros[12]);
	and and3(check3, zeros[13], zeros[14], zeros[15], zeros[16], zeros[17], zeros[18]);
	and and4(check4, zeros[19], zeros[20], zeros[21], zeros[22], zeros[23], zeros[24]);
	and and5(check5, zeros[25], zeros[26], zeros[27], zeros[28], zeros[29], zeros[30]);
	
	and finalcombination(check_min, check1, check2, check3, check4, check5);
	

endmodule
