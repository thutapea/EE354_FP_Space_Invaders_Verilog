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
	output reg collision,
	output reg [9:0] enemy1_x,
	output reg [9:0] enemy1_y,
	output reg [9:0] enemy1_bx,
	output reg [9:0] enemy1_by,
	output reg       enemy1_d,
	output reg       enemy1_c,
	output reg game_over,
    output reg [9:0] enemy2_by,
    output reg [9:0] enemy2_bx,
    output reg [9:0] enemy3_by,
    output reg [9:0] enemy3_bx,
    output reg [9:0] enemy4_by,
    output reg [9:0] enemy4_bx,
    output reg [9:0] enemy5_by,
    output reg [9:0] enemy5_bx,
    output reg [9:0] enemy6_by,
    output reg [9:0] enemy6_bx,
    output reg [9:0] enemy7_by,
    output reg [9:0] enemy7_bx,
    output reg [9:0] enemy8_by,
    output reg [9:0] enemy8_bx,
    output reg [9:0] enemy9_by,
    output reg [9:0] enemy9_bx,
    output reg       enemy_BL,
    output reg       enemy_BR,
    output reg       enemy_MM,
    output reg       enemy_ML,
    output reg       enemy_MR,
    output reg       enemy_TM,
    output reg       enemy_TL,
    output reg       enemy_TR,
    output reg       splash_screen);

    // local variables
    wire o_CCEN;
    wire L_MCEN;
    wire C_MCEN;
    reg[49:0] div_clk; // bullet clock
    reg[49:0] div_clk2; // enemy clock
    reg[49:0] div_clk3; // enemy bullet masterclock
    reg[49:0] div_clk4; // enemy bullet enable generator
    reg[49:0] div_clk5; // splash_screen timer
    reg[49:0] movement_speed_wave_input; // enemy bullet enable generator
    reg[49:0] bullet_speed_wave_input;
    reg[4:0] enemy_movement_clock;
    reg ben;
    reg bounce;
    reg boundary;
    reg enable_enemybullet;
    reg enable_enemybullet2;
    reg enable_enemybullet3;
    reg enable_enemybullet4;
    reg enable_enemybullet5;
    reg enable_enemybullet6;
    reg enable_enemybullet7;
    reg enable_enemybullet8;
    reg enable_enemybullet9;
    reg[2:0] random_number;
   //enemy array x, y, bx, by, s, a, d,
    
    // local variables
    
    //initialize
    initial begin
		x_position_player = 10'd340;
		enemy1_c = 0;
		enemy1_x = 10'd340;
		enemy1_y = 10'd84;
		bounce = 1;
		game_over = 0;
		enemy_BR = 0;
		enemy_TR = 0;
		enemy_TL = 0;
		enemy_ML = 0;
		bullet_speed_wave_input = 50'd2000000000;
		movement_speed_wave_input = 50'd2000000;
		random_number = 1;
		
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

    //***** row 1  
    //collision logic for enemy1 TODO COPY FOR ALL ENEMIES 
        if ((ben_x >= enemy1_x) & (ben_x <= enemy1_x+ 10'd20) & (ben_v == enemy1_y + 10'd20) & ~enemy1_c)begin
            enemy1_c = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy1

    //collision logic for enemy2 (bottom left)
            if ((ben_x >= enemy1_x -10'd25) & (ben_x <= enemy1_x - 10'd5) & (ben_v == enemy1_y + 10'd20) & ~enemy_BL)begin
            enemy_BL = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy2 (bottom left)

    //collision logic for enemy3 (bottom right)
            if ((ben_x >= enemy1_x + 10'd25) & (ben_x <= enemy1_x + 10'd45) & (ben_v == enemy1_y + 10'd20) & ~enemy_BR)begin
            enemy_BR = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy3 (bottom right)
    //**** end row 1

    //**** row 2
    //collision logic for enemy1 TODO COPY FOR ALL ENEMIES 
        if ((ben_x >= enemy1_x) & (ben_x <= enemy1_x+ 10'd20) & (ben_v == enemy1_y - 10'd25) & ~enemy_MM)begin
            enemy_MM = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy1

    //collision logic for enemy2 (bottom left)
            if ((ben_x >= enemy1_x -10'd25) & (ben_x <= enemy1_x - 10'd5) & (ben_v == enemy1_y - 10'd25) & ~enemy_ML)begin
            enemy_ML = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy2 (bottom left)

    //collision logic for enemy3 (bottom right)
            if ((ben_x >= enemy1_x + 10'd25) & (ben_x <= enemy1_x + 10'd45) & (ben_v == enemy1_y - 10'd25) & ~enemy_MR)begin
            enemy_MR = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy3 (bottom right)    
    //**** end of row 2

    //**** row 3
    //collision logic for enemy1 TODO COPY FOR ALL ENEMIES 
        if ((ben_x >= enemy1_x) & (ben_x <= enemy1_x+ 10'd20) & (ben_v == enemy1_y - 10'd50) & ~enemy_TM)begin
            enemy_TM = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy1

    //collision logic for enemy2 (bottom left)
            if ((ben_x >= enemy1_x -10'd25) & (ben_x <= enemy1_x - 10'd5) & (ben_v == enemy1_y - 10'd50) & ~enemy_TL)begin
            enemy_TL = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy2 (bottom left)

    //collision logic for enemy3 (bottom right)
            if ((ben_x >= enemy1_x + 10'd25) & (ben_x <= enemy1_x + 10'd45) & (ben_v == enemy1_y - 10'd50) & ~enemy_TR)begin
            enemy_TR = 1;
            ben = 0;
            ben_v = 10'd400;
            ben_x = x_position_player + 10'd15;
            
            end
    //collision logic for enemy3 (bottom right)
    //**** end of row 3
// enemy movement logic
            div_clk2 = div_clk2+ 50'd1;
        if (div_clk2 >= movement_speed_wave_input)begin
            div_clk2 = 50'd0;
            enemy_movement_clock = enemy_movement_clock + 5'd1;
            //if (~enemy1_c & )begin //TODO CHANGE FOR ALL ENEMIES should be and honestly not needed
            if (bounce)begin
                enemy1_y = enemy1_y + 10'd10;
                bounce = 0;
                boundary = ~boundary;
                end
            if (boundary)begin
                enemy1_x = enemy1_x + 10'd1;
                if (enemy1_x >= 10'd764)begin
                    bounce = 1;
                    enemy1_x = enemy1_x;
                    end                    
            end
            if (boundary == 0)begin
                enemy1_x = enemy1_x - 10'd1;
                if (enemy1_x <= 10'd144)begin
                    bounce = 1;
                    enemy1_x = enemy1_x;
                    end
            end   
            //end // enemy collision enable
            
        end
//enemy bullet logic 
// @100MHz, 500000 = 155px/s or 4 sec to cover display
    div_clk3 = div_clk3 + 50'd1;
    // TODO COPY FOR ALL 9
    if (div_clk3 >= 50'd750000)begin
        div_clk3 =0;
        if (enable_enemybullet) begin
            if(enemy1_by >=516)begin
                enemy1_by = enemy1_by;
                enable_enemybullet = 0;
            end
            else
                enemy1_by = enemy1_by + 10'd1;
        end

        //enemy bullet 2 velocity
        if (enable_enemybullet2) begin
            if(enemy2_by >=516)begin
                enemy2_by = enemy2_by;
                enable_enemybullet2 = 0;
            end
            else
                enemy2_by = enemy2_by + 10'd1;
        end
        //enemy bullet 3 velocity
        if (enable_enemybullet3) begin
            if(enemy3_by >=516)begin
                enemy3_by = enemy3_by;
                enable_enemybullet3 = 0;
            end
            else
                enemy3_by = enemy3_by + 10'd1;
        end

        //enemy bullet 4 velocity
        if (enable_enemybullet4) begin
            if(enemy4_by >=516)begin
                enemy4_by = enemy4_by;
                enable_enemybullet4 = 0;
            end
            else
                enemy4_by = enemy4_by + 10'd1;
        end

        //enemy bullet 5 velocity
        if (enable_enemybullet5) begin
            if(enemy5_by >=516)begin
                enemy5_by = enemy5_by;
                enable_enemybullet5 = 0;
            end
            else
                enemy5_by = enemy5_by + 10'd1;
        end

        //enemy bullet 6 velocity
        if (enable_enemybullet6) begin
            if(enemy6_by >=516)begin
                enemy6_by = enemy6_by;
                enable_enemybullet6 = 0;
            end
            else
                enemy6_by = enemy6_by + 10'd1;
        end

        //enemy bullet 7 velocity
        if (enable_enemybullet7) begin
            if(enemy7_by >=516)begin
                enemy7_by = enemy7_by;
                enable_enemybullet7 = 0;
            end
            else
                enemy7_by = enemy7_by + 10'd1;
        end

        //enemy bullet 8 velocity
        if (enable_enemybullet8) begin
            if(enemy8_by >=516)begin
                enemy8_by = enemy8_by;
                enable_enemybullet8 = 0;
            end
            else
                enemy8_by = enemy8_by + 10'd1;
        end

        //enemy bullet 9 velocity
        if (enable_enemybullet9) begin
            if(enemy9_by >=516)begin
                enemy9_by = enemy9_by;
                enable_enemybullet9 = 0;
            end
            else
                enemy9_by = enemy9_by + 10'd1;
        end


    end // end divclk
    // TODO COPY FOR ALL 9

    //TODO IMPLEMENT PSUEDO RANDOM to SELECT between all 9 
    div_clk4 = div_clk4 + 50'd1;
    if (div_clk4 >= bullet_speed_wave_input)begin
    
    //random number generator
    random_number = {random_number[1:0], random_number[2] ^ random_number[1]};
    
    
    // random number generator
    div_clk4 = 0; //enables should go here.
    
    if (~enemy1_c & (random_number == 1))begin
    enable_enemybullet = 1;
    enemy1_bx = enemy1_x + 10'd8;
    enemy1_by = enemy1_y;
    end
    
    if (~enemy_BL & (random_number == 1))begin
    enable_enemybullet2 = 1;
    enemy2_bx = enemy1_x -10'd13;
    enemy2_by = enemy1_y;
    end

    if (~enemy_BR & (random_number == 2))begin
    enable_enemybullet3 = 1;
    enemy3_bx = enemy1_x + 10'd33;
    enemy3_by = enemy1_y;
    end

    if (~enemy_MM & (random_number == 3))begin
    enable_enemybullet4 = 1;
    enemy4_bx = enemy1_x + 10'd8;
    enemy4_by = enemy1_y - 10'd25;
    end    
    
    if (~enemy_ML & (random_number == 4))begin
    enable_enemybullet5 = 1;
    enemy5_bx = enemy1_x - 10'd13;
    enemy5_by = enemy1_y - 10'd25;
    end

    if (~enemy_MR & (random_number == 5))begin
    enable_enemybullet6 = 1;
    enemy6_bx = enemy1_x + 10'd33;
    enemy6_by = enemy1_y - 10'd25;
    end

    if (~enemy_TM & (random_number == 6))begin
    enable_enemybullet7 = 1;
    enemy7_bx = enemy1_x + 10'd8;
    enemy7_by = enemy1_y - 10'd50;
    end   

    if (~enemy_TL & (random_number == 7))begin
    enable_enemybullet8 = 1;
    enemy8_bx = enemy1_x - 10'd13;
    enemy8_by = enemy1_y - 10'd50;
    end   

    if (~enemy_TR & (random_number == 7))begin
    enable_enemybullet9 = 1;
    enemy9_bx = enemy1_x + 10'd33; //changed from 8 to 33
    enemy9_by = enemy1_y - 10'd50;
    end   

    end //div_clk 4 end
    
    //TODO COPY FOR ALL 9
    //enemybullet-player collision
    if ((enemy1_bx >= x_position_player - 10'd5) & (enemy1_bx <= x_position_player + 10'd40) & (enemy1_by >= 10'd390) & (enemy1_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet = 0;
        end

    if ((enemy2_bx >= x_position_player - 10'd5) & (enemy2_bx <= x_position_player + 10'd40) & (enemy2_by >= 10'd390) & (enemy2_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet2 = 0;
        end

    if ((enemy3_bx >= x_position_player - 10'd5) & (enemy3_bx <= x_position_player + 10'd40) & (enemy3_by >= 10'd390) & (enemy3_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet3 = 0;
        end
    
    if ((enemy4_bx >= x_position_player - 10'd5) & (enemy4_bx <= x_position_player + 10'd40) & (enemy4_by >= 10'd390) & (enemy4_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet4 = 0;
        end

    if ((enemy5_bx >= x_position_player - 10'd5) & (enemy5_bx <= x_position_player + 10'd40) & (enemy5_by >= 10'd390) & (enemy5_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet5 = 0;
        end

    if ((enemy6_bx >= x_position_player - 10'd5) & (enemy6_bx <= x_position_player + 10'd40) & (enemy6_by >= 10'd390) & (enemy6_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet6 = 0;
        end    

    if ((enemy7_bx >= x_position_player - 10'd5) & (enemy7_bx <= x_position_player + 10'd40) & (enemy7_by >= 10'd390) & (enemy7_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet7 = 0;
        end

    if ((enemy8_bx >= x_position_player - 10'd5) & (enemy8_bx <= x_position_player + 10'd40) & (enemy8_by >= 10'd390) & (enemy8_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet8 = 0;
        end

    if ((enemy9_bx >= x_position_player - 10'd5) & (enemy9_bx <= x_position_player + 10'd40) & (enemy9_by >= 10'd390) & (enemy9_by <= 10'd440)) begin
        game_over =1;
        enable_enemybullet9 = 0;
        end    


// game state machine (for levels / waves) change to all are gone 
if (enemy1_c & enemy_BL & enemy_BR & enemy_MM & enemy_ML & enemy_MR & enemy_TR & enemy_TM & enemy_TL)begin
    splash_screen =1;
    div_clk5 = div_clk5 + 50'd1;
    if (div_clk5 >= 50000000)begin
    splash_screen =0;
    div_clk5 = 0;
    movement_speed_wave_input = movement_speed_wave_input - 50'd250000;
    bullet_speed_wave_input = bullet_speed_wave_input - 50'd500000000;
    enemy1_c = 0;
    enemy_BL = 0;
    enemy_BR = 0;
    enemy_MM = 0;
    enemy_ML = 0;
    enemy_MR = 0;
    enemy_TR = 0;
    enemy_TM = 0;
    enemy_TL = 0;
    x_position_player = 10'd340;
	enemy1_x = 10'd340;
	enemy1_y = 10'd84;
	bounce = 1;
	end//splash screen end
    end // next wave
    end // master always end

endmodule