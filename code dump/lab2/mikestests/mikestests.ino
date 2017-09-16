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
int rightSpeed=45; //assume right servo is in backwards orientation 

/*for sensor ranges:
 * on black: >800
 * on white: <300
 */

static int black; static int white;

void setup() {
  Serial.begin(9600);
  servoL.attach(9);
  servoR.attach(11);
  line[0] = analogRead(leftPin);
  line[1] = analogRead(midPin);
  line[2] = analogRead(rightPin);
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
  Serial.println(line[2]);
  goStraight();

  if(isJunction()) {  //for now, robot just stops when it reaches a juncition.
    Serial.println("at Junction");
    leftSpeed =90;
    rightSpeed =90;
  }
//  delay(1000);
}


boolean goStraight(){
  if(isLeft()){
    Serial.println("is Left of line");
    leftSpeed =leftSpeed+2;
  }
  else if(isRight()){
    rightSpeed = rightSpeed+2;
    Serial.println("is Right of line");
  }
  else if((abs(line[1] - line[2])>=200) && (abs(line[1] - line[0])>=200)){
    //line[1] - line[0] >= threshold && line[1]-line[2] >= threshold){
    Serial.println("is straight");
    leftSpeed = 135;
    rightSpeed = 45;
  }
}

boolean isRight(){
    return(line[0] - line[2]>=200);
 // return(line[0]>white && line[2]<=white);
//  return(line[0]- line[2] >= threshold);
}

boolean isLeft(){
  return(line[2] - line[0]>=200);
 // return(line[2]>white && line[2]<=white);
//return(line[2] - line[0] >= threshold);
}

boolean isJunction(){
  return ((abs(line[1] - line[2])<=200) && (abs(line[1] - line[0])<=200)); 
  //return (line[0]>white && line[1] >white && line[2]>white);
  //return (abs(line[0] - line[1]) <= threshold  && abs(line[1] - line[2]) <= threshold );
}

//void turnLeft(
