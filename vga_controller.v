module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 mif_toggle, ctr,
							 die1, die2, die3, die4, die5, arrow_pos,
							 selected_hand, text_pack);

	
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
										
input[31:0] ctr, die1, die2, die3, die4, die5, arrow_pos, selected_hand;
input text_pack;
reg duke;

initial
begin
	duke = 1'b0;
end

always @(posedge text_pack) begin
	duke = duke + 1;
end
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

/******************* Arrow selector position toggles ******************/
reg pos0, pos1, pos2, pos3, pos4, pos5, pos6;
reg pos7, pos8, pos9, pos10, pos11, pos12; // toggle whether arrow is in this position
reg sel0, sel1, sel2, sel3, sel4, sel5, sel6;
reg sel7, sel8, sel9, sel10, sel11, sel12; // toggle whether arrow stays on
initial
begin
	pos0 <= 1'd0;
	pos1 <= 1'd0;
	pos2 <= 1'd0;
	pos3 <= 1'd0;
	pos4 <= 1'd0;
	pos5 <= 1'd0;
	pos6 <= 1'd0;
	pos7 <= 1'd0;
	pos8 <= 1'd0;
	pos9 <= 1'd0;
	pos10 <= 1'd0;
	pos11 <= 1'd0;
	pos12 <= 1'd0;
	sel0 <= 1'd0;
	sel1 <= 1'd0;
	sel2 <= 1'd0;
	sel3 <= 1'd0;
	sel4 <= 1'd0;
	sel5 <= 1'd0;
	sel6 <= 1'd0;
	sel7 <= 1'd0;
	sel8 <= 1'd0;
	sel9 <= 1'd0;
	sel10 <= 1'd0;
	sel11 <= 1'd0;
	sel12 <= 1'd0;
end

wire[31:0] curr_selection; // bus of which arrow selection is active right now

decoder5_32 choose_arrow_pos(.select(arrow_pos[4:0]), .onehot(curr_selection));

//always @(posedge VGA_CLK_n) begin
//	// Logic for stationary arrow
//	if (selected_hand == 32'd0) begin
//		sel0 <= 1;
//	end
//	if (selected_hand == 32'd1) begin
//		sel1 <= 1;
//	end
//	if (selected_hand == 32'd2) begin
//		sel2 <= 1;
//	end
//	if (selected_hand == 32'd3) begin
//		sel3 <= 1;
//	end
//	if (selected_hand == 32'd4) begin
//		sel4 <= 1;
//	end
//	if (selected_hand == 32'd5) begin
//		sel5 <= 1;
//	end
//	if (selected_hand == 32'd6) begin
//		sel6 <= 1;
//	end
//	if (selected_hand == 32'd7) begin
//		sel7 <= 1;
//	end
//	if (selected_hand == 32'd8) begin
//		sel8 <= 1;
//	end
//	if (selected_hand == 32'd9) begin
//		sel9 <= 1;
//	end
//	if (selected_hand == 32'd10) begin
//		sel10 <= 1;
//	end
//	if (selected_hand == 32'd11) begin
//		sel11 <= 1;
//	end
//	if (selected_hand == 32'd12) begin
//		sel12 <= 1;
//	end
//	pos0 <= curr_selection[0];
//	pos1 <= curr_selection[1];
//	pos2 <= curr_selection[2];
//	pos3 <= curr_selection[3];
//	pos4 <= curr_selection[4];
//	pos5 <= curr_selection[5];
//	pos6 <= curr_selection[6];
//	pos7 <= curr_selection[7];
//	pos8 <= curr_selection[8];
//	pos9 <= curr_selection[9];
//	pos10 <= curr_selection[10];
//	pos11 <= curr_selection[11];
//	pos12 <= curr_selection[12];
//end

/******************* End arrow selector position toggles **************/

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

wire[7:0] die1Index;
reg[18:0] die1Ctr;
wire[23:0] die1BGR;
	
die1_data die1data(.address(die1Ctr), .clock(VGA_CLK_n), .q(die1Index));
die1_index die1index(.address(die1Index), .clock(iVGA_CLK), .q(die1BGR));

wire[7:0] die2Index;
reg[18:0] die2Ctr;
wire[23:0] die2BGR;
	
die2_data die2data(.address(die2Ctr), .clock(VGA_CLK_n), .q(die2Index));
die2_index die2index(.address(die2Index), .clock(iVGA_CLK), .q(die2BGR));

