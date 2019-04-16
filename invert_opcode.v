module invert_opcode(opcode, nopcode);

	/* Used to invert opcode for boolean logic */
	
	input[4:0] opcode;
	output[4:0] nopcode;
	
	genvar i;
	
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop0
			not noti(nopcode[i], opcode[i]);
		end
	endgenerate

endmodule
