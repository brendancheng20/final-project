module pc_reg(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_read);

	input clock, ctrl_writeEnable, ctrl_reset; // clock, write enable, reset
	input[11:0] data_writeReg; // data to be written
	output[11:0] data_read; // data currently stored in register
	
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

endmodule
