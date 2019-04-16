module execute_control(opcode, alu_op_in, addi, alu_op_out);


	// TODO  impelement jump, bne, blt mux toggles

	input[4:0] opcode, alu_op_in;
	output[4:0] alu_op_out; // which alu operation should be applied?
	output addi; // should immediate field of insn be used?
	
	/* Global wires */
	// let opcode be of form abcde, with a = MSB and e = LSB
	wire na, nb, nc, nd, ne;
	not notA(na, opcode[4]);
	not notB(nb, opcode[3]);
	not notC(nc, opcode[2]);
	not notD(nd, opcode[1]);
	not notE(ne, opcode[0]);
	
	/* addi logic */
//	addi = a'bc'd'e' + a'b'ce + a'b'de' = p1 + p2 + p3
	wire p1, p2, p3;
	and and1(p1, na, nb, opcode[2], nd, opcode[0]);
	and and2(p2, na, nb, opcode[2], opcode[1], opcode[0]);
	and and3(p3, na, opcode[3], nc, nd, ne);
//	and and1(p1, na, opcode[3], nc, nd, ne);
//	and and2(p2, na, nb, opcode[2], opcode[0]);
//	and and3(p3, na, nb, opcode[1], ne);
	
	or addi_out(addi, p1, p2, p3);
	
	/* Branch logic -> for blt(00110)/bne(00010), should output ALU op of 00001 */
	wire blt, bne, isBranch;
	and isBLT(blt, na, nb, opcode[2], opcode[1], ne);
	and isBNE(bne, na, nb, nc, opcode[1], ne);
	or branchInsn(isBranch, blt, bne); // if Branch, ALUop should be subtraction
	
	/* alu_op_out logic */
	wire alu_only; // alu_only = 1 if opcode = 00000, 0 otherwise
	wire[4:0] alu_op; // predicted alu operation based on combinational logic. Only used if alu_only = 0
	nor temp(alu_only, opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]);
	
	// Calculate alu_op based on operation
	// For early implementation, only need to toggle between addition and subtraction in I-type insn
	// add = 00000, sub = 00001, so only do combinational logic for LSB. All other bits same as alu_op_in
	// alu_op[0] = 1 only for 00010 or 00110
	
	assign alu_op = isBranch ? 5'b00001 : 5'b00000;
	
	assign alu_op_out = alu_only ? alu_op_in : alu_op;
	

endmodule
