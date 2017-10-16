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
	 reg gridcolor[19:0][7:0];
	 reg visited [19:0]; 
//	 reg [7:0] reg1;
//	 reg [7:0] reg2;
//	 reg [7:0] reg3;
//	 reg [7:0] reg4;
//	 reg [7:0] reg5;
//	 reg [7:0] reg6;
//	 reg [7:0] reg7;
//	 reg [7:0] reg8;
//	 reg [7:0] reg9;
//	 reg [7:0] reg10;
//	 reg [7:0] reg11;
//	 reg [7:0] reg12;
//	 reg [7:0] reg13;
//	 reg [7:0] reg14;
//	 reg [7:0] reg15;
//	 reg [7:0] reg16;
//	 reg [7:0] reg17;
//	 reg [7:0] reg18;
//	 reg [7:0] reg19;
//	 reg [7:0] reg20;
	 
	 
	 GRID_SELECTOR gridSelector(
		.CLOCK_50(CLOCK_50),
		.PIXEL_COORD_X(PIXEL_COORD_X),
		.PIXEL_COORD_Y(PIXEL_COORD_Y),
		.GRID_X(GRID_X),
		.GRID_Y(GRID_Y),
	);
	
//	always @(*) begin
//		gridcolor[0]= 8'hF3C; 
//		gridcolor[1]= 8'b0;
//		gridcolor[2] =8'b11111111;
//		gridcolor[3] =8'b0;
//		gridcolor[4] = 8'b11111111;
//		gridcolor[5] = 8'b0;
//		gridcolor[6] = 8'b11111111;
//		gridcolor[7] = 8'b0;
//		gridcolor[8] = 8'b11111111;
//		gridcolor[9] = 8'b0;
//		gridcolor[10] = 8'b11111111;
//		gridcolor[11] = 8'b0;
//		gridcolor[12] = 8'b11111111;
//		gridcolor[13] = 8'b0;
//		gridcolor[14] = 8'b11111111;
//		gridcolor[15] = 8'b0;
//		gridcolor[16] = 8'b11111111;
//		gridcolor[17] = 8'b0;
//		gridcolor[18] = 8'b11111111;
//		gridcolor[19] = 8'b0;
//	end 

	reg[7:0] grid1[3:0] [4:0];
	
	always @(*) begin
		 grid1[0][0] = gridcolor[0];
		 grid1[0][1] = gridcolor[1];
		 grid1[0][2] = gridcolor[2];
		 grid1[0][3] = gridcolor[3];
		 grid1[0][4] = gridcolor[4];
		 grid1[1][0] = gridcolor[5];
		 grid1[1][1] = gridcolor[6];
		 grid1[1][2] = gridcolor[7];
		 grid1[1][3] = gridcolor[8];
		 grid1[1][4] = gridcolor[9];
		 grid1[2][0] = gridcolor[10];
		 grid1[2][1] = gridcolor[11];
		 grid1[2][2] = gridcolor[12];
		 grid1[2][3] = gridcolor[13];
		 grid1[2][4] = gridcolor[14];
		 grid1[3][0] = gridcolor[15];
		 grid1[3][1] = gridcolor[16];
		 grid1[3][2] = gridcolor[17];
		 grid1[3][3] = gridcolor[18];
		 grid1[3][4] = gridcolor[19];
		 for (i=0; i<20; i=i+1) begin
			if(visited[i]==1) begin 
				gridcolor[i]= 8'hF3C;
			end
			else begin 
				gridcolor[i]= 8'b11111111;
			end 
		 end
	end
	
	 
	always @(*) begin
		if (GRID_X > 3) begin
			PIXEL_COLOR = 8'b0;
		end
		else begin
			PIXEL_COLOR = grid1[GRID_X][GRID_Y];
		end
	end


//assign GPIO_0_D[31] = 1'd1;
//assign GPIO_0_D[33] = 1'd1;
	 
	 reg [24:0] led_counter; // timer to keep track of when to toggle LED
	 reg 			led_state;   // 1 is on, 0 is off
	 
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
	 

endmodule 