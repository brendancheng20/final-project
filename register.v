module register(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_read);

	input clock, ctrl_writeEnable, ctrl_reset; // clock, write enable, reset
	input[31:0] data_writeReg; // data to be written
	output[31:0] data_read; // data currently stored in register
	
	/* Declare 32 DFFs #0-31 */
	
//	dffe_ref[31:0] dff(data_read, data_writeReg, clock, ctrl_writeEnable, ctrl_reset);
	
	dffe_ref dff0(data_read[0], data_writeReg[0], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff1(data_read[1], data_writeReg[1], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff2(data_read[2], data_writeReg[2], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff3(data_read[3], data_writeReg[3], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff4(data_read[4], data_writeReg[4], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff5(data_read[5], data_writeReg[5], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff6(data_read[6], data_writeReg[6], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff7(data_read[7], data_writeReg[7], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff8(data_read[8], data_writeReg[8], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff9(data_read[9], data_writeReg[9], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff10(data_read[10], data_writeReg[10], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff11(data_read[11], data_writeReg[11], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff12(data_read[12], data_writeReg[12], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff13(data_read[13], data_writeReg[13], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff14(data_read[14], data_writeReg[14], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff15(data_read[15], data_writeReg[15], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff16(data_read[16], data_writeReg[16], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff17(data_read[17], data_writeReg[17], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff18(data_read[18], data_writeReg[18], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff19(data_read[19], data_writeReg[19], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff20(data_read[20], data_writeReg[20], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff21(data_read[21], data_writeReg[21], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff22(data_read[22], data_writeReg[22], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff23(data_read[23], data_writeReg[23], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff24(data_read[24], data_writeReg[24], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff25(data_read[25], data_writeReg[25], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff26(data_read[26], data_writeReg[26], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff27(data_read[27], data_writeReg[27], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff28(data_read[28], data_writeReg[28], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff29(data_read[29], data_writeReg[29], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff30(data_read[30], data_writeReg[30], clock, ctrl_writeEnable, ctrl_reset);
	dffe_ref dff31(data_read[31], data_writeReg[31], clock, ctrl_writeEnable, ctrl_reset);
	
endmodule
