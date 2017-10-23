module inputReader(
valid,
arduinoInput,
robotX,
robotY,
preX,
preY);

input valid;
input [4:0] arduinoInput;
output reg [1:0] robotX;
output reg [2:0] robotY;

output reg [1:0] preX;
output reg [2:0] preY;

always @ (posedge valid) begin
	preX = robotX;
	preY = robotY;
	robotX = arduinoInput[4:3];
	robotY = arduinoInput[2:0];
end

endmodule