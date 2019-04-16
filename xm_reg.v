module xm_reg(clock, we, reset, insn_in, ALU_output_in, data_B_in, lt, ne, branchPC_in,
					insn_out, ALU_output_out, data_B_out, lt_out, ne_out, branchPC_out);

	/* X/M register in pipeline. Stores output of ALU from X stage, data read from regfile port B,
		and current insn */
	
	input clock, we, reset, lt, ne;
	input[31:0] insn_in, ALU_output_in, data_B_in;
	input[11:0] branchPC_in;
	output[31:0] insn_out, ALU_output_out, data_B_out;
	output lt_out, ne_out;
	output[11:0] branchPC_out;
	
	dffe_ref ltSignal(lt_out, lt, clock, we, reset);
	dffe_ref neSignal(ne_out, ne, clock, we, reset);
	genvar k;
	generate
		for (k = 0; k < 12; k = k + 1) begin: loop1
			dffe_ref branchPC(branchPC_out[k], branchPC_in[k], clock, we, reset);
		end
	endgenerate
	
	genvar i;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop0
			dffe_ref dffinsn(insn_out[i], insn_in[i], clock, we, reset);
			dffe_ref dffALU(ALU_output_out[i], ALU_output_in[i], clock, we, reset);
			dffe_ref dffB(data_B_out[i], data_B_in[i], clock, we, reset);
		end
	endgenerate

endmodule
