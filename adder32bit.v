module adder32bit(in1, in2, cout, sum);

	/* 32-bit CLA adder using 8 4-bit CLA adders */
	
	input[31:0] in1, in2;
	output cout;
	output[31:0] sum;
	
	/* Declare intermediate carry, propagate, generate wires */
	wire c4, P0, G0;
	wire c8, P1, G1;
	wire c12, P2, G2;
	wire c16, P3, G3;
	wire c20, P4, G4;
	wire c24, P5, G5;
	wire c28, P6, G6;
	wire P7, G7;
	
	/* Declare adder for bits 3:0 */
	cladder4bit adder3_0(in1[3:0], in2[3:0], 1'b0, sum[3:0], c4, P0, G0);
	
	/* Declare adder for bits 7:4 */
	cladder4bit adder7_4(in1[7:4], in2[7:4], c4, sum[7:4], c8, P1, G1);
	
	/* Declare adder for bits 11:8 */
	cladder4bit adder11_8(in1[11:8], in2[11:8], c8, sum[11:8], c12, P2, G2);
	
	/* Declare adder for bits 15:12 */
	cladder4bit adder15_12(in1[15:12], in2[15:12], c12, sum[15:12], c16, P3, G3);
	
	/* Declare adder for bits 19:16 */
	cladder4bit adder19_16(in1[19:16], in2[19:16], c16, sum[19:16], c20, P4, G4);
	
	/* Declare adder for bits 23:20 */
	cladder4bit adder23_20(in1[23:20], in2[23:20], c20, sum[23:20], c24, P5, G5);
	
	/* Declare adder for bits 27:24 */
	cladder4bit adder27_24(in1[27:24], in2[27:24], c24, sum[27:24], c28, P6, G6);
	
	/* Declare adder for bits 31:28 */
	cladder4bit adder31_28(in1[31:28], in2[31:28], c28, sum[31:28], cout, P7, G7);
	
endmodule