wire[7:0] die3Index;
reg[18:0] die3Ctr;
wire[23:0] die3BGR;
	
die3_data die3data(.address(die3Ctr), .clock(VGA_CLK_n), .q(die3Index));
die3_index die3index(.address(die3Index), .clock(iVGA_CLK), .q(die3BGR));

wire[7:0] die4Index;
reg[18:0] die4Ctr;
wire[23:0] die4BGR;
	
die4_data die4data(.address(die4Ctr), .clock(VGA_CLK_n), .q(die4Index));
die4_index die4index(.address(die4Index), .clock(iVGA_CLK), .q(die4BGR));

wire[7:0] die5Index;
reg[18:0] die5Ctr;
wire[23:0] die5BGR;
	
die5_data die5data(.address(die5Ctr), .clock(VGA_CLK_n), .q(die5Index));
die5_index die5index(.address(die5Index), .clock(iVGA_CLK), .q(die5BGR));

wire[7:0] die6Index;
reg[18:0] die6Ctr;
wire[23:0] die6BGR;
	
die6_data die6data(.address(die6Ctr), .clock(VGA_CLK_n), .q(die6Index));
die6_index die6index(.address(die6Index), .clock(iVGA_CLK), .q(die6BGR));

wire[7:0] duke1Index;
reg[18:0] duke1Ctr;
wire[23:0] duke1BGR;
	
duke1_data duke1data(.address(duke1Ctr), .clock(VGA_CLK_n), .q(duke1Index));
duke1_index duke1index(.address(duke1Index), .clock(iVGA_CLK), .q(duke1BGR));

wire[7:0] duke2Index;
reg[18:0] duke2Ctr;
wire[23:0] duke2BGR;
	
duke2_data duke2data(.address(duke2Ctr), .clock(VGA_CLK_n), .q(duke2Index));
duke2_index duke2index(.address(duke2Index), .clock(iVGA_CLK), .q(duke2BGR));

wire[7:0] duke3Index;
reg[18:0] duke3Ctr;
wire[23:0] duke3BGR;
	
duke3_data duke3data(.address(duke3Ctr), .clock(VGA_CLK_n), .q(duke3Index));
duke3_index duke3index(.address(duke3Index), .clock(iVGA_CLK), .q(duke3BGR));

wire[7:0] duke4Index;
reg[18:0] duke4Ctr;
wire[23:0] duke4BGR;
	
duke4_data duke4data(.address(duke4Ctr), .clock(VGA_CLK_n), .q(duke4Index));
duke4_index duke4index(.address(duke4Index), .clock(iVGA_CLK), .q(duke4BGR));

wire[7:0] duke5Index;
reg[18:0] duke5Ctr;
wire[23:0] duke5BGR;
	
duke5_data duke5data(.address(duke5Ctr), .clock(VGA_CLK_n), .q(duke5Index));
duke5_index duke5index(.address(duke5Index), .clock(iVGA_CLK), .q(duke5BGR));

wire[7:0] duke6Index;
reg[18:0] duke6Ctr;
wire[23:0] duke6BGR;
	
duke6_data duke6data(.address(duke6Ctr), .clock(VGA_CLK_n), .q(duke6Index));
duke6_index duke6index(.address(duke6Index), .clock(iVGA_CLK), .q(duke6BGR));

wire[7:0] arrowIndex;
reg[18:0] arrowCtr;
wire[23:0] arrowBGR;
	
arrow_data arrowdata(.address(arrowCtr), .clock(VGA_CLK_n), .q(arrowIndex));
arrow_index arrowindex(.address(arrowIndex), .clock(iVGA_CLK), .q(arrowBGR));
	
	
/********** Determine row, column of screen that address points to *******/

