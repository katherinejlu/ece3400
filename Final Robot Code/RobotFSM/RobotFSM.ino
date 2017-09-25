/* State machine for all robot functions
 */
enum State {
  START, JUNCTION, BETWEEN, DONE
};

enum Direction {
  UP, DOWN, LEFT, RIGHT, UND
};

//Definitions
//for Fourier Transform
#define LOG_OUT 1 // use the log output function
#define FFT_N 256 // set to 256 point fft

//Libraries
#include <FFT.h> // include the FFT library

//Global Variables
State state; //initializes state enum variable
Direction dir; //initializes direction enum variable

void setup() {
  //Initializes the robot into START state
  state = START;

  //setup for 660 Hz detect
  Serial.begin(9600); // use the serial port
  //pinMode(13, OUTPUT); //sets pin 13 (built in LED) as an output
  TIMSK0 = 0; // turn off timer0 for lower jitter
  ADCSRA = 0xe7; // set the adc to free running mode, changed prescalar to 128
  ADMUX = 0x40; // use adc0: analog A0
  DIDR0 = 0x01; // turn off the digital input for adc0
}

void loop() {
  
  // Stays in START state until goSignal returns TRUE
  // The robot will then enter JUNCTION state
  if (state == START) {
    if (startSignal()) {
      state = JUNCTION;
    }
    Serial.println("START");
  }

  //JUNCTION state: detects walls and treasures, chooses next direction to move
  if (state == JUNCTION) {
    Serial.println("JUNCTION");

    
  }
}


