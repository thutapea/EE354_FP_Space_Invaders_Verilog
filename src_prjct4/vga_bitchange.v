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

	wire whiteZone;
	reg reset;
	
    reg[9:0] ox_position_player;
    wire player;
    reg[49:0] x_clk;
    wire enemy;

	wire [9:0] x_position_player;
	wire [9:0] ben_v;
    wire [9:0] ben_x;
    wire bullet;
    wire collision;
    
	game_logic gl(.clk(clk), .BtnR(BtnR), .BtnL(BtnL), .BtnC(BtnC), .Reset(button), .x_position_player(x_position_player), .ben_v(ben_v), .ben_x(ben_x), .collision(collision));
	
	always@ (*) begin// paint a white box on a red background 
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if (player == 1)
	   rgb = BLUE;
	 else if (bullet ==1)
	   rgb = WHITE;
	 else if (enemy == 1)begin
	    if (collision)
	       rgb = WHITE;
	    else
		   rgb = GREEN;
	end
	 else if (whiteZone == 1)
		rgb = BLACK; // white box
	 else
		rgb = RED; // background color
	end
		
	assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd400) && (vCount <= 10'd475)) ? 1 : 0;

	assign player = ((hCount >= x_position_player) && (hCount < x_position_player + 10'd40)) &&
				   ((vCount >= 10'd400) && (vCount <= 10'd440)) ? 1 : 0;
				   
    assign enemy = ((hCount >= 10'd320) && (hCount < 10'd340)) &&
				   ((vCount >= 10'd84) && (vCount <= 10'd124)) ? 1 : 0;
				   
	assign bullet = ((hCount >= ben_x) && (hCount < ben_x + 10'd10)) &&
				   ((vCount >= ben_v) && (vCount <= ben_v + 10'd20)) ? 1 : 0;
	
	
endmodule
