module takeBranch(opcode, isNotEqual, isLessThan, branch);

	/** Asserts branch signal if a branch should be taken, based on if opcode of instruction is branch opcode
	 *	 and if the corresponding branch signal (isLessThan for blt and isNotEqual for bne) from the ALU is asserted
	 */
	 
	 input[4:0] opcode;
	 input isNotEqual, isLessThan;
	 output branch;
	 
	 wire[4:0] notOpcode;
	 wire bne, blt;
	 
	 genvar i;
	 generate
		for (i = 0; i < 5; i = i + 1) begin: invert
			not nopcode(notOpcode[i], opcode[i]);
		end
	 endgenerate
	 
	 and branchNE(bne, isNotEqual, notOpcode[4], notOpcode[3], notOpcode[2], opcode[1], notOpcode[0]);
	 and branchLT(blt, isLessThan, notOpcode[4], notOpcode[3], opcode[2], opcode[1], notOpcode[0]);
	 
	 or branchTaken(branch, bne, blt);

endmodule
