`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
	input clk,
	input bright,
	input BtnC,
	input button,
	input BtnR,
	input BtnL,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [15:0] score
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;
	parameter PINK = 12'b1111_1100_1101;

	wire whiteZone;
	reg reset;
	
    reg[9:0] ox_position_player;
    wire player;
    reg[49:0] x_clk;
    wire fenemy;

	wire [9:0] x_position_player;
	wire [9:0] ben_v;
    wire [9:0] ben_x;
    wire bullet;
    wire collision;
    wire [9:0] enemy1_x;
    wire [9:0] enemy1_y;
    wire [9:0] enemy1_bx;
    wire [9:0] enemy1_by;
    wire       enemy1_d;
    wire       enemy1_c;
    wire game_over;

    wire enemy1bullet; //to display flag
	wire enemy2bullet;
	wire enemy3bullet;
	wire enemy4bullet;
	wire enemy5bullet;
	wire enemy6bullet;
	wire enemy7bullet;
	wire enemy8bullet;
	wire enemy9bullet;

	wire [9:0] enemy2_bx;
    wire [9:0] enemy2_by;
	wire [9:0] enemy3_bx;
    wire [9:0] enemy3_by;
	wire [9:0] enemy4_bx;
    wire [9:0] enemy4_by;
	wire [9:0] enemy5_bx;
    wire [9:0] enemy5_by;
	wire [9:0] enemy6_bx;
    wire [9:0] enemy6_by;		
	wire [9:0] enemy7_bx;
    wire [9:0] enemy7_by;
	wire [9:0] enemy8_bx;
    wire [9:0] enemy8_by;
	wire [9:0] enemy9_bx;
    wire [9:0] enemy9_by;

	wire enemy_BL; // should be flag not to display but be black or white 
	wire enemy_BR;

	wire enemy2_d; // display flag local register
	wire enemy3_d;
	wire enemy4_d;
	wire enemy5_d;
	wire enemy6_d;
	wire enemy7_d;
	wire enemy8_d;
	wire enemy9_d;
	
	wire splash_screen;

	game_logic gl(.clk(clk), .BtnR(BtnR), .BtnL(BtnL), .BtnC(BtnC), .Reset(button), .x_position_player(x_position_player), .ben_v(ben_v), .ben_x(ben_x), .collision(collision),
	 .enemy1_x(enemy1_x), .enemy1_y(enemy1_y),
	  .enemy1_bx(enemy1_bx), .enemy1_by(enemy1_by),
	   .enemy1_d(enemy1_d), .enemy1_c(enemy1_c),
	    .game_over(game_over),
	 .enemy2_by(enemy2_by), .enemy2_bx(enemy2_bx),
	  .enemy3_by(enemy3_by), .enemy3_bx(enemy3_bx),
	  .enemy4_by(enemy4_by), .enemy4_bx(enemy4_bx),
	  .enemy5_by(enemy5_by), .enemy5_bx(enemy5_bx),
	  .enemy6_by(enemy6_by), .enemy6_bx(enemy6_bx),
	  .enemy7_by(enemy7_by), .enemy7_bx(enemy7_bx),
	  .enemy8_by(enemy8_by), .enemy8_bx(enemy8_bx),
	  .enemy9_by(enemy9_by), .enemy9_bx(enemy9_bx),
	   .enemy_BL(enemy_BL), .enemy_BR(enemy_BR),
	   .enemy_MM(enemy_MM), .enemy_ML(enemy_ML), .enemy_MR(enemy_MR),
	   .enemy_TM(enemy_TM), .enemy_TL(enemy_TL), .enemy_TR(enemy_TR), .splash_screen(splash_screen));
	
	always@ (*) begin// paint a white box on a red background 
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if (game_over ==1)
	       rgb = PINK;
	 else if (splash_screen == 1)
	   rgb = GREEN;
	  else if (player == 1)
	   rgb = BLUE;
	 else if (bullet ==1)begin
	 	if (ben_v >=10'd399)
			rgb = BLACK;
	   	else
			rgb = WHITE;
	end
	else if (enemy1_d == 1)begin
	   if (enemy1_c)
	       rgb = BLACK;
	   else
	       rgb = GREEN;
	end

	else if (enemy2_d ==1)begin
		if (enemy_BL ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy3_d ==1)begin
		if (enemy_BR ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy4_d ==1)begin
		if (enemy_MM ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy5_d ==1)begin
		if (enemy_ML ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy6_d ==1)begin
		if (enemy_MR ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy7_d ==1)begin
		if (enemy_TM ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy8_d ==1)begin
		if (enemy_TL ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy9_d ==1)begin
		if (enemy_TR ==1)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy1bullet == 1)begin
		if (enemy1_c)
			rgb = BLACK;
		else
			rgb = WHITE;
	end
	else if (enemy2bullet == 1)begin
		if(enemy_BL)
			rgb = BLACK;
		else
			rgb = WHITE;
	end
	else if (enemy3bullet == 1)begin
		if(enemy_BR)
			rgb =BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy4bullet == 1)begin
		if(enemy_MM)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy5bullet == 1)begin
		if(enemy_ML)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy6bullet == 1)begin
		if(enemy_MR)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy7bullet == 1)begin
		if(enemy_TM)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy8bullet == 1)begin
		if(enemy_TL)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	else if (enemy9bullet == 1)begin
		if(enemy_TR)
			rgb = BLACK;
		else
			rgb = WHITE;
	end

	 else if (whiteZone == 1)
		rgb = BLACK; // white box
	 else
		rgb = BLACK; // background color
	end
		
	assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd400) && (vCount <= 10'd475)) ? 1 : 0;

	assign player = ((hCount >= x_position_player) && (hCount < x_position_player + 10'd40)) &&
				   ((vCount >= 10'd400) && (vCount <= 10'd440)) ? 1 : 0;
				   
	assign bullet = ((hCount >= ben_x) && (hCount < ben_x + 10'd10)) &&
				   ((vCount >= ben_v) && (vCount <= ben_v + 10'd20)) ? 1 : 0;
	
	assign enemy1_d = ((hCount >= enemy1_x) && (hCount <= enemy1_x + 10'd20)) &&
				   ((vCount >= enemy1_y) && (vCount <= enemy1_y + 10'd20)) ? 1 : 0;
	
	assign enemy2_d = ((hCount >= (enemy1_x -10'd25)) && (hCount <= enemy1_x - 10'd5)) &&
				   ((vCount >= enemy1_y) && (vCount <= enemy1_y + 10'd20)) ? 1 : 0;

	assign enemy3_d = ((hCount >= (enemy1_x + 10'd25)) && (hCount <= enemy1_x + 10'd45)) &&
				   ((vCount >= enemy1_y) && (vCount <= enemy1_y + 10'd20)) ? 1 : 0;
	//**** row2
	assign enemy4_d = ((hCount >= enemy1_x) && (hCount <= enemy1_x + 10'd20)) &&
				   ((vCount >= enemy1_y - 10'd25) && (vCount <= enemy1_y - 10'd5)) ? 1 : 0;
	
	assign enemy5_d = ((hCount >= (enemy1_x -10'd25)) && (hCount <= enemy1_x - 10'd5)) &&
				   ((vCount >= enemy1_y - 10'd25) && (vCount <= enemy1_y - 10'd5)) ? 1 : 0;

	assign enemy6_d = ((hCount >= (enemy1_x + 10'd25)) && (hCount <= enemy1_x + 10'd45)) &&
				   ((vCount >= enemy1_y - 10'd25) && (vCount <= enemy1_y - 10'd5)) ? 1 : 0;
	//**** row2 end
	//*** row3
	assign enemy7_d = ((hCount >= enemy1_x) && (hCount <= enemy1_x + 10'd20)) &&
				   ((vCount >= enemy1_y - 10'd50) && (vCount <= enemy1_y - 10'd30)) ? 1 : 0;
	
	assign enemy8_d = ((hCount >= (enemy1_x -10'd25)) && (hCount <= enemy1_x - 10'd5)) &&
				   ((vCount >= enemy1_y - 10'd50) && (vCount <= enemy1_y - 10'd30)) ? 1 : 0;

	assign enemy9_d = ((hCount >= (enemy1_x + 10'd25)) && (hCount <= enemy1_x + 10'd45)) &&
				   ((vCount >= enemy1_y - 10'd50) && (vCount <= enemy1_y - 10'd30)) ? 1 : 0;
	//*** row3 end
				   
	assign enemy1bullet = ((hCount >= enemy1_bx) && (hCount <= enemy1_bx + 10'd5)) &&
				   ((vCount >= enemy1_by) && (vCount <= enemy1_by + 10'd5)) ? 1 : 0;

	assign enemy2bullet = ((hCount >= enemy2_bx) && (hCount <= enemy2_bx + 10'd5)) &&
				   ((vCount >= enemy2_by) && (vCount <= enemy2_by + 10'd5)) ? 1 : 0;
	
	assign enemy3bullet = ((hCount >= enemy3_bx) && (hCount <= enemy3_bx + 10'd5)) &&
				   ((vCount >= enemy3_by) && (vCount <= enemy3_by + 10'd5)) ? 1 : 0;
	
	//***** new bullets
	assign enemy4bullet = ((hCount >= enemy4_bx) && (hCount <= enemy4_bx + 10'd5)) &&
				   ((vCount >= enemy4_by) && (vCount <= enemy4_by + 10'd5)) ? 1 : 0;

	assign enemy5bullet = ((hCount >= enemy5_bx) && (hCount <= enemy5_bx + 10'd5)) &&
				   ((vCount >= enemy5_by) && (vCount <= enemy5_by + 10'd5)) ? 1 : 0;
	
	assign enemy6bullet = ((hCount >= enemy6_bx) && (hCount <= enemy6_bx + 10'd5)) &&
				   ((vCount >= enemy6_by) && (vCount <= enemy6_by + 10'd5)) ? 1 : 0;

	assign enemy7bullet = ((hCount >= enemy7_bx) && (hCount <= enemy7_bx + 10'd5)) &&
				   ((vCount >= enemy7_by) && (vCount <= enemy7_by + 10'd5)) ? 1 : 0;

	assign enemy8bullet = ((hCount >= enemy8_bx) && (hCount <= enemy8_bx + 10'd5)) &&
				   ((vCount >= enemy8_by) && (vCount <= enemy8_by + 10'd5)) ? 1 : 0;
	
	assign enemy9bullet = ((hCount >= enemy9_bx) && (hCount <= enemy9_bx + 10'd5)) &&
				   ((vCount >= enemy9_by) && (vCount <= enemy9_by + 10'd5)) ? 1 : 0;
	
endmodule
