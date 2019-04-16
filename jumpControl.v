module jumpControl(opcode, takeJump, toggle_rd, toggle_reg);

	input[4:0] opcode;
	output takeJump, toggle_rd, toggle_reg;
	
	wire[4:0] nop;

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop0
			not invertopcode(nop[i], opcode[i]);
		end
	endgenerate
	
	wire j, jal, jr;
	and j_insn(j, nop[4], nop[3], nop[2], nop[1], opcode[0]);
	and jal_insn(jal, nop[4], nop[3], nop[2], opcode[1], opcode[0]);
	and jr_insn(jr, nop[4], nop[3], opcode[2], nop[1], nop[0]);
	
	or jump(takeJump, j, jal, jr);
	assign toggle_rd = jr;
	assign toggle_reg = jal;
	
endmodule
