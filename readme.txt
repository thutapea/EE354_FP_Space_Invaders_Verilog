This is a Verilog implementation of Space Invaders!

Apart from the logic common to the C implementation of Verilog (collision logic, movement, etc.), my Verilog implementation utilizes a psuedo-random number generator, a VGA driver, and button debouncing logic. 

Psuedo-random numbers are generated using a Linear Feedback Shift Register. On each clock, the LFSR shifts each bit to the left and XORS two bits to generate a psuedo-random number. The small 3-bit LFSR repeats after 8 numbers. However, this is not an issue as the random number is only used to select which 'enemy' shoots a bullet. Hence, the 3-bit LFSR suffices. This IP was verified prior to synthesis using a testbench. 

The game logic inputs three buttons (left, right, and shoot) and debounces each. It uses the debounced signal to change the player's position or enable a projectile. The vga driver then outputs a rectangle using this position / enable.

Collision is detected by comparing the x and y positions of the player/enemy to the projectiles. 

Once all the enemies are shot, a new wave starts where the clock speeds up. This causes the enemies to move faster and projectiles to appear more frequently. 
