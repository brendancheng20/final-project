module mw_reg(clock, we, reset, insn_in, ALU_output_in, dmem_in,
					insn_out, ALU_output_out, dmem_out);
	
	/* M/W register module. Stores ALU output, data read from DMEM, and current insn */
	
	input clock, we, reset;
	input[31:0] insn_in, ALU_output_in, dmem_in;
	output[31:0] insn_out, ALU_output_out, dmem_out;
	
	genvar i;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop0
			dffe_ref dffinsn(insn_out[i], insn_in[i], clock, we, reset);
			dffe_ref dffALU(ALU_output_out[i], ALU_output_in[i], clock, we, reset);
			dffe_ref dffdmem(dmem_out[i], dmem_in[i], clock, we, reset);
		end
	endgenerate
					
endmodule
