module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   /* Declare wire bus that leaves decoder for ALUopcode */
	
	wire[31:0] ALUop;
	
	/* Declare intermediate wires */
	
	wire[31:0] add_sub_result, or_result, and_result, sll_result, sra_result;
	
	/* Connect ctrl_ALUopcode to decoder */
	
	decoder5_32 aludecode(ctrl_ALUopcode, ALUop);
	
	/* Connect adder */
	
	add_sub adder(data_operandA, data_operandB, ALUop[1], ovf_case, add_sub_result);
	tristate add_tri(ALUop[0], add_sub_result, data_result);
	tristate sub_tri(ALUop[1], add_sub_result, data_result);
	or overflowOr(overflow, ovf_case, 1'b0);
	
	/* Connect bitwise AND */
	
	bitwise_and and_boi(data_operandA, data_operandB, and_result); // connect inputs to and_result, the intermediate wire
	tristate and_tri(ALUop[2], and_result, data_result); // connect and_result to tristate buffer and output for ALUop 2
	
	/* Connect bitwise OR */
	
	bitwise_or or_boi(data_operandA, data_operandB, or_result); // connect inputs to or_result, the intermediate wire
	tristate or_tri(ALUop[3], or_result, data_result); // connect or_result to tristate buffer and output for ALUop 3
	
	/* Connect SLL */
	
	leftshiftbarrel lshifter(data_operandA, sll_result, ctrl_shiftamt); // connect dataA to left shifter
	tristate sll_tri(ALUop[4], sll_result, data_result); // connect to output
	
	/* Connect SRA */
	
	rightshiftbarrel rshifter(data_operandA, sra_result, ctrl_shiftamt); // connect dataA to right shifter
	tristate sra_tri(ALUop[5], sra_result, data_result); // connect to output
	
	/* Connect information signals */
	
	/* A < B iff result[31] = 1 (i.e. negative) OR in the case of -B and positive result,
		if A[31] = 1 and B[31] = 1, but result[31] = 0 */
		
	wire  nsignResult, ovf_case, pos_result, nsignB, nsignA, notwrap, islt, wrapneg, wrappos, notovf; // ovf_case tests the intial signs of A and B in case overflow occurs
									// nsignB = NOT B[31] for the sake of ANDing sign bits together for ovf_case
									
	not not_resultSign(nsignResult, add_sub_result[31]);
	not noOverflow(notovf, ovf_case);
	and case1(wrapneg, add_sub_result[31], notovf);
	and case2(wrappos, nsignResult, ovf_case);
	or lt(isLessThan, wrapneg, wrappos);
//	not not_signB(nsignB, data_operandB[31]);
//	not not_signA(nsignA, data_operandA[31]);
//	not not_resultSign(nsignResult, add_sub_result[31]);
//	and posresult(pos_result, data_result[31], data_operandB[31], data_operandA[31]);
////	and posresult(pos_result, nsignResult, data_operandB[31], data_operandA[31]);
//	and overflow_case(ovf_case, data_operandA[31], nsignB);
//	and wraparound(wrap, data_operandB[31], nsignA, data_result[31]); // if B < A and B is negative, so A-B results in neg result
//	not nowrap(notwrap, wrap);
//	
//	or lt(islt, ovf_case, data_result[31], pos_result); // signal depends on either overflow case or simply negative sub result
//	and finalone(isLessThan, islt, notwrap);
	
	/* A != B if A - B != 0 */  
	wire assert_eq;
	check_eq iseq(add_sub_result, assert_eq);
	not ne(isNotEqual, assert_eq);

endmodule
