/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

//module skeleton(clock, reset);
module skeleton(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button);
//module skeleton(clock, reset, reg1Button, reg2Button, reg3Button, reg4Button, currpc, data_reg1, A, B,
//					fd, dx, xm, mw, data_reg2);
//module skeleton(clock, reset, data_reg3,
//					 fd, dx, xm, mw, fdout, A, B, data_reg4, assertHazard, currpc, branchout, readA, readB, ALUOUT, jalreg,
//					 ALUA, ALUB, outA, xout,bypass, isLessThan, branchtaken, reg1Button, data_reg1,
//					 reg2Button, reg3Button, reg4Button);
    input clock, reset, reg1Button, reg2Button, reg3Button, reg4Button;

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 
    regfile my_regfile(
        ~clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  reg1Button, reg2Button, reg3Button, reg4Button
//		  data_reg3, data_reg4, data_reg1
    );

    /** PROCESSOR **/
    processor my_processor(
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
        data_readRegB                   // I: Data from port B of regfile
//        data_readRegB,                   // I: Data from port B of regfile
//		  currpc, A, B, fd, dx, xm, mw
	 );
	 
	 /* TESTING WIRES TO BE DELETED */
//	 output[31:0] data_reg3, data_reg4;
//	 output[11:0] currpc;
//	 output[31:0] fd, dx, xm, mw;
//	 output[31:0] fdout, A, B;
//	 output assertHazard;
//	 output[11:0] branchout;
//	 output[4:0] readA, readB;
//	 assign readA = ctrl_readRegA;
//	 assign readB = ctrl_readRegB;
//	 output[31:0] ALUOUT;
//	 output[31:0] jalreg;
//	 output[31:0] ALUA, ALUB, outA, xout;
//	 output bypass, isLessThan, branchtaken;
//	 output[31:0] data_reg1, A, B, fd, dx, xm, mw, data_reg2;

endmodule
