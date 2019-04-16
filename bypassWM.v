module bypassWM(xm_opcode, xm_rd, mw_rd, WMbypass);

//TODO Implement for any writeback insns

	/** Bypasses writeback if there is an insn that writes to regfile followed immediately by sw.
	 *	 Input: M/W opcode, X/M opcode
	 *  Input: xm.rd, mw.rd (i.e. is the lw instruction storing somwthing that will be written by the sw instruction?)
	 *	 Output: ctrl signal in which the data is the writeback data as opposed to x_B
	 */
	
	input[4:0] xm_opcode, xm_rd, mw_rd;
	output WMbypass;
	
	/* Invert opcodes for logic */
	wire[4:0] n_mw, n_xm; // inverted opcodes
	
	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1) begin: loop0
			not invxm(n_xm[i], xm_opcode[i]);
		end
	endgenerate
	
	/* Check 0 */
	
	wire rdN0;
	
	or rdNot0(rdN0, xm_rd[4], xm_rd[3], xm_rd[2], xm_rd[1], xm_rd[0]);
	
	/* Generate wires for and xm_opcode = sw */
	
	wire sw;
	
	and checkSW(sw, n_xm[4], n_xm[3], xm_opcode[2], xm_opcode[1], xm_opcode[0]);
	
	/* Compare xm_rd and mw_rd. If equal, assert sameRD */
	
	wire[4:0] rdComp;
	wire sameRD;
	
	genvar k;
	generate
		for (k = 0; k < 5; k = k + 1) begin: loop1
			xor compRD(rdComp[k], xm_rd[k], mw_rd[k]); // rdComp[k] = 1 if xm.rd and mw.rd are different
		end
	endgenerate
	
	nor isSameDest(sameRD, rdComp[4], rdComp[3], rdComp[2], rdComp[1], rdComp[0]); // only 1 if all bits of xm.rd and mw.rd are same
	
	and canBypass(WMbypass, sameRD, sw, rdN0);
	
	
endmodule
