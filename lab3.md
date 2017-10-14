# Lab 3

## Graphics Team

For this component of the lab, we were tasked with demonstrating the functionality of the DE0-nano field programmable gate array (FPGA) in interfacing with a VGA serial monitor. Specifically, we had to write HDL code that would interact with the VGA driver. The VGA driver--which requests a pixel color for each pixel on the screen--handled the direct interfacing with the VGA. The output pins of the FPGA were hooked up to an adaptor, to which the VGA cable of the monitor was connected.
\\add stuff on voltage divider/dac conversion

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

The 2 bit Arduino output "data" then had to be transmitted to the FPGA. Since the Arduino outputs at 5v and the FPGA handles 3.3v, we implemented a simply voltage divider to pull down the voltage. 




