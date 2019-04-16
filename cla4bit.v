module cla4bit(in1, in2, c0, cout, P, G);

	/* Carry-lookahead that finds each internal carry and c4 based on the operands being added*/

	input[3:0] in1, in2; // data operands
	input c0; // carry-in (c0);
	output[3:0] cout; // carry-out using cla - bus represents c1:c4
	output P, G;
	
	/* Declare wires for cout calculation */
	wire g3, g2, g1, g0, p3, p2, p1, p0; // basic generate/propagate
	wire p0c0; // g/p combos for c1
	wire p1g0, p1p0c0; // g/p combos for c2
	wire p2g1, p2p1g0, p2p1p0c0; // g/p combos for c3
	wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0; // generate/propagate combos for c4
	
	/* Wire each propagate and generate */
	
	and andg3(g3,in1[3],in2[3]);
	or orp3(p3, in1[3],in2[3]);
	and andg2(g2, in1[2],in2[2]);
	or orp2(p2,in1[2],in2[2]);
	and andg1(g1,in1[1],in2[1]);
	or orp1(p1,in1[1],in2[1]);
	and andg0(g0,in1[0],in2[0]);
	or org0(p0,in1[0],in2[0]);
	
	/* Calculate c1 */
	
	and andp0c0(p0c0, p0, c0);
	or orc1(cout[0], g0, p0c0);
	
	/* Calculate c2 */
	
	and andp1g0(p1g0, p1, g0);
	and andp1p0c0(p1p0c0, p1, p0, c0);
	or orc2(cout[1], g1, p1g0, p1p0c0);
	
	/* Calculate c3 */
	
	and andp2g1(p2g1, p2, g1);
	and andp2p1g0(p2p1g0, p2, p1, g0);
	and andp2p1p0c0(p2p1p0c0, p2, p1, p0, c0);
	or orc3(cout[2], g2, p2g1, p2p1g0, p2p1p0c0);
	
	/* Calculate carry-out (c4) */
	
	and andp3g2(p3g2, p3, g2);
	and andp3p2g1(p3p2g1, p3, p2, g1);
	and andp3p2p1g0(p3p2p1g0, p3, p2, p1, g0);
	and andp3p2p1p0c0(p3p2p1p0c0, p3, p2, p1, p0, c0);
	or orc4(cout[3], g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);
	
	/* Calculate P and G */
	and andP(P, p3, p2, p1, p0);
	or orG(G, g3, p3g2, p3p2g1, p3p2p1g0);

endmodule
