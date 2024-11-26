`timescale 1ns / 1ps
// this module takes user input (btnl, btnr, btnc), debounces the signal, calculates position, and outputs position reg 

// demo 1 takes btn r, debounces, and shifts the square appropriately
module game_logic (
    input clk,
	input BtnR,
	input BtnL,
	input BtnC,
    input Reset,
	output reg[9:0]x_position_player,
	output reg[9:0]ben_v,
	output reg[9:0]ben_x,
	output reg collision);

    // local variables
    wire o_CCEN;
    wire L_MCEN;
    wire C_MCEN;
    reg[49:0] div_clk;
    reg ben;
    
    // local variables
    
    //initialize
    initial begin
		x_position_player = 10'd340;
		collision = 0;
	end

ee201_debouncer #(.N_dc(25)) ee201_debouncer_1 
        (.CLK(clk), .RESET(Reset), .PB(BtnR), .DPB( ), .SCEN( ), .MCEN(o_CCEN), .CCEN());
        
ee201_debouncer #(.N_dc(25)) ffee201_debouncer_2 
        (.CLK(clk), .RESET(Reset), .PB(BtnL), .DPB( ), .SCEN( ), .MCEN(L_MCEN), .CCEN());

ee201_debouncer #(.N_dc(25)) ggee201_debouncer_3 
        (.CLK(clk), .RESET(Reset), .PB(BtnC), .DPB( ), .SCEN( ), .MCEN(C_MCEN), .CCEN());

    always@ (posedge clk) begin
        if (o_CCEN)begin
            if (x_position_player >= 10'd744)begin
                x_position_player = x_position_player; end
            else begin
                x_position_player = x_position_player + 10'd10; end
        end
        else if (L_MCEN)begin
            if (x_position_player <= 10'd144)begin                 
                x_position_player = x_position_player; end         
            else begin                                             
                x_position_player = x_position_player - 10'd10; end
        end
        else if (C_MCEN)begin
            ben = 1;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
        end           
    
    
    //bullet logic
        if (ben)begin
            div_clk = div_clk + 50'd1;
                if (div_clk >= 50'd500000)begin
                    div_clk = 50'd0;
                    ben_v = ben_v - 10'd1; end
        
                if (ben_v <= 10'd34)begin
                    ben_v = 10'd400;
                    ben = 0;
                end
        end
        
    //collision logic 
        if ((ben_x >= 10'd310) & (ben_x <= 10'd340) & (ben_v <= 10'd124))begin
            collision = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            end
    end

endmodule