reg[18:0] x, y;
reg[18:0] yahtzee_ctr;
initial
begin
	x <= 19'd0;
	y <= 19'd0;
	yahtzee_ctr <= 19'd0;
	startButtonCtr <= 19'd0;
	arrowCtr <= 19'd0;
	playerButtonCtr <= 19'd0;
	firstrowCtr <= 19'd0;
	secondrowCtr <= 19'd0;
	thirdrowCtr <= 19'd0;
	emptydiceCtr <= 19'd0;
	leaderboardCtr <= 19'd0;
	rankingsCtr <= 19'd0;
	die1Ctr <= 19'd0;
	die2Ctr <= 19'd0;
	die3Ctr <= 19'd0;
	die4Ctr <= 19'd0;
	die5Ctr <= 19'd0;
	die6Ctr <= 19'd0;
	ctr1_1 <= 19'd0;
	ctr1_2 <= 19'd0;
	ctr1_3 <= 19'd0;
	ctr1_4 <= 19'd0;
	ctr1_5 <= 19'd0;
	ctr1_6 <= 19'd0;
	ctr2_1 <= 19'd0;
	ctr2_2 <= 19'd0;
	ctr2_3 <= 19'd0;
	ctr2_4 <= 19'd0;
	ctr2_5 <= 19'd0;
	ctr2_6 <= 19'd0;
	ctr3_1 <= 19'd0;
	ctr3_2 <= 19'd0;
	ctr3_3 <= 19'd0;
	ctr3_4 <= 19'd0;
	ctr3_5 <= 19'd0;
	ctr3_6 <= 19'd0;
	ctr4_1 <= 19'd0;
	ctr4_2 <= 19'd0;
	ctr4_3 <= 19'd0;
	ctr4_4 <= 19'd0;
	ctr4_5 <= 19'd0;
	ctr4_6 <= 19'd0;
	ctr5_1 <= 19'd0;
	ctr5_2 <= 19'd0;
	ctr5_3 <= 19'd0;
	ctr5_4 <= 19'd0;
	ctr5_5 <= 19'd0;
	ctr5_6 <= 19'd0;
	ctr1_1d <= 19'd0;
	ctr1_2d <= 19'd0;
	ctr1_3d <= 19'd0;
	ctr1_4d <= 19'd0;
	ctr1_5d <= 19'd0;
	ctr1_6d <= 19'd0;
	ctr2_1d <= 19'd0;
	ctr2_2d <= 19'd0;
	ctr2_3d <= 19'd0;
	ctr2_4d <= 19'd0;
	ctr2_5d <= 19'd0;
	ctr2_6d <= 19'd0;
	ctr3_1d <= 19'd0;
	ctr3_2d <= 19'd0;
	ctr3_3d <= 19'd0;
	ctr3_4d <= 19'd0;
	ctr3_5d <= 19'd0;
	ctr3_6d <= 19'd0;
	ctr4_1d <= 19'd0;
	ctr4_2d <= 19'd0;
	ctr4_3d <= 19'd0;
	ctr4_4d <= 19'd0;
	ctr4_5d <= 19'd0;
	ctr4_6d <= 19'd0;
	ctr5_1d <= 19'd0;
	ctr5_2d <= 19'd0;
	ctr5_3d <= 19'd0;
	ctr5_4d <= 19'd0;
	ctr5_5d <= 19'd0;
	ctr5_6d <= 19'd0;
	arrow0 <= 19'd0;
	arrow1 <= 19'd0;
	arrow2 <= 19'd0;
	arrow3 <= 19'd0;
	arrow4 <= 19'd0;
	arrow5 <= 19'd0;
	arrow6 <= 19'd0;
	arrow7 <= 19'd0;
	arrow8 <= 19'd0;
	arrow9 <= 19'd0;
	arrow10 <= 19'd0;
	arrow11 <= 19'd0;
	arrow12 <= 19'd0;
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

reg[18:0] ctr1_1, ctr1_2, ctr1_3, ctr1_4, ctr1_5, ctr1_6, ctr2_1, ctr2_2, ctr2_3, ctr2_4, ctr2_5, ctr2_6,
	ctr3_1, ctr3_2, ctr3_3, ctr3_4, ctr3_5, ctr3_6, ctr4_1, ctr4_2, ctr4_3, ctr4_4, ctr4_5, ctr4_6,
	ctr5_1, ctr5_2, ctr5_3, ctr5_4, ctr5_5, ctr5_6, ctr1_1d, ctr1_2d, ctr1_3d, ctr1_4d, ctr1_5d, ctr1_6d, ctr2_1d, ctr2_2d, ctr2_3d, ctr2_4d, ctr2_5d, ctr2_6d,
	ctr3_1d, ctr3_2d, ctr3_3d, ctr3_4d, ctr3_5d, ctr3_6d, ctr4_1d, ctr4_2d, ctr4_3d, ctr4_4d, ctr4_5d, ctr4_6d,
	ctr5_1d, ctr5_2d, ctr5_3d, ctr5_4d, ctr5_5d, ctr5_6d, arrow0, arrow1, arrow2, arrow3, arrow4,
	arrow5, arrow6, arrow7, arrow8, arrow9, arrow10, arrow11, arrow12;
