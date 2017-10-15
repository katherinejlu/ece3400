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
	 
	 //=======================================================
	 //  PORT declarations
	 //=======================================================

	 //////////// CLOCK //////////
	 input 		          		CLOCK_50;

	 //////////// LED //////////
	 output		     [7:0]		LED;
	 
	 //output 			  [7:0] q; //DAC


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
	 reg			 address; // sin table stuff

    wire [9:0]  PIXEL_COORD_X; // current x-coord from VGA driver
    wire [9:0]  PIXEL_COORD_Y; // current y-coord from VGA driver
    wire [7:0]  PIXEL_COLOR;   // input 8-bit pixel color for current coords
	 
	 reg [24:0] led_counter; // timer to keep track of when to toggle LED
	 reg [24:0] freq_counter;
	 reg 			led_state;   // 1 is on, 0 is off
	 
	 reg [2:0]	freq_state;
	 
	 reg [7:0] DAC; //DAC
	 
    // Module outputs coordinates of next pixel to be written onto screen
    VGA_DRIVER driver(
		  .RESET(reset),
        .CLOCK(CLOCK_25),
        .PIXEL_COLOR_IN(PIXEL_COLOR),
        .PIXEL_X(PIXEL_COORD_X),
        .PIXEL_Y(PIXEL_COORD_Y),
        .PIXEL_COLOR_OUT({GPIO_0_D[9],GPIO_0_D[11],GPIO_0_D[13],GPIO_0_D[15],GPIO_0_D[17],GPIO_0_D[19],GPIO_0_D[21],GPIO_0_D[23]}),
        .H_SYNC_NEG(GPIO_0_D[12]),
        .V_SYNC_NEG(GPIO_0_D[10])
    );
	 
	 sin_rom sin(
		.addr(DAC),
		.clk(CLOCK_25),
		.q({GPIO_1_D[8],GPIO_1_D[10],GPIO_1_D[12],GPIO_1_D[14],GPIO_1_D[16],GPIO_1_D[18],GPIO_1_D[20],GPIO_1_D[22]})
	 );
	 
	 assign reset = ~KEY[0]; // reset when KEY0 is pressed
	 
	 assign PIXEL_COLOR = 8'b000_111_00; // Green
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
		  end
		  
		  if (led_counter == ONE_SEC) begin
				led_state   <= ~led_state;
				led_counter <= 25'b0;
		  end
		  else begin	
				led_state   <= led_state;
				led_counter <= led_counter + 25'b1;
		  end // always @ (posedge CLOCK_25)
	 end
	 
	 always @ (posedge CLOCK_25) begin
		  if (reset) begin
				freq_state <= 2'b00;
				freq_counter <= 25'b0;
		  end
		  if (freq_counter == ONE_SEC) begin
				freq_counter <= 25'b0;
				freq_state <= freq_state + 2'b1;
				if (freq_state == 2'b11) begin
					freq_state <= 2'b00;
				end
		  end
		  else begin	
				freq_state <= freq_state;
				freq_counter <= freq_counter + 25'b1;
		  end // always @ (posedge CLOCK_25)
	 end
//	//localparam
//	localparam CLKDIVIDER_440 = 25000000 / 440 / 2;
//	
//	//sound variables
//	reg square_440;
//	assign GPIO_0_D[1] = square_440;
//	reg [15:0] counter;
//	
//	always @ (posedge CLOCK_25) begin
//		if (counter == 0) begin
//			counter <= CLKDIVIDER_440 - 1; //reset the clock
//			square_440 <= ~square_440; //toggle the square pulse
//		end
//		else begin
//			counter <= counter - 1;
//			square_440 <= square_440;
//		end
//	end

	localparam CLKDIVIDER_A_SIN = 25000000 / 400 / 256;
	localparam CLKDIVIDER_B_SIN = 25000000 / 800 / 256;
	localparam CLKDIVIDER_C_SIN = 25000000 / 600 / 256;
	reg [15:0] counter;
	
	
	always @ (posedge CLOCK_25) begin
		if (counter == 0) begin
			if (freq_state == 0) begin
				counter <= CLKDIVIDER_A_SIN - 1;
			end
			if (freq_state == 1) begin
				counter <= CLKDIVIDER_B_SIN - 1;
			end
			if (freq_state == 2) begin
				counter <= CLKDIVIDER_C_SIN - 1;
			end
			if (DAC >= 255) begin
				DAC <= 0;
			end
			else begin
				DAC <=  DAC + 1;
			end
		end
		else begin
			counter <= counter - 1;
		end
	end
	
	 
	endmodule
