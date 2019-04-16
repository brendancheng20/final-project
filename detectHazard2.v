module detectHazard2(dx_op, fd_rs2, fd_rs1, dx_rd, fd_op, hazard);

	/* Stall if dx.opcode = load && (fd.rs2 = dx.rd || (fd.rs1 = dx.rd && fd.opcode != store)) */
	input[4:0] dx_op, fd_rs2, fd_rs1, dx_rd, fd_op;
	output hazard;
	
	/* Invert opcodes */
	
	wire[4:0] n_dx, n_fd;
	
	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop0
			not DX(n_dx[i], dx_op[i]); // invert dx.opcode
			not FD(n_fd[i], fd_op[i]); // invert fd.opcode
			xor compfdrs2(dxrs2[i], fd_rs2[i], dx_rd[i]); 
			xor compfdrs1(dxrs1[i], fd_rs1[i], dx_rd[i]);
		end
	endgenerate
	
	/* Check if rd != 0. If 0, don't want hazard */
	wire rdNot0;
	or isNotreg0(rdNot0, dx_rd[4], dx_rd[3], dx_rd[2], dx_rd[1], dx_rd[0]);
	
	/* Check load insn */
	
	wire load; // asserted if dx.opcode = load insn opcode
	and checkLoad(load, n_dx[4], dx_op[3], n_dx[2], n_dx[1], n_dx[0]);
	
	/* Check fd.rs2 = dx.rd */
	wire[4:0] dxrs2;
	wire rs2nedx;
	
	nor check1(rs2nedx, dxrs2[4], dxrs2[3], dxrs2[2], dxrs2[1], dxrs2[0]);
	
	/* Check not store insn */
	wire nsw;
	nand notSW(nsw, n_fd[4], n_fd[3], fd_op[2], fd_op[1], fd_op[0]);
	
	/* Check fd.rs1 = dx.rd */
	wire[4:0] dxrs1;
	wire rs1nedx;
	
	nor check2(rs1nedx, dxrs1[4], dxrs1[3], dxrs1[2], dxrs1[1], dxrs1[0]);
	
	// Combine
	wire term1, term2, possibleHazard;
	
//	and and1(term1, load, rs2nedx);
	and and2(term2, nsw, rs1nedx);
	or and1(term1, term2, rs2nedx);
	
	and and3(possibleHazard, term1, load);
//	or lastOr(possibleHazard, term1, term2);
	// possibleHazard and NOT 0
	and lastAnd(hazard, possibleHazard, rdNot0);

endmodule