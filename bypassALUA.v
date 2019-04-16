module bypassALUA(dx_rs1, xm_rd, mw_rd, bypass_xm, bypass_mw, opcode);

	/* Should bypass from M or W stages into X if (xm.rd or mw.rd) = fd.rs1 or fd.rs2
	 * 
	 * xm.rd =fd.rs1 data takes precedence
	 * DO NOT bypass if jal insn
	 *
	 */

	input[4:0] dx_rs1, xm_rd, mw_rd, opcode;
	output bypass_xm, bypass_mw;
	
	/* NOTE: bypass_xm should take precedence over bypass_mw if both are asserted - X/M will have more recent value */
	
	wire[4:0] xm_comp, mw_comp;
	
	/* Check rd not 0 */
	
	wire mwN0, xmN0;
	
	nor mwOR(mwN0, mw_rd[4], mw_rd[3], mw_rd[2], mw_rd[1], mw_rd[0]);
	nor xmOR(xmN0, xm_rd[4], xm_rd[3], xm_rd[2], xm_rd[1], xm_rd[0]);
	
	/* Check not branch insn */
	wire[4:0] nopcode;
	
	invert_opcode opInvert(.opcode(opcode), .nopcode(nopcode));
	
	wire bne, blt;
	and isblt(blt, nopcode[4], nopcode[3], opcode[2], opcode[1], nopcode[0]);
	and isbne(bne, nopcode[4], nopcode[3], nopcode[2], opcode[1], nopcode[0]);
	
	genvar i;
	
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop1
			xor xm(xm_comp[i], dx_rs1[i], xm_rd[i]);
			xor mw(mw_comp[i], dx_rs1[i], mw_rd[i]); // both buses should be all 0 if same
		end
	endgenerate
	
	nor xmCheck(bypass_xm, xm_comp[4], xm_comp[3], xm_comp[2], xm_comp[1], xm_comp[0], xmN0);
	nor mwCheck(bypass_mw, mw_comp[4], mw_comp[3], mw_comp[2], mw_comp[1], mw_comp[0], mwN0, bne, blt);
	
endmodule
