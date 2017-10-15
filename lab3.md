# Lab 3

## Graphics Team
Radhika, Katherine, and Evan

### Introduction

For this component of the lab, we were tasked with demonstrating the functionality of the DE0-nano field programmable gate array (FPGA) in interfacing with a VGA serial monitor. Specifically, we had to write HDL code that would interact with the VGA driver. The VGA driver--which requests a pixel color for each pixel on the screen--handled the direct interfacing with the VGA. The output pins of the FPGA were hooked up to an adaptor, to which the VGA cable of the monitor was connected.


### FPGA-VGA Interface

The adaptor that connects the FPGA output to the VPA cable is a DAC converter. A DAC converter converts a digital input to an analog output. In other words, the FGPA encodes the 3-channel colors as multi-bit digital binary values, and then the adapter converts these multi-bit values into 1 continuous voltage value. In our case, the VGA supports a maximum 1v input for each color channel. Therefore, the voltage value for each channel is computed by converting the 2-3 bit values (with 3.3v for each `HIGH` bit) for each color channel into 1 analog voltage that can be between 0v and 1v. 

Below is a circuit diagram of the DAC:

![](./resources/dacconverter.png)

One can solve for the voltage at the `Red` node (`Vred`). Vred = 0.141*R[2] + 0.0684*R[1] + 0.0321*R[0]. Notice that the "weights" for each vary by powers of two, with the MSB having twice the weight as the 1st bit, and the 0th (LSB) bit having 1/4 of the weight as a MSB. In order words, the converter is adding up the bits and weighting each one accordingly in order to generate 1 final voltage value. The bins are also weighted such that if all bits (R[2], R[1], and R[0]) are pulled high (3.3v), the voltage at the output can be supported by the monitor (it comes out to ~0.8v).

A similar analysis yields the analog voltage at the `Green` node. 

For the blue node, the voltage `Vblue` comes out to be: Vblue = 0.1456*B[1] + 0.07096*B[0]. Notice that the weight for B[1] is twice that of B[0] in order to ensure that the analog voltage represents the digital value. 

The color (red, green, blue) intensity for any given pixel will be proportional to the analog voltage value for that given color channel. So if all the bits for a given channel are `HIGH`, the analog voltage will be at its highest, and the intensity of that color will be maximized.  


### Part 1: Coloring the entire screen

For the first part of this lab, we simply wanted to write the same color value to each pixel on the display. For this, we simply needed a simple `assign` statement (i.e. `assign PIXEL_COLOR = 8'd300`). 

### Part 2: Coloring a grid

For the second part of the lab, we wanted to have the FPGA write a colored 2x2 grid to the display. We didivided this task into two part: a) mapping the raw pixel coordinates to a quadrant on the 2x2 grid, and b) given a quadrant, output what the color should be. 

In order to compute what quadrant of the 2x2 (or outside the grid) a given pixel location corresponded to, we created a new module called `GRID_SELECTOR`. Essentially, `GRID_SELECTOR` divides the pixel coordinates by 128 in order to calculate the grid location. We achieve this division by using a bitshift. We also made the grid width a power of 2 in order to enable us to use this grid assignment method. We made it so that all pixels which fall outside the grid are given a value of 2 for the grid index. Below is our code for this module:

```
module GRID_SELECTOR(
CLOCK_50,
PIXEL_COORD_X,
PIXEL_COORD_Y,
GRID_X,
GRID_Y);


input CLOCK_50;
input wire [9:0] PIXEL_COORD_X;
input wire [9:0] PIXEL_COORD_Y;
output reg [3:0] GRID_X;
output reg [3:0] GRID_Y;




always @ (*) begin
	GRID_X = PIXEL_COORD_X >>>7;
	GRID_Y = PIXEL_COORD_Y >>>7;
	if (GRID_X>4'd1) begin
		GRID_X = 4'd2;
	end
	if (GRID_Y>4'd1) begin
		GRID_Y = 4'd2;
	end
end

	
endmodule

``` 

Within the main module (`DE0_NANO.v`), we instantiated this module and connected it to all the relevant wires. 

We then created a register memory block that would store all the colors for the grid, with indices corresponding to the `GRID_X` and `GRID_Y` outputs of `GRID_SELECTOR`. Below is the code for the memory array:

```
reg[7:0] grid4[2:0] [2:0];

always @(*) begin
	grid[0][0] = 8'd50;
	grid[1][0] = 8'd100;
	grid[0][1] = 8'd150;
	grid[1][1] = 8'd200;
	grid[2][0] = 8'd0;
	grid[2][1] = 8'd0;
	grid[2][2] = 8'd0;
	grid[0][2] = 8'd0;
	grid[1][2] = 8'd0;
	end
``` 

Finally, in order to assign the pixel color value, we perform the following assignment: `assign PIXEL_COLOR = grid[GRID_X][GRID_Y]`.

### Part 3: Rudimentary Arduino-FPGA Interface

For the final component of the graphics portion of the lab, we were tasked with demonstrating that we can use an Arduino to communicate with the FPGA in order to select the graphic to be illuminated. 