/********** *****************/
	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) begin 

// Logic for stationary arrow
	if (selected_hand == 32'd0) begin
		sel0 <= 1;
	end
	if (selected_hand == 32'd1) begin
		sel1 <= 1;
	end
	if (selected_hand == 32'd2) begin
		sel2 <= 1;
	end
	if (selected_hand == 32'd3) begin
		sel3 <= 1;
	end
	if (selected_hand == 32'd4) begin
		sel4 <= 1;
	end
	if (selected_hand == 32'd5) begin
		sel5 <= 1;
	end
	if (selected_hand == 32'd6) begin
		sel6 <= 1;
	end
	if (selected_hand == 32'd7) begin
		sel7 <= 1;
	end
	if (selected_hand == 32'd8) begin
		sel8 <= 1;
	end
	if (selected_hand == 32'd9) begin
		sel9 <= 1;
	end
	if (selected_hand == 32'd10) begin
		sel10 <= 1;
	end
	if (selected_hand == 32'd11) begin
		sel11 <= 1;
	end
	if (selected_hand == 32'd12) begin
		sel12 <= 1;
	end
	pos0 <= curr_selection[0];
	pos1 <= curr_selection[1];
	pos2 <= curr_selection[2];
	pos3 <= curr_selection[3];
	pos4 <= curr_selection[4];
	pos5 <= curr_selection[5];
	pos6 <= curr_selection[6];
	pos7 <= curr_selection[7];
	pos8 <= curr_selection[8];
	pos9 <= curr_selection[9];
	pos10 <= curr_selection[10];
	pos11 <= curr_selection[11];
	pos12 <= curr_selection[12];

if (ADDR < 5) begin
	yahtzee_ctr = 0;
	startButtonCtr = 0;
	playerButtonCtr = 0;
	firstrowCtr = 0;
	arrowCtr = 0;
	secondrowCtr = 0;
	thirdrowCtr = 0;
	emptydiceCtr = 0;
	leaderboardCtr = 0;
	rankingsCtr = 0;
	ctr1_1 = 0;
	ctr1_2 = 0;
	ctr1_3 = 0;
	ctr1_4 = 0;
	ctr1_5 = 0;
	ctr1_6 = 0;
	ctr2_1 = 0;
	ctr2_2 = 0;
	ctr2_3 = 0;
	ctr2_4 = 0;
	ctr2_5 = 0;
	ctr2_6 = 0;
	ctr3_1 = 0;
	ctr3_2 = 0;
	ctr3_3 = 0;
	ctr3_4 = 0;
	ctr3_5 = 0;
	ctr3_6 = 0;
	ctr4_1 = 0;
	ctr4_2 = 0;
	ctr4_3 = 0;
	ctr4_4 = 0;
	ctr4_5 = 0;
	ctr4_6 = 0;
	ctr5_1 = 0;
	ctr5_2 = 0;
	ctr5_3 = 0;
	ctr5_4 = 0;
	ctr5_5 = 0;
	ctr5_6 = 0;
	ctr1_1d = 0;
	ctr1_2d = 0;
	ctr1_3d = 0;
	ctr1_4d = 0;
	ctr1_5d = 0;
	ctr1_6d = 0;
	ctr2_1d = 0;
	ctr2_2d = 0;
	ctr2_3d = 0;
	ctr2_4d = 0;
	ctr2_5d = 0;
	ctr2_6d = 0;
	ctr3_1d = 0;
	ctr3_2d = 0;
	ctr3_3d = 0;
	ctr3_4d = 0;
	ctr3_5d = 0;
	ctr3_6d = 0;
	ctr4_1d = 0;
	ctr4_2d = 0;
	ctr4_3d = 0;
	ctr4_4d = 0;
	ctr4_5d = 0;
	ctr4_6d = 0;
	ctr5_1d = 0;
	ctr5_2d = 0;
	ctr5_3d = 0;
	ctr5_4d = 0;
	ctr5_5d = 0;
	ctr5_6d = 0;
	arrow0 = 0;
	arrow1 = 0;
	arrow2 = 0;
	arrow3 = 0;
	arrow4 = 0;
	arrow5 = 0;
	arrow6 = 0;
	arrow7 = 0;
	arrow8 = 0;
	arrow9 = 0;
	arrow10 = 0;
	arrow11 = 0;
	arrow12 = 0;
	die1Ctr = 0;
	die2Ctr = 0;
	die3Ctr = 0;
	die4Ctr = 0;
	die5Ctr = 0;
	die6Ctr = 0;
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
		end else if ((x>= 228) && (x<400) && (y>=204) && (y<373)) begin
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
		end else if ((x>=230) && (x<405) && (y>=205) && (y<464)) begin
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
//	if (pos0 == 1) begin
//		bgr_data_raw <= 24'h521494;
//	end
//	if (pos0 == 1 || sel0 == 1) begin
//		if ((x>=52) && (x<77) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow0;
//			arrow0 = arrow0 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos1 == 1) begin
//		if ((x>=157) && (x<182) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow1;
//			arrow1 = arrow1 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos2 == 1) begin
//		if ((x>=256) && (x<281) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow2;
//			arrow2 = arrow2 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos3 == 1) begin
//		if ((x>=356) && (x<381) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow3;
//			arrow3 = arrow3 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos4 == 1) begin
//		if ((x>=456) && (x<481) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow4;
//			arrow4 = arrow4 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos5 == 1) begin
//		if ((x>=559) && (x<584) && (y>=102) && (y<121)) begin
//			arrowCtr <= arrow5;
//			arrow5 = arrow5 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos6 == 1 ) begin
//		if ((x>=65) && (x<90) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow6;
//			arrow6 = arrow6 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos7 == 1) begin
//		if ((x>=163) && (x<188) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow7;
//			arrow7 = arrow7 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos8 == 1) begin
//		if ((x>=257) && (x<282) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow8;
//			arrow8 = arrow8 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos9 == 1) begin
//		if ((x>=349) && (x<374) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow9;
//			arrow9 = arrow9 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos10 == 1) begin
//		if ((x>=448) && (x<473) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow10;
//			arrow10 = arrow10 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos11 == 1) begin
//		if ((x>=545) && (x<570) && (y>=231) && (y<250)) begin
//			arrowCtr <= arrow11;
//			arrow11 = arrow11 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
//	if (pos12 == 1) begin
//		if ((x>=301) && (x<326) && (y>=322) && (y<341)) begin
//			arrowCtr <= arrow12;
//			arrow12 = arrow12 + 1;
//			bgr_data_raw <= arrowBGR;
//		end
//	end
	if ((x>=18) && (x<617) && (y>=18) && (y<97)) begin
			firstrowCtr = firstrowCtr + 1;
			bgr_data_raw <= firstrowBGR;
	end else if ((x>=52) && (x<77) && (y>=102) && (y<121)) begin
			arrowCtr = arrowCtr + 1;
			bgr_data_raw <= arrowBGR;
	end else if ((x>=31) && (x<615) && (y>=124) && (y<227)) begin
			secondrowCtr = secondrowCtr + 1;
			bgr_data_raw <= secondrowBGR;
	end else if ((x>=195) && (x<437) && (y>=257) && (y<320)) begin
			thirdrowCtr = thirdrowCtr + 1;
			bgr_data_raw <= thirdrowBGR;
	end else if ((x>=4) && (x<635) && (y>=344) && (y<463)) begin
		if ((die1 == 0) && (die2 == 0) && (die3 == 0) && (die4 == 0) && (die5 == 0)) begin
			emptydiceCtr = emptydiceCtr + 1;
			bgr_data_raw <= emptydiceBGR;
		end
		else begin
				// die 1
				if (die1 == 1) begin
					if ((x>=4) && (x<124) && (y>=345) && (y<465)) begin
						if (duke == 0) begin
						die1Ctr <= ctr1_1;
						ctr1_1 = ctr1_1 + 1;
						bgr_data_raw <= die1BGR;
						end
						else begin
						duke1Ctr <= ctr1_1d;
						ctr1_1d = ctr1_1d + 1;
						bgr_data_raw <= duke1BGR;
						end
					end
				end else if (die1 == 2) begin
					if ((x>=4) && (x<127) && (y>=345) && (y<465)) begin
						if (duke == 0) begin
						die2Ctr <= ctr1_2;
						ctr1_2 = ctr1_2 + 1;
						bgr_data_raw <= die2BGR;
						end
						else begin
						duke2Ctr <= ctr1_2d;
						ctr1_2d = ctr1_2d + 1;
						bgr_data_raw <= duke2BGR;
						end
					end
				end else if (die1 == 3) begin
					if ((x>=4) && (x<129) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die3Ctr <= ctr1_3;
						ctr1_3 = ctr1_3 + 1;
						bgr_data_raw <= die3BGR;
						end
						else begin
						duke3Ctr <= ctr1_3d;
						ctr1_3d = ctr1_3d + 1;
						bgr_data_raw <= duke3BGR;
						end
					end
				end else if (die1 == 4) begin
					if ((x>=4) && (x<128) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die4Ctr <= ctr1_4;
						ctr1_4 = ctr1_4 + 1;
						bgr_data_raw <= die4BGR;
						end
						else begin
						duke4Ctr <= ctr1_4d;
						ctr1_4d = ctr1_4d + 1;
						bgr_data_raw <= duke4BGR;
						end
					end
				end else if (die1 == 5) begin
					if ((x>=4) && (x<126) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die5Ctr <= ctr1_5;
						ctr1_5 = ctr1_5 + 1;
						bgr_data_raw <= die5BGR;
						end
						else begin
						duke5Ctr <= ctr1_5d;
						ctr1_5d = ctr1_5d + 1;
						bgr_data_raw <= duke5BGR;
						end
					end
				end else if (die1 == 6) begin
					if ((x>=4) && (x<127) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die6Ctr <= ctr1_6;
						ctr1_6 = ctr1_6 + 1;
						bgr_data_raw <= die6BGR;
						end
						else begin
						duke6Ctr <= ctr1_6d;
						ctr1_6d = ctr1_6d + 1;
						bgr_data_raw <= duke6BGR;
						end
					end
				end
				//die 2
				if (die2 == 1) begin
					if ((x>=131) && (x<251) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die1Ctr <= ctr2_1;
						ctr2_1 = ctr2_1 + 1;
						bgr_data_raw <= die1BGR;
						end
						else begin
						duke1Ctr <= ctr2_1d;
						ctr2_1d = ctr2_1d + 1;
						bgr_data_raw <= duke1BGR;
						end
					end
				end else if (die2 == 2) begin
					if ((x>=131) && (x<254) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die2Ctr <= ctr2_2;
						ctr2_2 = ctr2_2 + 1;
						bgr_data_raw <= die2BGR;
						end
						else begin
						duke2Ctr <= ctr2_2d;
						ctr2_2d = ctr2_2d + 1;
						bgr_data_raw <= duke2BGR;
						end
					end
				end else if (die2 == 3) begin
					if ((x>=131) && (x<256) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die3Ctr <= ctr2_3;
						ctr2_3 = ctr2_3 + 1;
						bgr_data_raw <= die3BGR;
						end
						else begin
						duke3Ctr <= ctr2_3d;
						ctr2_3d = ctr2_3d + 1;
						bgr_data_raw <= duke3BGR;
						end
					end
				end else if (die2 == 4) begin
					if ((x>=131) && (x<255) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die4Ctr <= ctr2_4;
						ctr2_4 = ctr2_4 + 1;
						bgr_data_raw <= die4BGR;
						end
						else begin
						duke4Ctr <= ctr2_4d;
						ctr2_4d = ctr2_4d + 1;
						bgr_data_raw <= duke4BGR;
						end
					end
				end else if (die2 == 5) begin
					if ((x>=131) && (x<253) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die5Ctr <= ctr2_5;
						ctr2_5 = ctr2_5 + 1;
						bgr_data_raw <= die5BGR;
						end
						else begin
						duke5Ctr <= ctr2_5d;
						ctr2_5d = ctr2_5d + 1;
						bgr_data_raw <= duke5BGR;
						end
					end
				end else if (die2 == 6) begin
					if ((x>=131) && (x<254) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die6Ctr <= ctr2_6;
						ctr2_6 = ctr2_6 + 1;
						bgr_data_raw <= die6BGR;
						end
						else begin
						duke6Ctr <= ctr2_6d;
						ctr2_6d = ctr2_6d + 1;
						bgr_data_raw <= duke6BGR;
						end
					end
				end
				if (die3 == 1) begin
					if ((x>=256) && (x<376) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die1Ctr <= ctr3_1;
						ctr3_1 = ctr3_1 + 1;
						bgr_data_raw <= die1BGR;
						end
						else begin
						duke1Ctr <= ctr3_1d;
						ctr3_1d = ctr3_1d + 1;
						bgr_data_raw <= duke1BGR;
						end
					end
				end else if (die3 == 2) begin
					if ((x>=256) && (x<379) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die2Ctr <= ctr3_2;
						ctr3_2 = ctr3_2 + 1;
						bgr_data_raw <= die2BGR;
						end
						else begin
						duke2Ctr <= ctr3_2d;
						ctr3_2d = ctr3_2d + 1;
						bgr_data_raw <= duke2BGR;
						end
					end
				end else if (die3 == 3) begin
					if ((x>=256) && (x<381) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die3Ctr <= ctr3_3;
						ctr3_3 = ctr3_3 + 1;
						bgr_data_raw <= die3BGR;
						end
						else begin
						duke3Ctr <= ctr3_3d;
						ctr3_3d = ctr3_3d + 1;
						bgr_data_raw <= duke3BGR;
						end
					end
				end else if (die3 == 4) begin
					if ((x>=256) && (x<380) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die4Ctr <= ctr3_4;
						ctr3_4 = ctr3_4 + 1;
						bgr_data_raw <= die4BGR;
						end
						else begin
						duke4Ctr <= ctr3_4d;
						ctr3_4d = ctr3_4d + 1;
						bgr_data_raw <= duke4BGR;
						end
					end
				end else if (die3 == 5) begin
					if ((x>=256) && (x<378) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die5Ctr <= ctr3_5;
						ctr3_5 = ctr3_5 + 1;
						bgr_data_raw <= die5BGR;
						end
						else begin
						duke5Ctr <= ctr3_5d;
						ctr3_5d = ctr3_5d + 1;
						bgr_data_raw <= duke5BGR;
						end
					end
				end else if (die3 == 6) begin
					if ((x>=256) && (x<379) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die6Ctr <= ctr3_6;
						ctr3_6 = ctr3_6 + 1;
						bgr_data_raw <= die6BGR;
						end
						else begin
						duke6Ctr <= ctr3_6d;
						ctr3_6d = ctr3_6d + 1;
						bgr_data_raw <= duke6BGR;
						end
					end
				end
				if (die4 == 1) begin
					if ((x>=383) && (x<503) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die1Ctr <= ctr4_1;
						ctr4_1 = ctr4_1 + 1;
						bgr_data_raw <= die1BGR;
						end
						else begin
						duke1Ctr <= ctr4_1d;
						ctr4_1d = ctr4_1d + 1;
						bgr_data_raw <= duke1BGR;
						end
					end
				end else if (die4 == 2) begin
					if ((x>=383) && (x<506) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die2Ctr <= ctr4_2;
						ctr4_2 = ctr4_2 + 1;
						bgr_data_raw <= die2BGR;
						end
						else begin
						duke2Ctr <= ctr4_2d;
						ctr4_2d = ctr4_2d + 1;
						bgr_data_raw <= duke2BGR;
						end
					end
				end else if (die4 == 3) begin
					if ((x>=383) && (x<508) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die3Ctr <= ctr4_3;
						ctr4_3 = ctr4_3 + 1;
						bgr_data_raw <= die3BGR;
						end
						else begin
						duke3Ctr <= ctr4_3d;
						ctr4_3d = ctr4_3d + 1;
						bgr_data_raw <= duke3BGR;
						end
					end
				end else if (die4 == 4) begin
					if ((x>=383) && (x<507) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die4Ctr <= ctr4_4;
						ctr4_4 = ctr4_4 + 1;
						bgr_data_raw <= die4BGR;
						end
						else begin
						duke4Ctr <= ctr4_4d;
						ctr4_4d = ctr4_4d + 1;
						bgr_data_raw <= duke4BGR;
						end
					end
				end else if (die4 == 5) begin
					if ((x>=383) && (x<505) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die5Ctr <= ctr4_5;
						ctr4_5 = ctr4_5 + 1;
						bgr_data_raw <= die5BGR;
						end
						else begin
						duke5Ctr <= ctr4_5d;
						ctr4_5d = ctr4_5d + 1;
						bgr_data_raw <= duke5BGR;
						end
					end
				end else if (die4 == 6) begin
					if ((x>=383) && (x<506) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die6Ctr <= ctr4_6;
						ctr4_6 = ctr4_6 + 1;
						bgr_data_raw <= die6BGR;
						end
						else begin
						duke6Ctr <= ctr4_6d;
						ctr4_6d = ctr4_6d + 1;
						bgr_data_raw <= duke6BGR;
						end
					end
				end
				if (die5 == 1) begin
					if ((x>=510) && (x<630) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die1Ctr <= ctr5_1;
						ctr5_1 = ctr5_1 + 1;
						bgr_data_raw <= die1BGR;
						end
						else begin
						duke1Ctr <= ctr5_1d;
						ctr5_1d = ctr5_1d + 1;
						bgr_data_raw <= duke1BGR;
						end
					end
				end else if (die5 == 2) begin
					if ((x>=510) && (x<633) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die2Ctr <= ctr5_2;
						ctr5_2 = ctr5_2 + 1;
						bgr_data_raw <= die2BGR;
						end
						else begin
						duke2Ctr <= ctr5_2d;
						ctr5_2d = ctr5_2d + 1;
						bgr_data_raw <= duke2BGR;
						end
					end
				end else if (die5 == 3) begin
					if ((x>=510) && (x<635) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die3Ctr <= ctr5_3;
						ctr5_3 = ctr5_3 + 1;
						bgr_data_raw <= die3BGR;
						end
						else begin
						duke3Ctr <= ctr5_3d;
						ctr5_3d = ctr5_3d + 1;
						bgr_data_raw <= duke3BGR;
						end
					end
				end else if (die5 == 4) begin
					if ((x>=510) && (x<634) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die4Ctr <= ctr5_4;
						ctr5_4 = ctr5_4 + 1;
						bgr_data_raw <= die4BGR;
						end
						else begin
						duke4Ctr <= ctr5_4d;
						ctr5_4d = ctr5_4d + 1;
						bgr_data_raw <= duke4BGR;
						end
					end
				end else if (die5 == 5) begin
					if ((x>=510) && (x<632) && (y>=345) && (y<465)) begin
					if (duke == 0) begin
						die5Ctr <= ctr5_5;
						ctr5_5 = ctr5_5 + 1;
						bgr_data_raw <= die5BGR;
						end
						else begin
						duke5Ctr <= ctr5_5d;
						ctr5_5d = ctr5_5d + 1;
						bgr_data_raw <= duke5BGR;
						end
					end
				end else if (die5 == 6) begin
					if ((x>=510) && (x<633) && (y>=345) && (y<466)) begin
					if (duke == 0) begin
						die6Ctr <= ctr5_6;
						ctr5_6 = ctr5_6 + 1;
						bgr_data_raw <= die6BGR;
						end
						else begin
						duke6Ctr <= ctr5_6d;
						ctr5_6d = ctr5_6d + 1;
						bgr_data_raw <= duke6BGR;
						end
					end
				end
					if (pos0 == 1 || sel0 == 1) begin
		if ((x>=52) && (x<77) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow0;
			arrow0 = arrow0 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos1 == 1) begin
		if ((x>=157) && (x<182) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow1;
			arrow1 = arrow1 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos2 == 1) begin
		if ((x>=256) && (x<281) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow2;
			arrow2 = arrow2 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos3 == 1) begin
		if ((x>=356) && (x<381) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow3;
			arrow3 = arrow3 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos4 == 1) begin
		if ((x>=456) && (x<481) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow4;
			arrow4 = arrow4 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos5 == 1) begin
		if ((x>=559) && (x<584) && (y>=102) && (y<121)) begin
			arrowCtr <= arrow5;
			arrow5 = arrow5 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos6 == 1 ) begin
		if ((x>=65) && (x<90) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow6;
			arrow6 = arrow6 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos7 == 1) begin
		if ((x>=163) && (x<188) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow7;
			arrow7 = arrow7 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos8 == 1) begin
		if ((x>=257) && (x<282) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow8;
			arrow8 = arrow8 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos9 == 1) begin
		if ((x>=349) && (x<374) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow9;
			arrow9 = arrow9 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos10 == 1) begin
		if ((x>=448) && (x<473) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow10;
			arrow10 = arrow10 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos11 == 1) begin
		if ((x>=545) && (x<570) && (y>=231) && (y<250)) begin
			arrowCtr <= arrow11;
			arrow11 = arrow11 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	if (pos12 == 1) begin
		if ((x>=301) && (x<326) && (y>=322) && (y<341)) begin
			arrowCtr <= arrow12;
			arrow12 = arrow12 + 1;
			bgr_data_raw <= arrowBGR;
		end
	end
	end // end of else
end else begin // end of if mif_toggle = 3
	bgr_data_raw <= 24'h123495;
//	bgr_data_raw <= 24'h150088;
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
 	















