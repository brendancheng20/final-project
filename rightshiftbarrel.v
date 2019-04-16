module rightshiftbarrel(in, out, shamt);
	
	/* Barrel shifter, capable of right-shifting the input by up to 31 bits based on 
		shamt input */
		
	input[31:0] in;
	input[4:0] shamt;
	output[31:0] out;
	
	wire[31:0] shift16, shift8, shift4, shift2, shift1; /* wires containing shifted data from shifter to mux. shiftn refers to 
									wire carrying data that was shifted n bits */
	wire[31:0] in8, in4, in2, in1; /* wires leaving 1 mux and entering the next shifter/mux in the barrel. in_k refers
												 to data entering the k-bit shifter */
									
	/* Shift 16 bits */
									
	rightshift16bit s16(in, shift16);
	mux2_1 mux16_8(in, shift16, in8, shamt[4]); // outputs shift16 if shamt[4] asserted, else outputs in
	
	/* Shift 8 bits */
	
	rightshift8bit s8(in8, shift8);
	mux2_1 mux8_4(in8, shift8, in4, shamt[3]); // outputs shift8 if shamt[3] asserted, else outputs in8
	
	/* Shift 4 bits */
	
	rightshift4bit s4(in4, shift4);
	mux2_1 mux4_2(in4, shift4, in2, shamt[2]);
	
	/* Shift 2 bits */
	
	rightshift2bit s2(in2, shift2);
	mux2_1 muxtwo_1(in2, shift2, in1, shamt[1]);
	
	/* Shift 1 bit + output */
	
	rightshift1bit s1(in1, shift1);
	mux2_1 outmux(in1, shift1, out, shamt[0]);
	
	
	
endmodule
