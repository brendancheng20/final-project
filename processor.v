/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 //*
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                  // I: Data from port B of regfile
	 mw_out, fd, dx, xm, mw, A, B, ishazard, thispc, branchPCOut, outputOFALU, jalreg, ALUINA, ALUINB, outA, xout, firstABypass,
	 ALU_LT, branchistaken // REMOVE
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
    /* YOUR CODE STARTS HERE */
	 
	 /******************** Global *****************/
	 // Global Wires
	 // NOTE: DFFs are clocked on posedge
	 // TODO Check how clocking works with skeleton
	 // PC, pipeline registers clock on pos edge; IMEM, DMEM, and Regfile clock on negedge
	 
	 wire assertHazard; // if there is a dataHazard, assert hazard
	
	 detectHazard2 hazardDetect(.dx_op(d_insn[31:27]), .fd_rs2(f_insn[16:12]), .fd_rs1(f_insn[21:17]),
										 .dx_rd(d_insn[26:22]), .fd_op(f_insn[31:27]), .hazard(assertHazard));
//	 detectHazard hazardDetect(.fd_rs1(f_insn[21:17]), .fd_rs2(f_insn[16:12]),
//										.dx_rd(d_insn[26:22]), .xm_rd(x_insn[26:22]), .hazard(assertHazard));
	 
	 /******************** Fetch ******************/
	 wire[11:0] nextPC, pc_plusOne, f_pc, curr_pc;
	 wire[31:0] f_insn, f_insn_in;
	 wire fdWE; // fdWE is 1 if no hazard present
	 
	 not WE(fdWE, assertHazard);
	 
	 fetch Fetch(.clock(clock), .reset(reset), .next_pc(nextPC),
					 .address_imem(curr_pc), .pc_addOne(pc_plusOne));
	 
	 assign address_imem = curr_pc;
	 assign nextPC = assertHazard ? curr_pc : branch_or_pc;
	 
	 wire toggle_nopF;
	 or nop_f(toggle_nopF, takeBranch_resolve, takeJump);
	 
	 assign f_insn_in = toggle_nopF ? 32'b0 : q_imem;
	 
	 fd_reg FD(.clock(clock), .we(fdWE), .reset(reset), .insn_in(f_insn_in),
				  .pc_in(pc_plusOne), .insn_out(f_insn), .pc_out(f_pc));
				  
	 /******************** Decode *****************/
	 
	 wire[31:0] d_A, d_B, d_insn, d_insn_in; // d_insn_in = nop if assertHazard is 1, f_insn otherwise
	 wire[11:0] d_pc;
	 wire[4:0] f_nopcode;
	 wire hazard_or_branch, is_jr, toggleRegRead;
	 wire bex, issw;

	 
	 and is_sw_in_d(issw, f_nopcode[4], f_nopcode[3], f_insn[29], f_insn[28], f_insn[27]);
	
	 and is_bex_op(bex, f_insn[31], f_nopcode[3], f_insn[29], f_insn[28], f_nopcode[0]); // signal for bex insn

	 
	 or DToggleNOP(hazard_or_branch, assertHazard, takeBranch_resolve, takeJump);
	 
	 invert_opcode Dinverter(.opcode(f_insn[31:27]), .nopcode(f_nopcode));
	 and togglerd(is_jr, f_nopcode[4], f_nopcode[3], f_insn[29], f_nopcode[1], f_nopcode[0]);
	 or toggleA(toggleRegRead, useBranchRegister, is_jr);
	 
	 assign d_insn_in = hazard_or_branch ? 32'b0 : f_insn;
	 
	 wire[4:0] ctrl_readRegA_prebex, ctrl_readRegB_sw;

	 assign ctrl_readRegB_sw = issw ? f_insn[26:22] : f_insn[16:12];
	 assign ctrl_readRegB = useBranchRegister ? f_insn[21:17] : ctrl_readRegB_sw;
	 assign ctrl_readRegA_prebex = toggleRegRead ? f_insn[26:22] : f_insn[21:17];
	 assign ctrl_readRegA = bex ? 5'b11110 : ctrl_readRegA_prebex;

	 
	 dx_reg DX(.clock(clock), .we(1'b1), .reset(reset), .insn_in(d_insn_in), .pc_in(f_pc), .data_A_in(data_readRegA),
				  .data_B_in(data_readRegB), .insn_out(d_insn), .pc_out(d_pc), .data_A_out(d_A), .data_B_out(d_B));
				  
	 /******************** Execute ****************/
	 
	 wire[31:0] x_B, x_insn, x_out, ALU_out, ALU_Atemp, ALU_A, ALU_BMW, ALU_BXM;
	 wire overflow, isLessThan, isNotEqual;
	 wire[11:0] branch_pc, T, branch_pc_resolve;
	 wire bex_XStage, is_bex, is_sw;
	 
	 and checkSWInsn(is_sw, nop_d[4], nop_d[3], d_insn[29], d_insn[28], d_insn[27]);
	 
	 wire[4:0] nop_d;
	 invert_opcode XInverter(.opcode(d_insn[31:27]), .nopcode(nop_d));
	
	 or isBexCheck(is_bex, d_A[31], d_A[30], d_A[29], d_A[28], d_A[27], d_A[26], d_A[25], d_A[24],
						d_A[23], d_A[22], d_A[21], d_A[20], d_A[19], d_A[18], d_A[17], d_A[16], d_A[15],
						d_A[14], d_A[13], d_A[12], d_A[11], d_A[10], d_A[9], d_A[8], d_A[7], d_A[6],
						d_A[5], d_A[4], d_A[3], d_A[2], d_A[1], d_A[0]);
	 
	 and is_bex_opX(bex_XStage, d_insn[31], nop_d[3], d_insn[29], d_insn[28], nop_d[0]);
	 
//	 	 wire bex_XStage, is_bex;
//
//	 wire[4:0] nop_d;
//	 invert_opcode XInverter(.opcode(d_insn[31:27]), .nopcode(nop_d));
//
//	 or isBexCheck(is_bex, d_A[31], d_A[30], d_A[29], d_A[28], d_A[27], d_A[26], d_A[25], d_A[24],
//						d_A[23], d_A[22], d_A[21], d_A[20], d_A[19], d_A[18], d_A[17], d_A[16], d_A[15],
//						d_A[14], d_A[13], d_A[12], d_A[11], d_A[10], d_A[9], d_A[8], d_A[7], d_A[6],
//						d_A[5], d_A[4], d_A[3], d_A[2], d_A[1], d_A[0]);
//
//	 and is_bex_opX(bex_XStage, d_insn[31], nop_d[3], d_insn[29], d_insn[28], nop_d[0]);
	 
	 assign ALU_Atemp = bypassMW ? data_writeReg : d_A;
	 assign ALU_A = bypassXM ? x_out : ALU_Atemp;
	 
	 assign ALU_BMW = bypassMWB ? data_writeReg: d_B;
	 assign ALU_BXM = bypassXMB ? x_out : ALU_BMW;
	 
	 execute Execute(.A(ALU_A), .B(ALU_BXM), .insn(d_insn), .pc(d_pc), .ALU_out(ALU_out), .ovf(overflow), 
						  .lt(isLessThan), .neq(isNotEqual), .branch_pc(branch_pc), .jump_pc(T));
						  
	 wire[31:0] ALU_out_in;
	 assign ALU_out_in = toggle_reg ? jal_regVal : ALU_out;
	 
	 wire[31:0] x_insn_in;
	 
	 assign x_insn_in = takeBranch_resolve ? 32'b0 : d_insn; // togge nop on branch taken
	 
	 xm_reg XM(.clock(clock), .we(1'b1), .reset(reset), .insn_in(x_insn_in), .ALU_output_in(ALU_out_in), .data_B_in(ALU_BXM),
					.insn_out(x_insn), .ALU_output_out(x_out), .data_B_out(x_B), .lt(isLessThan), .ne(isNotEqual),
					.lt_out(lt_out), .ne_out(ne_out), .branchPC_in(branch_pc), .branchPC_out(branch_pc_resolve));
					
	 // Implement j, jal, jr
	 wire takeJump, toggle_rd, toggle_reg; // takeJump = is jump insn? toggle_rd = toggle whether to use T field or rd (for jr)
	 jumpControl jumpController(.opcode(d_insn[31:27]), .takeJump(takeJump), .toggle_rd(toggle_rd),
										 .toggle_reg(toggle_reg));
	 wire[11:0] jumpPC, tempPC;
	 wire[31:0] jal_regVal;
	 wire takeJumpOrBex, bexCtrl;
	 and controlBex(bexCtrl, is_bex, bex_XStage);
	 or lastone(takeJumpOrBex, takeJump, bexCtrl);
	 assign jumpPC = toggle_rd ? d_A[11:0] : T;
	 assign tempPC = takeJumpOrBex ? jumpPC : pc_plusOne;
	 assign jal_regVal[11:0] = d_pc;
	 assign jal_regVal[31:12] = 20'b0;
	 
	 
	 /******************** Memory *****************/
	 
	 wire[31:0] m_insn, m_dmem, m_out;
	 
	 assign address_dmem = x_out[11:0];
	 assign data = WMbypass ? data_writeReg : x_B;
	 
	 /* Assign wren based on opcode 00111 for sw insn */
	 
	 wire nopcode31, nopcode30; // inverted 32nd and 31st bits of insn (first two bits of opcode)
	 
	 not not31(nopcode31, x_insn[31]);
	 not not30(nopcode30, x_insn[30]);
	 
	 and DMEMWE(wren, nopcode31, nopcode30, x_insn[29], x_insn[28], x_insn[27]);
	 
	 mw_reg MW(.clock(clock), .we(1'b1), .reset(reset), .insn_in(x_insn), .ALU_output_in(x_out),
				  .dmem_in(q_dmem), .insn_out(m_insn), .ALU_output_out(m_out), .dmem_out(m_dmem));
	 
	 /******************** Writeback **************/
	 
	 /* NOTE: insn stored in M/W register used to toggle WE of regfile and which register gets written to */
	 
	 /* Control signals */ 
	 wire data_toggle; // 1 if dmem data should be written (on lw), 0 if ALU data should be written (to regfile)
	 wire regfile_we; // write enable for regfile, based on m_insn
	 
	 /* Intermediate wires */
	 wire[4:0] wnopcode;
	 wire p1, p2, p3, p4;
	 
	 /* Assign data_toggle signal */
	 invert_opcode Minverter(.opcode(m_insn[31:27]), .nopcode(wnopcode));
	 and lw_toggle(data_toggle, wnopcode[4], m_insn[30], wnopcode[2], wnopcode[1], wnopcode[0]);
	 assign data_writeReg = data_toggle ? m_dmem : m_out;
	 
	 /* Use m_insn to determine regfile control signals ctrl_writeEnable and ctrl_writeReg */
	 
	 assign ctrl_writeReg = p4 ? 5'b11111 : m_insn[26:22];
	 wire we_noclock;
	 
	 // ctrl_writeEnable = opcodes 00101 + 01000 + (ALU op and opcode 00000) + 10101 + 00011
	 and andM1(p1, wnopcode[4], m_insn[30], wnopcode[2], wnopcode[1], wnopcode[0]);
	 and andM2(p2, wnopcode[4], wnopcode[3], m_insn[29], wnopcode[1], m_insn[27]);
	 and andM3(p3, wnopcode[4], wnopcode[3], wnopcode[2], wnopcode[1], wnopcode[0]);
	 and andM4(p4, wnopcode[4], wnopcode[3], wnopcode[2], m_insn[28], m_insn[27]);
	 or assignWE(ctrl_writeEnable, p1, p2, p3, p4);
	 
	 /* Bypassing */
	 
	 // NOTE if useBranchBypass is asserted, bypassing uses different registers
	 wire[4:0] branchrsA, branchrsB_init, branchrsB;
	 wire useBranchBypass_branchNotTaken;
	 assign branchrsA = useBranchBypass ? d_insn[26:22] : d_insn[21:17];
	 assign branchrsB_init = useBranchBypass ? d_insn[21:17] : d_insn[16:12];
	 assign branchrsB = is_sw ? d_insn[26:22] : branchrsB_init;
	 
	 // W-M Bypassing
	 wire WMbypass;
	 bypassWM WMbpunit(.xm_opcode(x_insn[31:27]), .xm_rd(x_insn[26:22]),
							 .mw_rd(m_insn[26:22]), .WMbypass(WMbypass));
							 
	 // ALU in A Bypassing
//	 wire bypassXM, bypassMW;
//	 bypassALUA ALUAbp(.dx_rs1(d_insn[21:17]), .xm_rd(x_insn[26:22]), .mw_rd(m_insn[26:22]),
//							 .bypass_xm(bypassXM), .bypass_mw(bypassMW));
//							 
//	 // ALU in B Bypassing
//	 wire bypassXMB, bypassMWB;
//	 bypassALUA ALUBbp(.dx_rs1(d_insn[16:12]), .xm_rd(x_insn[26:22]), .mw_rd(m_insn[26:22]),
//							 .bypass_xm(bypassXMB), .bypass_mw(bypassMWB));

	 wire bypassXM, bypassMW;
	 bypassALUA ALUAbp(.dx_rs1(branchrsA), .xm_rd(x_insn[26:22]), .mw_rd(m_insn[26:22]),
							  .bypass_xm(bypassXM_temp), .bypass_mw(bypassMW_temp), .opcode(m_insn[31:27]));
							  
	 wire bypassXMB, bypassMWB;
	 wire bypassXM_temp, bypassMW_temp, bypassXMB_temp, bypassMWB_temp;
	 and yes(bypassXM, bypassXM_temp, ignoreBranchBypassM);
	 and yes2(bypassXMB, bypassXMB_temp, ignoreBranchBypassM);
	 and yes3(bypassMW, bypassMW_temp, ignoreBranchBypassW);
	 and yes4(bypassMWB, bypassMWB_temp, ignoreBranchBypassW);
	 
	 // mux dx_rs1 for ALUB to dx.rd if sw insn
	 bypassALUA ALUBbp(.dx_rs1(branchrsB), .xm_rd(x_insn[26:22]), .mw_rd(m_insn[26:22]),
							 .bypass_xm(bypassXMB_temp), .bypass_mw(bypassMWB_temp), .opcode(m_insn[31:27]));
	 
	 /* BRANCHING */
	 // Should branch data be used (i.e. is Branch insn?)
	 wire useBranchRegister, useBranchBypass, branchInM, branchInW, notBranchInX, ignoreBranchBypassW;
	 wire ignoreBranchBypassM;
	 useBranchReg checkBranchInsn(f_insn[31:27], useBranchRegister);
	 useBranchReg checkBranchExec(d_insn[31:27], useBranchBypass);
	 useBranchReg checkBranchM(x_insn[31:27], branchInM); // check branch insn in X/M
	 useBranchReg checkBranchW(m_insn[31:27], branchInW); // check branch insn in M/W
	 not checkNoBranchX(notBranchInX, useBranchBypass);
	 nand dontBypassBranchM(ignoreBranchBypassM, notBranchInX, branchInM);
	 nand dontBypassBranchW(ignoreBranchBypassW, notBranchInX, branchInW);
	 
	 
	 // Should branch be taken?
	 wire takeBranch_resolve, lt_out, ne_out; // control signal that toggles whether branc his taken
	 wire[11:0] branch_or_pc; // output of mux toggling branch_pc and pc_PlusOne
	 takeBranch tb(.opcode(x_insn[31:27]), .isNotEqual(ne_out), .isLessThan(lt_out), .branch(takeBranch_resolve));
	 
	 assign branch_or_pc = takeBranch_resolve ? branch_pc_resolve : tempPC;
	 
	 /* JUMPS */
	 
	 /* TESTING WIRES */
	 
	 output[31:0] fd, dx, xm, mw, mw_out, A, B;
	 output ishazard;
	 output[11:0] thispc;
	 assign fd = f_insn;
	 assign dx = d_insn;
	 assign xm = x_insn;
	 assign mw = m_insn;
	 assign mw_out = data_writeReg;
	 assign A = d_A;
	 assign B = d_B;
	 assign ishazard = takeBranch_resolve;
	 assign thispc = curr_pc;
	 output[11:0] branchPCOut;
	 assign branchPCOut = branch_pc_resolve;
	 output[31:0] outputOFALU;
	 assign outputOFALU = x_out;
	 output[31:0] jalreg;
	 assign jalreg = jal_regVal;
	 output[31:0] ALUINA, ALUINB, outA;
	 assign ALUINA = ALU_A;
	 assign ALUINB = ALU_BXM;
	 assign outA = ALU_out;
	 output[31:0] xout;
	 assign xout = x_out;
	 output firstABypass;
	 assign firstABypass = bypassXM;
	 output ALU_LT;
	 assign ALU_LT = isLessThan;
	 output branchistaken;
	 assign branchistaken = takeBranch_resolve;
	 
endmodule
