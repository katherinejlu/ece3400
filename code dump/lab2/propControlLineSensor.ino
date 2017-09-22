#include <Servo.h>
int leftPin = A0; //connected to analog 0
int midPin = A1; //connected to analog 0
int rightPin = A2; //connected to analog 0
Servo servoL;
Servo servoR;

int line[2]; 
int count = 0; 

int botpos = 0; //0 is on line, 
                //negative values left of line, 
                //positive values right of line.

int total = 1; 
int error = 0;
static int straightL = 180;
static int straightR = 83;

static int control = 55;

static int leftL = 180;
static int leftR = 86; //correction for left drift

static int rightL = 93;
static int rightR = 20;

static int LTurnL = 56; 
static int LTurnR = 56; 

static int RTurnL = 160; 
static int RTurnR = 150; 

boolean hitAJunction = false; 
boolean Go =true;
boolean passed = false; 
int leftWheel;
int rightWheel;
int newLeft;
int newRight; 


void setup() {
  Serial.begin(9600);
  pinMode(9, OUTPUT);
  pinMode(10,OUTPUT);
  servoL.attach(9);
  servoR.attach(10);

  leftWheel = straightL;
  rightWheel = straightR;

}

void loop() {
  while (Go) { 
    line[0] = analogRead(leftPin);
    line[1] = analogRead(midPin);
    line[2] = analogRead(rightPin);
    botpos = line[2] - line[0];
    total = line[1] + line[2] + line[0];
    error = botpos/total; 
    Serial.print(line[0]);
    Serial.print("\t");
    Serial.print(line[1]);
    Serial.print("\t"); 
    Serial.print(line[2]);
    Serial.print("\t");
    Serial.print("Bot postiion :");
    Serial.print(botpos);
    Serial.print("\t");
    Serial.print("ERROR:");
    Serial.println(error);
    
    servoL.write(leftWheel);
    servoR.write(rightWheel);
    
    if (leftWheel == LTurnL | leftWheel == RTurnL) {
      Serial.println("doing a delay");
      if (!(line[1]>600 && line[0] <500 && line[2] <500) | !passed) {
        if (line[1]<500) {
          passed = true; 
        }
        break;
      }
      passed = false; 
      hitAJunction = false; 
      count += 1;
      leftWheel = straightL;
      rightWheel = straightR;
  //     amISpinning = false;
  //     Serial.print("doing a delay");
  //     delay(500);
  //    while (line[1]<400){ 
  //      delay(15);
    }
  
//    if (line[2] - line[0]>=200) {
//      Serial.println("Left of Line");
//      leftWheel = leftL;
//      rightWheel = leftR;
//    }
//    //right of line
//    else if (line[0] - line[2]>=200) {
//      Serial.println("Right of Line");
//      leftWheel = rightL;
//      rightWheel = rightR;
//    }
    if (error < 0) {
      newLeft = straightL + control*error; 
      newRight = straightR + control*error;
      if (newLeft >180) {
        newLeft =180; 
      }
      if (newRight > 180) {
        newRight = 180;
      }
    }
    else if (error > 0) {
      newLeft = straightL - control*error;
      newRight = straightR - control*error;

      if (newLeft <0) {
        newLeft = 0;
      }
      if (newRight < 0) {
        newRight = 0;
      }
    }
    else {
      newLeft = straightL;
      newRight = straightR;
    }
    leftWheel = newLeft; 
    rightWheel = newRight;
    // junction
    if ((abs(line[1] - line[2])<=200) && (abs(line[1] - line[0])<=200) && line[0] >400) {
      Serial.println("Junction");
      hitAJunction = true; 
   
    }

      if (hitAJunction && !((abs(line[1] - line[2])<=200) && (abs(line[1] - line[0])<=200) && line[0] >400)) {
        if ((count == 0) | (count > 4)) {
          leftWheel = LTurnL;
          rightWheel = LTurnR;
          if (count == 7){
            count = 0;
          }
        }
        if (count > 0 && count <5 ) {
          leftWheel = RTurnL; 
          rightWheel = RTurnR;
        }
      }
    
    else {
      Serial.println("just keepin' on keepin' on");
    }
  }
}

