module fetch(clock, reset, next_pc, address_imem, pc_addOne);

/** Fetch portion of pipeline
 * Contains PC register
 * Outputs output of pc register and output of pc register + 1 for use in IMEM/Pipeline
 * Inputs are clock (inverted so that PC register clocks on positive edge) and next_pc
 * next_pc = either pc+1 or pc dictated by jump/branch */

		/***** Inputs/Outputs ********/

		input clock, reset; // Clock input. Will be inverted to allow PC to clock on pos edge
		input[11:0] next_pc; // Next pc address to be written to pc register
		output[11:0] address_imem, pc_addOne; // address_imem = address outputted to imem
														  // pc_addOne = pc + 1; next_pc if no branch/jump
		
		/****** Global Wires *********/
		
		wire[31:0] pc; // current output of PC register
		wire[31:0] pc_plus_1; // 32 bit version of pc_addOne for logistical purposes
		
		assign pc[31:12] = 20'b00000000000000000000;
		
		/****** Module ***********/
		
		pc_reg PC(.clock(clock), .ctrl_writeEnable(1'b1), .ctrl_reset(reset),
					 .data_writeReg(next_pc), .data_read(pc[11:0])); // PC register always write enabled
					 
		assign address_imem = pc[11:0];
		
		adder32bit pc_adder(.in1(pc), .in2(32'd1), .cout(), .sum(pc_plus_1));
		
		assign pc_addOne = pc_plus_1[11:0];

endmodule
