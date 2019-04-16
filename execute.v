module execute(A, B, insn, pc, ALU_out, ovf, lt, neq, branch_pc, jump_pc);

	input[31:0] A, B, insn;
	input[11:0] pc;
	
	output[31:0] ALU_out;
	output[11:0] branch_pc, jump_pc;
	output ovf, lt, neq;

	wire addi; // control signal for I-type insn vs any other type
	wire[4:0] opcode_in; // opcode inputted to ALU
	wire[31:0] operandB; // operand inputted to B port of ALU
	wire[31:0] immed, immedShift; // sign extended immediate, from I field of insn
	wire[31:0] pc_plus_i; // 32-bit representation of PC to jump to if branch taken
	
	sign_extend sx(insn[16:0], immed);
	
	assign operandB = addi ? immed : B;
	assign jump_pc = insn[11:0]; // lower 12 bits of jump instruction
	assign immedShift = immed << 2; // shift immed left 2 for branch insn
	
	adder32bit pc_adder(.in1(pc), .in2(immed), .cout(), .sum(pc_plus_i)); // add I field to pc for branch
	
	assign branch_pc = pc_plus_i[11:0];
	
	execute_control ctrl(.opcode(insn[31:27]), .alu_op_in(insn[6:2]), .addi(addi), .alu_op_out(opcode_in));
	
	alu ALU(.data_operandA(A), .data_operandB(operandB), .ctrl_ALUopcode(opcode_in), .ctrl_shiftamt(insn[11:7]),
		 .data_result(ALU_out), .isNotEqual(neq), .isLessThan(lt), .overflow(ovf));
	
endmodule
