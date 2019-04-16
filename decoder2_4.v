module decoder2_4(select, onehot);

	/* 2:4 decoder made up of two 1:2 decoders and four AND gates */

	input[1:0] select;
	output[3:0] onehot;
	
	wire[1:0] out0, out1;
	
	decoder1_2 d0(select[0], out0);
	decoder1_2 d1(select[1], out1);
	
	and and0(onehot[0], out0[0], out1[0]);
	and and1(onehot[1], out0[1], out1[0]);
	and and2(onehot[2], out0[0], out1[1]);
	and and3(onehot[3], out0[1], out1[1]);
	

endmodule
