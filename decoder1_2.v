module decoder1_2(wire_num, onehot);

	/* 1:2 decoder takes in a 1 bit number and outputs one of 2 one-hots */

	input wire_num; // specifies which one-hot to turn on
	output [1:0] onehot; // which onehot is outputted

	not not0(onehot[0], wire_num);
	or or0(onehot[1], wire_num);
	
endmodule
