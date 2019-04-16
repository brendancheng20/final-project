module decoder5_32(select, onehot);

	input[4:0] select;
	output[31:0] onehot;
	
	/* Declare decoders */
	
	wire[4:0] notselect;
	
	not not0(notselect[0], select[0]);
	not not1(notselect[1], select[1]);
	not not2(notselect[2], select[2]);
	not not3(notselect[3], select[3]);
	not not4(notselect[4], select[4]);
	
	and and0(onehot[0], notselect[0], notselect[1], notselect[2], notselect[3], notselect[4]);
	and and1(onehot[1], select[0], notselect[1], notselect[2], notselect[3], notselect[4]);
	and and2(onehot[2], notselect[0], select[1], notselect[2], notselect[3], notselect[4]);
	and and3(onehot[3], select[0], select[1], notselect[2], notselect[3], notselect[4]);
	and and4(onehot[4], notselect[0], notselect[1], select[2], notselect[3], notselect[4]);
	and and5(onehot[5], select[0], notselect[1], select[2], notselect[3], notselect[4]);
	and and6(onehot[6], notselect[0], select[1], select[2], notselect[3], notselect[4]);
	and and7(onehot[7], select[0], select[1], select[2], notselect[3], notselect[4]);
	and and8(onehot[8], notselect[0], notselect[1], notselect[2], select[3], notselect[4]);
	and and9(onehot[9], select[0], notselect[1], notselect[2], select[3], notselect[4]);
	and and10(onehot[10], notselect[0], select[1], notselect[2], select[3], notselect[4]);
	and and11(onehot[11], select[0], select[1], notselect[2], select[3], notselect[4]);
	and and12(onehot[12], notselect[0], notselect[1], select[2], select[3], notselect[4]);
	and and13(onehot[13], select[0], notselect[1], select[2], select[3], notselect[4]);
	and and14(onehot[14], notselect[0], select[1], select[2], select[3], notselect[4]);
	and and15(onehot[15], select[0], select[1], select[2], select[3], notselect[4]);
	and and16(onehot[16], notselect[0], notselect[1], notselect[2], notselect[3], select[4]);
	and and17(onehot[17], select[0], notselect[1], notselect[2], notselect[3], select[4]);
	and and18(onehot[18], notselect[0], select[1], notselect[2], notselect[3], select[4]);
	and and19(onehot[19], select[0], select[1], notselect[2], notselect[3], select[4]);
	and and20(onehot[20], notselect[0], notselect[1], select[2], notselect[3], select[4]);
	and and21(onehot[21], select[0], notselect[1], select[2], notselect[3], select[4]);
	and and22(onehot[22], notselect[0], select[1], select[2], notselect[3], select[4]);
	and and23(onehot[23], select[0], select[1], select[2], notselect[3], select[4]);
	and and24(onehot[24], notselect[0], notselect[1], notselect[2], select[3], select[4]);
	and and25(onehot[25], select[0], notselect[1], notselect[2], select[3], select[4]);
	and and26(onehot[26], notselect[0], select[1], notselect[2], select[3], select[4]);
	and and27(onehot[27], select[0], select[1], notselect[2], select[3], select[4]);
	and and28(onehot[28], notselect[0], notselect[1], select[2], select[3], select[4]);
	and and29(onehot[29], select[0], notselect[1], select[2], select[3], select[4]);
	and and30(onehot[30], notselect[0], select[1], select[2], select[3], select[4]);
	and and31(onehot[31], select[0], select[1], select[2], select[3], select[4]);
	
//	decoder4_16 d0(select[3:0],out0); // 4:16 decoder uses LSBs
//	decoder1_2 d2(select[4],out1); // 1:2 decoder uses MSB
//	
//	/* AND lower decoder outputs to create 5:32 decoder outputs */
//	and and0(onehot[0], out0[0], out1[0]);
//	and and1(onehot[1], out0[1], out1[0]);
//	and and2(onehot[2], out0[2], out1[0]);
//	and and3(onehot[3], out0[3], out1[0]);
//	and and4(onehot[4], out0[4], out1[0]);
//	and and5(onehot[5], out0[5], out1[0]);
//	and and6(onehot[6], out0[6], out1[0]);
//	and and7(onehot[7], out0[7], out1[0]);
//	and and8(onehot[8], out0[8], out1[0]);
//	and and9(onehot[9], out0[9], out1[0]);
//	and and10(onehot[10], out0[10], out1[0]);
//	and and11(onehot[11], out0[11], out1[0]);
//	and and12(onehot[12], out0[12], out1[0]);
//	and and13(onehot[13], out0[13], out1[0]);
//	and and14(onehot[14], out0[14], out1[0]);
//	and and15(onehot[15], out0[15], out1[0]);
//	and and16(onehot[16], out0[0], out1[1]);
//	and and17(onehot[17], out0[1], out1[1]);
//	and and18(onehot[18], out0[2], out1[1]);
//	and and19(onehot[19], out0[3], out1[1]);
//	and and20(onehot[20], out0[4], out1[1]);
//	and and21(onehot[21], out0[5], out1[1]);
//	and and22(onehot[22], out0[6], out1[1]);
//	and and23(onehot[23], out0[7], out1[1]);
//	and and24(onehot[24], out0[8], out1[1]);
//	and and25(onehot[25], out0[9], out1[1]);
//	and and26(onehot[26], out0[10], out1[1]);
//	and and27(onehot[27], out0[11], out1[1]);
//	and and28(onehot[28], out0[12], out1[1]);
//	and and29(onehot[29], out0[13], out1[1]);
//	and and30(onehot[30], out0[14], out1[1]);
//	and and31(onehot[31], out0[15], out1[1]);

endmodule
