module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
	 reg1Button, reg2Button, reg3Button, reg4Button,
	 reg5Button, reg6Button, reg7Button,
	 reg8Button, reg9Button, data30
//	 data_reg3, data_reg4, data_reg1
);

// TODO Implement design such that button push writes to corresponding register @posedge. Also
// Update software so that upon jumping to new screen, resets register value to 0. That way
// Register will be nonzero for long enough that a branch will read the value but then it wont keep
// setting to 1 if button is pushed for longer
/*
 * 4/16/19: Updated so $r1, $r2, $r3, $r4 are asynchronous buttons for gameplay
 */

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB; // write destination reg, read regA, read regB
   input [31:0] data_writeReg; // data to be written on write enable
	input reg1Button, reg2Button, reg3Button, reg4Button, reg5Button;
	input reg6Button, reg7Button, reg8Button, reg9Button;

   output [31:0] data_readRegA, data_readRegB; // data read from regA, data read from regB
	output[31:0] data30;
	
	assign data30 = out30;
	
	/* TESTING CODE FOR PROCESSOR - DELETE BEFORE SUBMISSION */
	
//	output[31:0] data_reg3, data_reg4, data_reg1; // output of register 3, just for the sake of seeing how data gets stored
//	assign data_reg3 = out3;
//	assign data_reg4 = out4;
//	output[31:0] data_reg1, data_reg2;
//	assign data_reg1 = out1;
//	assign data_reg2 = out2;
	
	/* END TESTING CODE */
	
	/* Declare enable wires - enable wires entering registers
		Each register's enable is based on ctrl_writeEnable AND-ed
		with the ctrl_writeReg one-hot */
		
	wire en0, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10;
	wire en11, en12, en13, en14, en15, en16, en17, en18;
	wire en19, en20, en21, en22, en23, en24, en25, en26, en27;
	wire en28, en29, en30, en31;
	
	/* Declare write enable one-hot bus; read one-hot buses */
	
	wire[31:0] WEonehot, RAonehot, RBonehot;
	
	/* Declare register output wire buses - wires leaving registers 
		to potentially be read */
	
	wire [31:0] out0, out1, out2, out3, out4, out5, out6, out7;
	wire [31:0] out8, out9, out10, out11, out12, out13, out14;
	wire [31:0] out15, out16, out17, out18, out19, out20, out21;
	wire [31:0] out22, out23, out24, out25, out26, out27, out28;
	wire [31:0] out29, out30, out31;
	
	/* Declare registers */
	
	register reg0(clock, 1'b0, 1'b1, 32'h00000000, out0);
	assign out1 = reg1Button ? 32'b1 : 32'b0;
	assign out2 = reg2Button ? 32'b1 : 32'b0;
	assign out3 = reg3Button ? 32'b1 : 32'b0;
	assign out4 = reg4Button ? 32'b1 : 32'b0;
	assign out5 = reg5Button ? 32'b1 : 32'b0;
	assign out6 = reg6Button ? 32'b1 : 32'b0;
	assign out7 = reg7Button ? 32'b1 : 32'b0;
	assign out8 = reg8Button ? 32'b1 : 32'b0;
	assign out9 = reg9Button ? 32'b1 : 32'b0;
//	register reg1(clock, en1, ctrl_reset, data_writeReg, out1);
//	register reg2(clock, en2, ctrl_reset, data_writeReg, out2);
//	register reg3(clock, en3, ctrl_reset, data_writeReg, out3);
//	register reg4(clock, en4, ctrl_reset, data_writeReg, out4);
//	register reg5(clock, en5, ctrl_reset, data_writeReg, out5);
//	register reg6(clock, en6, ctrl_reset, data_writeReg, out6);
//	register reg7(clock, en7, ctrl_reset, data_writeReg, out7);
//	register reg8(clock, en8, ctrl_reset, data_writeReg, out8);
//	register reg9(clock, en9, ctrl_reset, data_writeReg, out9);
	register reg10(clock, en10, ctrl_reset, data_writeReg, out10);
	register reg11(clock, en11, ctrl_reset, data_writeReg, out11);
	register reg12(clock, en12, ctrl_reset, data_writeReg, out12);
	register reg13(clock, en13, ctrl_reset, data_writeReg, out13);
	register reg14(clock, en14, ctrl_reset, data_writeReg, out14);
	register reg15(clock, en15, ctrl_reset, data_writeReg, out15);
	register reg16(clock, en16, ctrl_reset, data_writeReg, out16);
	register reg17(clock, en17, ctrl_reset, data_writeReg, out17);
	register reg18(clock, en18, ctrl_reset, data_writeReg, out18);
	register reg19(clock, en19, ctrl_reset, data_writeReg, out19);
	register reg20(clock, en20, ctrl_reset, data_writeReg, out20);
	register reg21(clock, en21, ctrl_reset, data_writeReg, out21);
	register reg22(clock, en22, ctrl_reset, data_writeReg, out22);
	register reg23(clock, en23, ctrl_reset, data_writeReg, out23);
	register reg24(clock, en24, ctrl_reset, data_writeReg, out24);
	register reg25(clock, en25, ctrl_reset, data_writeReg, out25);
	register reg26(clock, en26, ctrl_reset, data_writeReg, out26);
	register reg27(clock, en27, ctrl_reset, data_writeReg, out27);
	register reg28(clock, en28, ctrl_reset, data_writeReg, out28);
	register reg29(clock, en29, ctrl_reset, data_writeReg, out29);
	register reg30(clock, en30, ctrl_reset, data_writeReg, out30);
	register reg31(clock, en31, ctrl_reset, data_writeReg, out31);
	
	/* Declare writeEnable decoder */
	decoder5_32 decodeWE(ctrl_writeReg,WEonehot); // write enable decoder connected to en bus
	
	/* AND write enable decode one-hots with actual write enable */
	and we0(en0, WEonehot[0], ctrl_writeEnable);
	and we1(en1, WEonehot[1], ctrl_writeEnable);
	and we2(en2, WEonehot[2], ctrl_writeEnable);
	and we3(en3, WEonehot[3], ctrl_writeEnable);
	and we4(en4, WEonehot[4], ctrl_writeEnable);
	and we5(en5, WEonehot[5], ctrl_writeEnable);
	and we6(en6, WEonehot[6], ctrl_writeEnable);
	and we7(en7, WEonehot[7], ctrl_writeEnable);
	and we8(en8, WEonehot[8], ctrl_writeEnable);
	and we9(en9, WEonehot[9], ctrl_writeEnable);
	and we10(en10, WEonehot[10], ctrl_writeEnable);
	and we11(en11, WEonehot[11], ctrl_writeEnable);
	and we12(en12, WEonehot[12], ctrl_writeEnable);
	and we13(en13, WEonehot[13], ctrl_writeEnable);
	and we14(en14, WEonehot[14], ctrl_writeEnable);
	and we15(en15, WEonehot[15], ctrl_writeEnable);
	and we16(en16, WEonehot[16], ctrl_writeEnable);
	and we17(en17, WEonehot[17], ctrl_writeEnable);
	and we18(en18, WEonehot[18], ctrl_writeEnable);
	and we19(en19, WEonehot[19], ctrl_writeEnable);
	and we20(en20, WEonehot[20], ctrl_writeEnable);
	and we21(en21, WEonehot[21], ctrl_writeEnable);
	and we22(en22, WEonehot[22], ctrl_writeEnable);
	and we23(en23, WEonehot[23], ctrl_writeEnable);
	and we24(en24, WEonehot[24], ctrl_writeEnable);
	and we25(en25, WEonehot[25], ctrl_writeEnable);
	and we26(en26, WEonehot[26], ctrl_writeEnable);
	and we27(en27, WEonehot[27], ctrl_writeEnable);
	and we28(en28, WEonehot[28], ctrl_writeEnable);
	and we29(en29, WEonehot[29], ctrl_writeEnable);
	and we30(en30, WEonehot[30], ctrl_writeEnable);
	and we31(en31, WEonehot[31], ctrl_writeEnable);
	
	/* Declare read decoders */
	
	decoder5_32 decodeReadA(ctrl_readRegA,RAonehot);
	decoder5_32 decodeReadB(ctrl_readRegB,RBonehot);
	
	/* Declare connections to tristates from read decoders
		and registers to output */
	
	tristate tri0A(.in(out0), .ctrl(RAonehot[0]), .out(data_readRegA));
	tristate tri1A(.in(out1), .ctrl(RAonehot[1]), .out(data_readRegA));
	tristate tri2A(.in(out2), .ctrl(RAonehot[2]), .out(data_readRegA));
	tristate tri3A(.in(out3), .ctrl(RAonehot[3]), .out(data_readRegA));
	tristate tri4A(.in(out4), .ctrl(RAonehot[4]), .out(data_readRegA));
	tristate tri5A(.in(out5), .ctrl(RAonehot[5]), .out(data_readRegA));
	tristate tri6A(.in(out6), .ctrl(RAonehot[6]), .out(data_readRegA));
	tristate tri7A(.in(out7), .ctrl(RAonehot[7]), .out(data_readRegA));
	tristate tri8A(.in(out8), .ctrl(RAonehot[8]), .out(data_readRegA));
	tristate tri9A(.in(out9), .ctrl(RAonehot[9]), .out(data_readRegA));
	tristate tri10A(.in(out10), .ctrl(RAonehot[10]), .out(data_readRegA));
	tristate tri11A(.in(out11), .ctrl(RAonehot[11]), .out(data_readRegA));
	tristate tri12A(.in(out12), .ctrl(RAonehot[12]), .out(data_readRegA));
	tristate tri13A(.in(out13), .ctrl(RAonehot[13]), .out(data_readRegA));
	tristate tri14A(.in(out14), .ctrl(RAonehot[14]), .out(data_readRegA));
	tristate tri15A(.in(out15), .ctrl(RAonehot[15]), .out(data_readRegA));
	tristate tri16A(.in(out16), .ctrl(RAonehot[16]), .out(data_readRegA));
	tristate tri17A(.in(out17), .ctrl(RAonehot[17]), .out(data_readRegA));
	tristate tri18A(.in(out18), .ctrl(RAonehot[18]), .out(data_readRegA));
	tristate tri19A(.in(out19), .ctrl(RAonehot[19]), .out(data_readRegA));
	tristate tri20A(.in(out20), .ctrl(RAonehot[20]), .out(data_readRegA));
	tristate tri21A(.in(out21), .ctrl(RAonehot[21]), .out(data_readRegA));
	tristate tri22A(.in(out22), .ctrl(RAonehot[22]), .out(data_readRegA));
	tristate tri23A(.in(out23), .ctrl(RAonehot[23]), .out(data_readRegA));
	tristate tri24A(.in(out24), .ctrl(RAonehot[24]), .out(data_readRegA));
	tristate tri25A(.in(out25), .ctrl(RAonehot[25]), .out(data_readRegA));
	tristate tri26A(.in(out26), .ctrl(RAonehot[26]), .out(data_readRegA));
	tristate tri27A(.in(out27), .ctrl(RAonehot[27]), .out(data_readRegA));
	tristate tri28A(.in(out28), .ctrl(RAonehot[28]), .out(data_readRegA));
	tristate tri29A(.in(out29), .ctrl(RAonehot[29]), .out(data_readRegA));
	tristate tri30A(.in(out30), .ctrl(RAonehot[30]), .out(data_readRegA));
	tristate tri31A(.in(out31), .ctrl(RAonehot[31]), .out(data_readRegA));
	
	tristate tri0B(.in(out0), .ctrl(RBonehot[0]), .out(data_readRegB));
	tristate tri1B(.in(out1), .ctrl(RBonehot[1]), .out(data_readRegB));
	tristate tri2B(.in(out2), .ctrl(RBonehot[2]), .out(data_readRegB));
	tristate tri3B(.in(out3), .ctrl(RBonehot[3]), .out(data_readRegB));
	tristate tri4B(.in(out4), .ctrl(RBonehot[4]), .out(data_readRegB));
	tristate tri5B(.in(out5), .ctrl(RBonehot[5]), .out(data_readRegB));
	tristate tri6B(.in(out6), .ctrl(RBonehot[6]), .out(data_readRegB));
	tristate tri7B(.in(out7), .ctrl(RBonehot[7]), .out(data_readRegB));
	tristate tri8B(.in(out8), .ctrl(RBonehot[8]), .out(data_readRegB));
	tristate tri9B(.in(out9), .ctrl(RBonehot[9]), .out(data_readRegB));
	tristate tri10B(.in(out10), .ctrl(RBonehot[10]), .out(data_readRegB));
	tristate tri11B(.in(out11), .ctrl(RBonehot[11]), .out(data_readRegB));
	tristate tri12B(.in(out12), .ctrl(RBonehot[12]), .out(data_readRegB));
	tristate tri13B(.in(out13), .ctrl(RBonehot[13]), .out(data_readRegB));
	tristate tri14B(.in(out14), .ctrl(RBonehot[14]), .out(data_readRegB));
	tristate tri15B(.in(out15), .ctrl(RBonehot[15]), .out(data_readRegB));
	tristate tri16B(.in(out16), .ctrl(RBonehot[16]), .out(data_readRegB));
	tristate tri17B(.in(out17), .ctrl(RBonehot[17]), .out(data_readRegB));
	tristate tri18B(.in(out18), .ctrl(RBonehot[18]), .out(data_readRegB));
	tristate tri19B(.in(out19), .ctrl(RBonehot[19]), .out(data_readRegB));
	tristate tri20B(.in(out20), .ctrl(RBonehot[20]), .out(data_readRegB));
	tristate tri21B(.in(out21), .ctrl(RBonehot[21]), .out(data_readRegB));
	tristate tri22B(.in(out22), .ctrl(RBonehot[22]), .out(data_readRegB));
	tristate tri23B(.in(out23), .ctrl(RBonehot[23]), .out(data_readRegB));
	tristate tri24B(.in(out24), .ctrl(RBonehot[24]), .out(data_readRegB));
	tristate tri25B(.in(out25), .ctrl(RBonehot[25]), .out(data_readRegB));
	tristate tri26B(.in(out26), .ctrl(RBonehot[26]), .out(data_readRegB));
	tristate tri27B(.in(out27), .ctrl(RBonehot[27]), .out(data_readRegB));
	tristate tri28B(.in(out28), .ctrl(RBonehot[28]), .out(data_readRegB));
	tristate tri29B(.in(out29), .ctrl(RBonehot[29]), .out(data_readRegB));
	tristate tri30B(.in(out30), .ctrl(RBonehot[30]), .out(data_readRegB));
	tristate tri31B(.in(out31), .ctrl(RBonehot[31]), .out(data_readRegB));
	
endmodule
