[Home](./homepage.md) 

# Lab 4

## Radio Team

### Overview of how wireless communication works/introduction/materials used
Radhika

### Sending full maze coordinates and maze updates with wireless communication
To send the full maze coordinates, we altered the code to send a 5x5 array of unsigned chars. When sending and receiving transmissions, the arduino needs to be told what size packet it will be sending or receiving, so the key is to explicitly state what the maze size was when reading and writing data. When sending maze updates, one arduino just sent a 1x3 array of unsigned chars--the first two being the maze coordinate, and the new information that corresponded with that data point. 

So for sending and receiving  a 5x5 array: 

```
unsigned char maze[5][5] =
{
3, 3, 3, 3, 3,
3, 1, 1, 1, 3,
3, 2, 0, 1, 2,
3, 1, 3, 1, 3,
3, 0, 3, 1, 0,
};

//sending 
bool ok = radio.write( &updates, sizeof(unsigned char)*25);
//receiving 
bool done = radio.read( &updates, sizeof(unsigned char)*25);
```

We noticed that when we increased the packet size, more packets of information were being dropped or taking too long to transmit, so we also played around with higher data rates and power levels. 

```
  // set the power
  // RF24_PA_MIN=-18dBm, RF24_PA_LOW=-12dBm, RF24_PA_MED=-6dBM, and RF24_PA_HIGH=0dBm.
  radio.setPALevel(RF24_PA_MED);
  //RF24_250KBPS for 250kbs, RF24_1MBPS for 1Mbps, or RF24_2MBPS for 2Mbps
  radio.setDataRate(RF24_2MBPS);
```

Here is a video of one arduino sending the entire maze to another: 

<video width="460" height="270" controls preload> 
    <source src="resources/maze.mp4"></source> 
</video>

### Sending information from base station to FPGA 
Evan


For the final part of the lab, we had to create a system for sending maze information from the Arduino base station to the FPGA. Since the robot was not yet operational, and we had already demonstrated that we can communicate wirelessly between the Arduinos, we generated test robot coordinate data to simulate the robot traversing the maze. Since we were able to demonstrate communication between the Arduinos, and from the Arduino to the base station, it will be relatively straightforward to link all of these devices together. Note that we did not demonstrate the communication of treasure and wall data from the Arduino to the FPGA. We have established a preliminary protocol for transmitting this data, but have not yet demonstrated this in practice. 

Here is the Arduino code we wrote for this component of the lab (each part will be explained)

```
int delayTime = 500; //ms;
int setupTime = 50; //ms;
String inputSignals[32] = {
                        "00000", "01000", "10000", "11000",
                        "00001", "01001","10001", "11001",
                        "00010",  "01010", "10010", "11010",
                        "00011", "01011", "10011", "11011",
                        "00100", "01100", "10100", "11100",
                        "00101", "01101","10101", "11101", 
                        "00110", "01110", "10110", "11110",
                        "00111", "01111", "10111", "11111",
                        };

                        
void generateClock(){
  
}

                        
void setup() {
  Serial.begin(9600);
  pinMode(7,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(4,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(2,OUTPUT);

}

void loop() {
  
  for (int i = 0; i<32; i++){
    String signalWord = inputSignals[i];
    sendWord(signalWord);
    delay(delayTime);   
  }
}


void sendWord(String signalWord){
  digitalWrite(2, LOW);
  delay(setupTime);
  writeWord(signalWord);
  delay(setupTime);
  digitalWrite(2, HIGH);
}

void writeWord(String signalWord){
  for (int i = 0; i<5; i++){
    if (signalWord.charAt(i) == '0'){
      digitalWrite(7-i, LOW);
    }
    else{
      digitalWrite(7-i, HIGH);
    }
  }
}
```

As discussed, the maze coordinate are encoded in a 5 bit word. In the Arduino code, we hard coded all 20 maze coordinates that the robot could possibly reach. This can be seen when we instantiate the `inputSignals` array. 