We wrote an Arduino script that repeatedly counts to 3 in binary, with a 1/2 second delay between each iteration:

```
int delayTime = 500; //ms; 

void setup() {

  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
}

void loop() {
  for (int i = 0; i<4; i++){
    if (i==0){
      digitalWrite(9, LOW);
      digitalWrite(8, LOW);
    }
    else if (i==1){
      digitalWrite(9, LOW);
      digitalWrite(8, HIGH);
    }
    else if (i==2){
      digitalWrite(9, HIGH);
      digitalWrite(8, LOW);
    }
    else{
      digitalWrite(9, HIGH);
      digitalWrite(8, HIGH);
    }
    delay(delayTime);
  }

}
```

The 2 bit Arduino output "data" then had to be transmitted to the FPGA. Since the Arduino outputs at 5v and the FPGA handles 3.3v, we implemented a simple voltage divider to pull down the voltage. We've included a circuit schematic:

![](./resources/fgpa_arduino_schem.png)

Notice that the voltage that is inputted to the FPGA is equal to the Arduino output pin voltage multiplied by 17.7/(17.7+9.89) =  0.64. When the Arduino voltage equals 5v (`HIGH`), then the voltage inputted to the FPGA (ports 33 and 31) equals roughly 3.2v, which is a permittable value for the FPGA. 

The goal was to have each distinct binary valued input correspond to a distinct grid to be outputted to the display. The display should, therefore, change grid layouts every 1/2 second. 

We made minor modifications to the code we previously had in order to allow for these changes. 

Firstly, we instatiated 4 new memory arrays, corresponding to the 4 different kinds of grids that would be displayed.

```
reg[7:0] grid1[2:0] [2:0];
	
	always @(*) begin
		 grid1[0][0] = 8'b11111111;
		 grid1[1][0] = 8'd300;
		 grid1[0][1] = 8'd300;
		 grid1[1][1] = 8'd300;
		 grid1[2][0] = 8'd00;
		 grid1[2][1] = 8'd00;
		 grid1[2][2] = 8'd00;
		 grid1[0][2] = 8'd00;
		 grid1[1][2] = 8'd00;
	end

	
	reg[7:0] grid2[2:0] [2:0];
	
	always @(*) begin
		 grid2[0][0] = 8'd300;
		 grid2[1][0] = 8'b11111111;
		 grid2[0][1] = 8'd300;
		 grid2[1][1] = 8'd300;
		 grid2[2][0] = 8'd0;
		 grid2[2][1] = 8'd0;
		 grid2[2][2] = 8'd0;
		 grid2[0][2] = 8'd0;
		 grid2[1][2] = 8'd0;
	end


	reg[7:0] grid3[2:0] [2:0];
	
	always @(*) begin
		 grid3[0][0] = 8'd300;
		 grid3[1][0] = 8'd300;
		 grid3[0][1] = 8'b11111111;
		 grid3[1][1] = 8'd300;
		 grid3[2][0] = 8'd0;
		 grid3[2][1] = 8'd0;
		 grid3[2][2] = 8'd0;
		 grid3[0][2] = 8'd0;
		 grid3[1][2] = 8'd0;
	end
	
	reg[7:0] grid4[2:0] [2:0];
	
	always @(*) begin
		 grid4[0][0] = 8'd300;
		 grid4[1][0] = 8'd300;
		 grid4[0][1] = 8'd300;
		 grid4[1][1] = 8'b11111111;
		 grid4[2][0] = 8'd0;
		 grid4[2][1] = 8'd0;
		 grid4[2][2] = 8'd0;
		 grid4[0][2] = 8'd0;
		 grid4[1][2] = 8'd0;
	end
	```

	Next, we added an `always` block that would set the `PIXEL_COLOR` depending on the value of the pins `GPIO_0_D[33]` and `GPIO_0_D[31]` (i.e. the output from the Arduino).

	```
		always @(*) begin
		if (GPIO_0_D[33]==1'd0 && GPIO_0_D[31] == 1'd0) begin
			PIXEL_COLOR = grid1[GRID_X][GRID_Y];
		end
		if (GPIO_0_D[33]==1'd0 && GPIO_0_D[31] == 1'd1) begin
			PIXEL_COLOR = grid2[GRID_X][GRID_Y];
		end
	 	if (GPIO_0_D[33]==1'd1 && GPIO_0_D[31] == 1'd0) begin
			PIXEL_COLOR = grid3[GRID_X][GRID_Y];
		end
		if (GPIO_0_D[33]==1'd1 && GPIO_0_D[31] == 1'd1) begin
			PIXEL_COLOR = grid4[GRID_X][GRID_Y];
		end
	end
	```

	We've included a video demonstration:

<video width="460" height="270" controls preload> 
    <source src="resources/fpga-arduino-interface.mp4></source> 
</video>



## Acoustic Team
Michael, TJ, and Frannie

Materials used:

- FPGA DEO-Nano
- 8-bit R2R DAC
- Stereo phone jack socket
- Lab speaker

The goal of the Acoustic Team was to generate a short tune from the FPGA to be played over a speaker. This tune will be played when the robot finishes mapping the maze.

#Generating a square wave





