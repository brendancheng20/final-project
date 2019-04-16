module bitwise_or(in1, in2, result);

	input[31:0] in1, in2;
	output[31:0] result;
	
	genvar i;
	generate
		for (i = 0; i<32; i= i+1) begin: loop1
			or ori(result[i], in1[i], in2[i]);
		end
	endgenerate
	
//	or or0(result[0], in1[0], in2[0]);
//	or or1(result[1], in1[1], in2[1]);
//	or or2(result[2], in1[2], in2[2]);
//	or or3(result[3], in1[3], in2[3]);
//	or or4(result[4], in1[4], in2[4]);
//	or or5(result[5], in1[5], in2[5]);
//	or or6(result[6], in1[6], in2[6]);
//	or or7(result[7], in1[7], in2[7]);
//	or or8(result[8], in1[8], in2[8]);
//	or or9(result[9], in1[9], in2[9]);
//	or or10(result[10], in1[10], in2[10]);
//	or or11(result[11], in1[11], in2[11]);
//	or or12(result[12], in1[12], in2[12]);
//	or or13(result[13], in1[13], in2[13]);
//	or or14(result[14], in1[14], in2[14]);
//	or or15(result[15], in1[15], in2[15]);
//	or or16(result[16], in1[16], in2[16]);
//	or or17(result[17], in1[17], in2[17]);
//	or or18(result[18], in1[18], in2[18]);
//	or or19(result[19], in1[19], in2[19]);
//	or or20(result[20], in1[20], in2[20]);
//	or or21(result[21], in1[21], in2[21]);
//	or or22(result[22], in1[22], in2[22]);
//	or or23(result[23], in1[23], in2[23]);
//	or or24(result[24], in1[24], in2[24]);
//	or or25(result[25], in1[25], in2[25]);
//	or or26(result[26], in1[26], in2[26]);
//	or or27(result[27], in1[27], in2[27]);
//	or or28(result[28], in1[28], in2[28]);
//	or or29(result[29], in1[29], in2[29]);
//	or or30(result[30], in1[30], in2[30]);
//	or or31(result[31], in1[31], in2[31]);
	
endmodule