Since the FPGA reads this word on the rising edge of a clock, we had to create a psuedo-clock 1-bit signal in Arduino that is sychronized to change when we are ready to read the data. This is done in the `sendWord` method. Pin 2 corresponds to our "clock". We write a `LOW` value to the clock pin, and then wait `setupTime` amount of milliseconds before proceeding to actually write the coordinates to pins 7-3. We wait `setupTime` milliseconds before flipping the clock to a `HIGH` signal. Our thinking was that there is some propagation delay in the circuit. 50 milliseconds is plenty of time for the signal to set up, and for the FPGA to sample the correct value. If we didn't clock our signal, then we would run into issues sampling the signal when it is transitioning between values. 

The `writeWord` method is relatively straightforwards. It simply iterates through the word string, and then writes the values to the appropriate pin. 

The output pins corresponding to the coordinate data and clock (digital pins 7-2) were connected to a voltage divider array in order to be sent to the FPGA (to be discussed in next section).



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

```
always @ (*) begin
	GRID_X = PIXEL_COORD_X / 96;
	GRID_Y = PIXEL_COORD_Y / 96;
end
```

Instead of bitshifting by 7 bits (dividing by 128 as before, we decided to divide by 96, since the height of the monitor is 480 pixels. 480 pixels / 5 squares = 96 pixels / square.

The squares were now all visible, but the grid would only display 4x4. After reviewing our code for a while, we realized we hadn't updated the registers `GRID_X` and `GRID_Y` to hold enough bits. We changed both of these to 4 bit registers and the grid was now 4x5!

### Changing color based on loaction

Next, we needed to be able to update the grid to show the current location of the robot, as well as visited locations. To do this, we needed to rework the code from last lab, which had 4 different maps stored in memory. Rather than have each possible map stored in memory, we decided to update the map dynamically.

To accomplish this, we created the following state machine:

```
reg[7:0] grid1[3:0][4:0];
reg[7:0] currentGrid;
   
//state machine 
always @(posedge CLOCK_25) begin
  if (GRID_X > 3) begin //colors squares that aren't in the 4x5 grid black
    PIXEL_COLOR <= black;
  end
  else begin
  currentGrid <= grid1[GRID_X][GRID_Y];
    if (currentGrid == 0) begin //if no input, color current square white
      PIXEL_COLOR <= white;
    end
    if (currentGrid[0] == 1) begin //if LSB is 1, color current square pink
      PIXEL_COLOR <= pink;
    end
  end
end
```

### Explanation of the FPGA working with the Arduino, the challenges we faced, the resistor array, pins, etc.

With our 'state machine' working properly, it was easy to quickly assign different states to a grid tile and have a record of visited tiles. Our last step was to get the two halves of our assignment working together. We coordinated with the Arduino half of the team to make a protocol for robot position. In this case, we used the simplest possible communication scheme: A 5 bit array, with the first 2 bits representing x position, and the latter 3 representing y position. 

Our FPGA was hooked up directly to the Arduino by a set of 6 wires (5 data bits, one valid bit). This setup took a frustrating amount of time, because the DE0 Nano datasheet's pinout diagram for GPIO-1 is unintuitive (to put it lightly). Once our pins were indeed hooked up correctly (this took a lot of oscilloscope debugging on our part), we worked on properly interpreting messages from the Arduino.

We used an independent module for the reading of data from the Arduino, called inputReader:
```


```

We initially struggled to get data to correctly update (our screen update schema was simple - put the robot on the tile the Arduino sent, record all past tiles sent as visited, and make the rest unvisited). We observed that in general, the tiles were flipping to visited in the order we expected, but not at a constant rate. Certain tiles would change colors two at a time. This signaled to us that the FPGA was not reading the data correctly. Because our inputReader module was reading data whenever the valid bit was high, the FPGA was capturing incorrect grid values that occurred when the output bits from the Arduino were flipping. We altered both the Arduino and the FPGA code, to capture Arduino data only on the pos edge of the valid bit, thereby preventing our error.

We were able to successfully communicate information wirelessly from one Arduino to another, then display it on a screen using the FPGA. See the below video:
