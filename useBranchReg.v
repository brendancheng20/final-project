module useBranchReg(op, branchReg);

	input[4:0] op;
	output branchReg;

	wire[4:0] nop;
	
	genvar i;
	
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop0
			not invop(nop[i], op[i]);
		end
	endgenerate
	
	wire blt, bne;
	
	and checkBNE(bne, nop[4], nop[3], nop[2], op[1], nop[0]);
	and checkBLT(blt, nop[4], nop[3], op[2], op[1], nop[0]);
	
	or useBranchData(branchReg, blt, bne);
	
endmodule
