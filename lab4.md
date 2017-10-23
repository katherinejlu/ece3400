[Home](./homepage.md) 

# Lab 4

## Radio Team

### Overview of how wireless communication works/introduction/materials used
Radhika

### Sending full maze coordinates and maze updates with wireless communication
Katherine

### Sending information from base station to FPGA 
Evan

## FPGA Team
TJ, Frannie, Michael

### Introduction

For our sub-team, the goal of this lab was to recieve packets of information from the Arduino, and then use this information to update the VGA monitor using the FPGA. In order to accomplish this, we first built off of our team's work from Lab 3.

#### Materials used:

- FPGA DE0-Nano
- VGA-FPGA adapter
- VGA cable and monitor

### Drawing a 4x5 grid

Changing our grid size was a fairly simple process, but did require some troubleshooting. First we updated the line `reg[7:0] grid1[2:0] [2:0]` to `reg[7:0] grid1[3:0] [4:0]` in our main module. We then assigned a color to each register in grid1 to create a checkerboard pattern. 

When we uploaded the code to the FPGA, the squares were too large to view the full grid.  Thus, we changed the always block in our `GridSelector` module to the following:

'''
always @ (*) begin
	GRID_X = PIXEL_COORD_X / 96;
	GRID_Y = PIXEL_COORD_Y / 96;
end
'''

Instead of bitshifting by 7 bits (dividing by 128), we decided to divide by 96, since the height of the monitor is 480 pixels. 480 pixels / 5 squares = 96 pixels / square.

The squares were now all visible, but the grid would only display 4x4. After reviewing our code for a while, we realized we hadn't updated the registers `GRID_X` and `GRID_Y` to hold enough bits. We changed both of these to 4 bit registers and the grid was now 4x5!

### Changing color based on loaction



### Explaination of the FPGA working with the Arduino, the challenges we faced, the resistor array, pins, etc.

