//=======================================================
// ECE3400 Fall 2017
// Lab 3: Template top-level module
//
// Top-level skeleton from Terasic
// Modified by Claire Chen for ECE3400 Fall 2017
//=======================================================

`define ONE_SEC 25000000


module DE0_NANO(

	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	GPIO_0_D,
	GPIO_0_IN,

	//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
	GPIO_1_D,
	GPIO_1_IN,
);

	 //=======================================================
	 //  PARAMETER declarations
	 //=======================================================

	 localparam ONE_SEC = 25000000; // one second in 25MHz clock cycles
	 localparam white = 8'b11111111;
	 localparam black = 8'b0;
	 localparam pink = 8'b11110011;
	 localparam cyan = 8'b10011011;
	 
	 //=======================================================
	 //  PORT declarations
	 //=======================================================

	 //////////// CLOCK //////////
	 input 		          		CLOCK_50;

	 //////////// LED //////////
	 output		     [7:0]		LED;

	 /////////// KEY //////////
	 input 		     [1:0]		KEY; 

	 //////////// SW //////////
	 input 		     [3:0]		SW;

	 //////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	 inout 		    [33:0]		GPIO_0_D;
	 input 		     [1:0]		GPIO_0_IN;

	 //////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
	 inout 		    [33:0]		GPIO_1_D;
	 input 		     [1:0]		GPIO_1_IN;

    //=======================================================
    //  REG/WIRE declarations
    //=======================================================
    reg         CLOCK_25;
    wire        reset; // active high reset signal 

    wire [9:0]  PIXEL_COORD_X; // current x-coord from VGA driver
    wire [9:0]  PIXEL_COORD_Y; // current y-coord from VGA driver
    reg [7:0]  PIXEL_COLOR;   // input 8-bit pixel color for current coords
	 wire [2:0] GRID_X;
	 wire [2:0] GRID_Y;
	 reg grid [19:0][7:0];
	 reg visited [19:0]; 

	 
	 
	 GRID_SELECTOR gridSelector(
		.CLOCK_50(CLOCK_50),
		.PIXEL_COORD_X(PIXEL_COORD_X),
		.PIXEL_COORD_Y(PIXEL_COORD_Y),
		.GRID_X(GRID_X),
		.GRID_Y(GRID_Y)
	);
	

	reg[7:0] grid1[3:0] [4:0];
	reg[7:0] currentGrid;
	reg[24:0] counter;
	 
	//state machine 
	always @(posedge CLOCK_25) begin
		if (GRID_X > 3) begin
			PIXEL_COLOR <= black;
		end
		else begin
		currentGrid <= grid1[GRID_X][GRID_Y];
			if (currentGrid == unexplored) begin
				PIXEL_COLOR <= white;
			end
			if (currentGrid == explored) begin
				PIXEL_COLOR <= pink;
			end
			if (currentGrid == currPos) begin
				PIXEL_COLOR <= black;
			end
		end
	end
	
	reg[2:0] x;
	reg[2:0] y;
	
	//demo
//	always @(posedge CLOCK_25) begin
//		if (reset) begin
//				counter <= 25'b0;
//				x <= 3'b0;
//				y <= 3'b0;
//		 end
//		if (counter == ONE_SEC) begin
//			counter <= 25'b0;
//			x <= x + 3'b1;
//			y <= y + 3'b1;
//			
//			grid1[x][y] <= 8'b1;
//		end
//		
//		else begin
//			counter <= counter+ 25'b1;
//		end
//	end


//assign GPIO_0_D[31] = 1'd1;
//assign GPIO_0_D[33] = 1'd1;
	 
	 reg [24:0] led_counter; // timer to keep track of when to toggle LED
	 reg 			led_state;   // 1 is on, 0 is off
	 wire [1:0]	botX;
	 wire [2:0]	botY;
	 wire [1:0]	preX;
	 wire [2:0]	preY;
	 
    // Module outputs coordinates of next pixel to be written onto screen
    VGA_DRIVER driver(
		  .RESET(reset),
        .CLOCK(CLOCK_25),
        .PIXEL_COLOR_IN(PIXEL_COLOR),
        .PIXEL_X(PIXEL_COORD_X),
        .PIXEL_Y(PIXEL_COORD_Y),
        .PIXEL_COLOR_OUT({GPIO_0_D[9],GPIO_0_D[11],GPIO_0_D[13],GPIO_0_D[15],GPIO_0_D[17],GPIO_0_D[19],GPIO_0_D[21],GPIO_0_D[23]}),
        .H_SYNC_NEG(GPIO_0_D[7]),
        .V_SYNC_NEG(GPIO_0_D[5])
    );
	 
	 inputReader reader(
		.valid(GPIO_1_D[8]),
		.arduinoInput({GPIO_1_D[10],GPIO_1_D[12],GPIO_1_D[14],GPIO_1_D[16],GPIO_1_D[18]}),
		.robotX(botX),
		.robotY(botY),
		.preX(preX),
		.preY(preY)
	);
	 
	 
	 localparam explored = 8'd1;
	 localparam unexplored = 8'b0;
	 localparam currPos = 8'd2;
	 
	 assign reset = ~KEY[0]; // reset when KEY0 is pressed
	 
	// assign PIXEL_COLOR = 8'b000_111_00; // Green
	 assign LED[0] = led_state;
	 
    //=======================================================
    //  Structural coding
    //=======================================================
 
	 // Generate 25MHz clock for VGA, FPGA has 50 MHz clock
    always @ (posedge CLOCK_50) begin
        CLOCK_25 <= ~CLOCK_25; 
    end // always @ (posedge CLOCK_50)
	
	 // Simple state machine to toggle LED0 every one second
	 always @ (posedge CLOCK_25) begin
		  if (reset) begin
				led_state   <= 1'b0;
				led_counter <= 25'b0;
				x <= 3'b0;
				y <= 3'b0;
				grid1[0][0] = unexplored;
				grid1[0][1] = unexplored;
				grid1[0][2] = unexplored;
				grid1[0][3] = unexplored;
				grid1[0][4] = unexplored;
				grid1[1][0] = unexplored;
				grid1[1][1] = unexplored;
				grid1[1][2] = unexplored;
				grid1[1][3] = unexplored;
				grid1[1][4] = unexplored;
				grid1[2][0] = unexplored;
				grid1[2][1] = unexplored;
				grid1[2][2] = unexplored;
				grid1[2][3] = unexplored;
				grid1[2][4] = unexplored;
				grid1[3][0] = unexplored;
				grid1[3][1] = unexplored;
				grid1[3][2] = unexplored;
				grid1[3][3] = unexplored;
				grid1[3][4] = unexplored;
		  end
		  
		  else begin 
			grid1[preX][preY] = explored;
			grid1[botX][botY] = currPos;
		  end
//		  if (led_counter == ONE_SEC) begin
//				led_state   <= ~led_state;
//				led_counter <= 25'b0;
//				if (y==3'b100) begin // you're at the bottom of the grid
//					y<= 3'b0;
//					x<=x+3'b001;
//				end
//				else begin
//					y <= y + 3'b1;
//				end 
//				grid1[x][y] <= 8'b1;
//		  end
//		  else begin	
//				led_state   <= led_state;
//				led_counter <= led_counter + 25'b1;
//		  end // always @ (posedge CLOCK_25)
	 end
	 

endmodule 