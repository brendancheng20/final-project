module fd_reg(clock, we, reset, insn_in, pc_in, insn_out, pc_out);

	/* F/D register in pipeline. Stores instruction and pc + 4 */

	/* Control signals */

	input clock, we, reset;
	
	/* Instruction data I/O */
	input[31:0] insn_in;
	output[31:0] insn_out;
	
	/* PC data I/O */
	
	input[11:0] pc_in;
	output[11:0] pc_out;

	/************** Fetch register with input/output signals for important data ************/
	
	/* Instruction data */
	genvar i;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop0
			dffe_ref dffinsn(insn_out[i], insn_in[i], clock, we, reset);
		end
	endgenerate
	
	/* Progam Counter Data */
	
	genvar k;
	
	generate
		for (k = 0; k < 12; k = k + 1) begin: loop1
			dffe_ref dffpc(pc_out[k], pc_in[k], clock, we, reset);
		end
	endgenerate
	
endmodule
