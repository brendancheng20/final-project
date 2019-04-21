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
	  x <= ADDR % 640;
	  y <= (ADDR - x)/640;
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

logo_data logod(.address(yahtzee_ctr), .clock( VGA_CLK_n), .q(index));
logo_index logoi(.address(index), .clock(iVGA_CLK), .q(yahtzee_name));

wire[7:0] startButtonIndex;
reg[18:0] startButtonCtr;
wire[23:0] startButtonBGR;

startbutton_data sbdata(.address(startButtonCtr), .clock(VGA_CLK_n), .q(startButtonIndex));
startbutton_index sbindex(.address(startButtonIndex), .clock(iVGA_CLK), .q(startButtonBGR));

wire[7:0] playerButtonIndex;
reg[18:0] playerButtonCtr;
wire[23:0] playerButtonBGR;

playerbutton_data pbdata(.address(playerButtonCtr), .clock(VGA_CLK_n), .q(playerButtonIndex));
playerbutton_index pbindex(.address(playerButtonIndex), .clock(iVGA_CLK), .q(playerButtonBGR));
	
wire[7:0] firstrowIndex;
reg[18:0] firstrowCtr;
wire[23:0] firstrowBGR;

firstrow_data frdata(.address(firstrowCtr), .clock(VGA_CLK_n), .q(firstrowIndex));
firstrow_index frindex(.address(firstrowIndex), .clock(iVGA_CLK), .q(firstrowBGR));
		
wire[7:0] secondrowIndex;
reg[18:0] secondrowCtr;
wire[23:0] secondrowBGR;

secondrow_data srdata(.address(secondrowCtr), .clock(VGA_CLK_n), .q(secondrowIndex));
secondrow_index srindex(.address(secondrowIndex), .clock(iVGA_CLK), .q(secondrowBGR));
	
wire[7:0] thirdrowIndex;
reg[18:0] thirdrowCtr;
wire[23:0] thirdrowBGR;

thirdrow_data trdata(.address(thirdrowCtr), .clock(VGA_CLK_n), .q(thirdrowIndex));
thirdrow_index trindex(.address(thirdrowIndex), .clock(iVGA_CLK), .q(thirdrowBGR));
	
wire[7:0] emptydiceIndex;
reg[18:0] emptydiceCtr;
wire[23:0] emptydiceBGR;

emptydice_data eddata(.address(emptydiceCtr), .clock(VGA_CLK_n), .q(emptydiceIndex));
emptydice_index edindex(.address(emptydiceIndex), .clock(iVGA_CLK), .q(emptydiceBGR));
	
wire[7:0] leaderboardIndex;
reg[18:0] leaderboardCtr;
wire[23:0] leaderboardBGR;

leaderboard_data lbdata(.address(leaderboardCtr), .clock(VGA_CLK_n), .q(leaderboardIndex));
leaderboard_index lbindex(.address(leaderboardIndex), .clock(iVGA_CLK), .q(leaderboardBGR));
	
wire[7:0] rankingsIndex;
reg[18:0] rankingsCtr;
wire[23:0] rankingsBGR;
	
rankings_data rankingdata(.address(rankingsCtr), .clock(VGA_CLK_n), .q(rankingsIndex));
rankings_index rankingindex(.address(rankingsIndex), .clock(iVGA_CLK), .q(rankingsBGR));
	
	
/********** Determine row, column of screen that address points to *******/

reg[18:0] x, y;
reg[18:0] yahtzee_ctr;
initial
begin
	x <= 19'd0;
	y <= 19'd0;
	yahtzee_ctr <= 19'd0;
	startButtonCtr <= 19'd0;
	playerButtonCtr <= 19'd0;
	firstrowCtr <= 19'd0;
	secondrowCtr <= 19'd0;
	thirdrowCtr <= 19'd0;
	emptydiceCtr <= 19'd0;
	leaderboardCtr <= 19'd0;
	rankingsCtr <= 19'd0;
end
	
/******* MIF Data toggle *********/
// Initialize bgr_data_raw to background color
initial
begin
	bgr_data_raw <= 24'h150088; // default color
end

input[31:0] mif_toggle; // Toggles to various data when various sprites should appear. Based on
								// $30 in processor

//always @(*) begin
//	if (mif_toggle == 32'd0) begin
		
//	end
//end


/********** *****************/
	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) begin 
if (ADDR < 5) begin
	yahtzee_ctr = 0;
	startButtonCtr = 0;
	playerButtonCtr = 0;
	firstrowCtr = 0;
	secondrowCtr = 0;
	thirdrowCtr = 0;
	emptydiceCtr = 0;
	leaderboardCtr = 0;
	rankingsCtr = 0;
end
// Start Screen
if (mif_toggle == 32'b0) begin
	if ((x>=63) && (x<559) && (y>=81) && (y<186)) begin
			yahtzee_ctr = yahtzee_ctr + 1;
//			if (yahtzee_ctr >= 52080) begin
//				yahtzee_ctr = 0;
//			end
//			bgr_data_raw <= 24'h120d20;
			bgr_data_raw <= yahtzee_name;
		end else if ((x>= 228) && (x<400) && (y>=204) && (y<372)) begin
			startButtonCtr = startButtonCtr + 1;
			bgr_data_raw <= startButtonBGR;
		end else begin
			bgr_data_raw <= 24'h150088;
	end
end
// Player Select
if (mif_toggle == 32'd1) begin
	if ((x>=63) && (x<559) && (y>=81) && (y<186)) begin
			yahtzee_ctr = yahtzee_ctr + 1;
			bgr_data_raw <= yahtzee_name;
		end else if ((x>=230) && (x<399) && (y>=205) && (y<461)) begin
			playerButtonCtr = playerButtonCtr + 1;
			bgr_data_raw <= playerButtonBGR;
		end else begin
			bgr_data_raw <= 24'h150088;
	end
end
// Leaderboard
if (mif_toggle == 32'd2) begin
	if ((x>=112) && (x<524) && (y>=58) && (y<149)) begin
			leaderboardCtr = leaderboardCtr + 1;
			bgr_data_raw <= leaderboardBGR;
		end else if ((x>=122) && (x<185) && (y>=198) && (y<401)) begin
			rankingsCtr = rankingsCtr + 1;
			bgr_data_raw <= rankingsBGR;
		end else begin
			bgr_data_raw <= 24'h150088;
	end
end
// GameBoard
if (mif_toggle == 32'd3) begin
	if ((x>=18) && (x<617) && (y>=18) && (y<97)) begin
			firstrowCtr = firstrowCtr + 1;
			bgr_data_raw <= firstrowBGR;
		end else if ((x>=31) && (x<615) && (y>=124) && (y<227)) begin
			secondrowCtr = secondrowCtr + 1;
			bgr_data_raw <= secondrowBGR;
		end else if ((x>=195) && (x<437) && (y>=239) && (y<302)) begin
			thirdrowCtr = thirdrowCtr + 1;
			bgr_data_raw <= thirdrowBGR;
		end else if ((x>=4) && (x<635) && (y>=344) && (y<463)) begin
			emptydiceCtr = emptydiceCtr + 1;
			bgr_data_raw <= emptydiceBGR;
		end else begin
			bgr_data_raw <= 24'h150088;
	end
end
bgr_data <= bgr_data_raw;
end

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
 	















