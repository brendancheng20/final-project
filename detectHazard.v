module detectHazard(fd_rs1, fd_rs2, dx_rd, xm_rd, hazard);

	/** Asserts hazard signal if hazard is detected
	 *	 Hazards are detected if:
	 *  (fd.rs1 == dx.rd && dx.rd != 00000)
	 *  OR
	 *  (fd.rs2 == dx.rd && dx.rd != 00000)
	 *  OR
	 *  (fd.rs1 == xm.rd && xm.rd != 00000)
	 *  OR
	 *  (fd.rs2 == xm.rd ** xm.rd != 00000)
	 *
	 *  NOTE: Does not detect lw/sw hazards
	 */


	input[4:0] fd_rs1, fd_rs2, dx_rd, xm_rd;
	output hazard;
	
	wire[4:0] dx1, xm1, dx2, xm2; // dxi is bitwise fd_rsi XOR dx_rd; xmi is bitwise fd_rsi XOR xm_rd
	wire neq1, neq2, neq3, neq4;
	wire eq1, eq2, eq3, eq4, r0dx, r0xm; // r0dx, r0xm asserted if rd is 0 for those stages
	
	/* XOR fd_rsi with xm_rd or dx_rd */
	
	genvar a;
	generate
		for (a = 0; a < 5; a = a + 1) begin: loop0
			xor xordx1(dx1[a], fd_rs1[a], dx_rd[a]);
			xor xordx2(dx2[a], fd_rs2[a], dx_rd[a]);
			xor xorxm1(xm1[a], fd_rs1[a], xm_rd[a]);
			xor xorxm2(xm2[a], fd_rs2[a], xm_rd[a]);
		end
	endgenerate
	
	/* Check fd_rs1 = dx_rd */
	
	nor check1(eq1, dx1[4], dx1[3], dx1[2], dx1[1], dx1[0]); // If equal, all XOR should be 0
	
	/* Check fd_rs2 = dx_rd */
	
	nor check2(eq2, dx2[4], dx2[3], dx2[2], dx2[1], dx2[0]);
	
	/* Check fd_rs1 = xm_rd */
	
	nor check3(eq3, xm1[4], xm1[3], xm1[2], xm1[1], xm1[0]);
	
	/* Check fd_rs2 = xm_rd */
	
	nor check4(eq4, xm2[4], xm2[3], xm2[2], xm2[1], xm2[0]);
	
	/* Check if rd = 0 -> if so, no hazard */
	
	nor checkdx0(r0dx, dx_rd[4], dx_rd[3], dx_rd[2], dx_rd[1], dx_rd[0]); // 1 if dx.rd = 0
	nor checkxm0(r0xm, xm_rd[4], xm_rd[3], xm_rd[2], xm_rd[1], xm_rd[0]); // 1 if xm.rd = 0
	
	wire n0dx, n0xm;
	
	not not1(n0dx, r0dx); // 1 if dx.rd != 0
	not not2(n0xm, r0xm); // 1 if xm.rd != 0
	
	wire dxHazard1, dxHazard2, xmHazard1, xmHazard2;
	
	and hazard1(dxHazard1, eq1, n0dx); // hazard if dx.rd = fd.rs1 AND dx.rd != 0
	and hazard2(dxHazard2, eq2, n0dx);
	and hazard3(xmHazard1, eq3, n0xm);
	and hazard4(xmHazard2, eq4, n0xm);
	
	or lastOr(hazard, dxHazard1, dxHazard2, xmHazard1, xmHazard2);
	
	
	

endmodule
