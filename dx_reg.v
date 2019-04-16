module dx_reg(clock, we, reset, insn_in, pc_in, data_A_in, data_B_in,
					insn_out, pc_out, data_A_out, data_B_out);

	/* D/X register in pipeline. Stores PC + 4, Instruction, and data from register ports A and B */
	
	input clock, we, reset;
	input[31:0] insn_in, data_A_in, data_B_in;
	input[11:0] pc_in;
	
	output[31:0] insn_out, data_A_out, data_B_out;
	output[11:0] pc_out;
	
	/* Generate A, B data register and insn registers */
	
	genvar i;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop0
			dffe_ref dffinsn(insn_out[i], insn_in[i], clock, we, reset);
			dffe_ref dffA(data_A_out[i], data_A_in[i], clock, we, reset);
			dffe_ref dffB(data_B_out[i], data_B_in[i], clock, we, reset);
		end
	endgenerate
	
	/* Generate PC register */
	
	genvar k;
	
	generate
		for (k = 0; k < 12; k = k + 1) begin: loop1
			dffe_ref dffpc(pc_out[k], pc_in[k], clock, we, reset);
		end
	endgenerate
					
endmodule
