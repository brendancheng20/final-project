module decoder4_16(select, onehot);
	
	/* 4:16 decoder using 2 2:4 decoders */
	
	input[3:0] select;
	output[15:0] onehot;
	
	wire[3:0] out0, out1; // output buses for 2:4 decoders
	
	/* split into 2 decoded buses based on first 2 and last 2 bits of input */
	
	decoder2_4 d0(select[1:0], out0); // decode least significant bits
	decoder2_4 d1(select[3:2], out1); // decode most significant bits
	
	/* AND outputs of 2:4 decoders to produce output of 4:16 decoder */
	
	and and0(onehot[0], out0[0], out1[0]);
	and and1(onehot[1], out0[1], out1[0]);
	and and2(onehot[2], out0[2], out1[0]);
	and and3(onehot[3], out0[3], out1[0]);
	and and4(onehot[4], out0[0], out1[1]);
	and and5(onehot[5], out0[1], out1[1]);
	and and6(onehot[6], out0[2], out1[1]);
	and and7(onehot[7], out0[3], out1[1]);
	and and8(onehot[8], out0[0], out1[2]);
	and and9(onehot[9], out0[1], out1[2]);
	and and10(onehot[10], out0[2], out1[2]);
	and and11(onehot[11], out0[3], out1[2]);
	and and12(onehot[12], out0[0], out1[3]);
	and and13(onehot[13], out0[1], out1[3]);
	and and14(onehot[14], out0[2], out1[3]);
	and and15(onehot[15], out0[3], out1[3]);

endmodule
