
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


