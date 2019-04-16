module tristate(ctrl, in, out);

	input ctrl;
	input[31:0] in;
	output[31:0] out;
	
	assign out = ctrl ? in : 32'bz;

endmodule
