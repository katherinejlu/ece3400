//Code for the QRE1113 Analog board
//Outputs via the serial terminal – Lower numbers mean more reflected
#include <Servo.h>
int leftPin = A0; //connected to analog 0
int midPin = A1; //connected to analog 0
int rightPin = A2; //connected to analog 0
Servo servoL;
Servo servoR;
int line[2]; //array to maintain line location betwee n3 sensors
/*
 * line[0] = left sensro
 * line[1] = middle sensor
 * line[2] = right sensor
 */
int leftSpeed=110;
int rightSpeed=70; //assume right servo is in backwards orientation 

/*for sensor ranges:
 * on black: >800
 * on white: <300
 */

void setup() {
  Serial.begin(9600);
  servoL.attach(9);
  servoR.attach(11);
}

void loop() {

  servoL.write(leftSpeed);
  servoR.write(rightSpeed);

}
