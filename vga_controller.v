module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 mif_toggle);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
reg [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
//img_data	img_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index )
//	);
//	
///////////////////////////
////////Add switch-input logic here
//	
////////Color table output
//img_index	img_index_inst (
//	.address ( index ),
//	.clock ( iVGA_CLK ),
//	.q ( yahtzee_name )
//	);

wire[23:0] yahtzee_name;

logo_data logod(.address(ADDR), .clock( VGA_CLK_n), .q(index));
logo_index logoi(.address(index), .clock(iVGA_CLK), .q(yahtzee_name));
	
	
/********** Determine row, column of screen that address points to *******/

reg[18:0] x, y;

initial
begin
	x <= 19'd0;
	y <= 19'd0;
end

always @(*) begin
	x <= ADDR % 19'd640;
	y <= (ADDR - x)/19'd640;
end
	
/******* MIF Data toggle *********/
// Initialize bgr_data_raw to background color
initial
begin
	bgr_data_raw <= 24'h150088; // default color
end

input[31:0] mif_toggle; // Toggles to various data when various sprites should appear. Based on
								// $30 in processor

always @(*) begin
	if (mif_toggle == 32'd0) begin
		if ((x>63) && (x<559) && (y>81) && (y<186)) begin
			bgr_data_raw <= yahtzee_name;
		end else begin
			bgr_data_raw <= 24'h150088;
		end
	end
end


/********** *****************/
	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















