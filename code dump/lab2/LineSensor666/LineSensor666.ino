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
int leftSpeed=135;
int track = 0; 
int rightSpeed=45; //assume right servo is in backwards orientation 

/*for sensor ranges:
 * on black: >800
 * on white: <300
 */

static int black; static int white;

void setup() {
  Serial.begin(9600);
  servoL.attach(9);
  servoR.attach(10);
  line[0] = analogRead(leftPin);
  line[1] = analogRead(midPin);
  line[2] = analogRead(rightPin);
  black = line[1];
//static int threshold = (2*line[1] - (line[0] + line[2]))/2; //average difference between white and black lineues
  white = (line[0]+line[2])/2 +100; //high end white lineue

}

void loop() {
  servoL.write(leftSpeed);
  servoR.write(rightSpeed);
  line[0] = analogRead(leftPin);
  line[1] = analogRead(midPin);
  line[2] = analogRead(rightPin);
  Serial.print(line[0]);
  Serial.print("\t");
  Serial.print(line[1]);
  Serial.print("\t"); 
  Serial.print(line[2]);
  Serial.print("\t");
  Serial.print("Left wheel speed:");
  Serial.print(leftSpeed);
  Serial.print("\t");
  Serial.print("Right wheel speed:");
  Serial.println(rightSpeed);
  if(line[2]>400){
    rightSpeed = 45;
    Serial.println("LEFT");
    leftSpeed = 180 ;
  }
  else if(line[0]>400){
    leftSpeed =135;
    rightSpeed = 0;
    Serial.println("RIGHT");
  }
  else if (line[0]<400 && line[2]<400){
    Serial.println("STRAIGHT");
    leftSpeed = 135;
    rightSpeed = 45;
  }
}

  void figureEight(){ 
    servoL.write(90);
    servoR.write(90);
    while (~(abs(line[1] - line[2])>=200) && (abs(line[1] - line[0])>=200)) {
        if (track<=3) {
          servoL.write(45); //reverse is below 90 for left wheel
          servoR.write(45); 
        }
        else if (track == 4){
          servoL.write(180);
          servoR.write(0); //this is probably straight
        }
        else {
          servoL.write(135);
          servoR.write(135); //reverse >90
       }
    }
    leftSpeed = 135; 
    rightSpeed = 45;
  }
  


