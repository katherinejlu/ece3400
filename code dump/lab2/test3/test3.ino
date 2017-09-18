#include <Servo.h>
int leftPin = A0; //connected to analog 0
int midPin = A1; //connected to analog 0
int rightPin = A2; //connected to analog 0
Servo servoL;
Servo servoR;

int line[2]; 
int count = 0; 

static int straightL = 180;
static int straightR = 83;

static int leftL = 180;
static int leftR = 86; //correction for left drift

static int rightL = 93;
static int rightR = 20;

boolean Go =true;
boolean hitAJunction = false; 
boolean passed = false; 
int leftWheel; 
int rightWheel; 

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
    Serial.print(line[0]);
    Serial.print("\t");
    Serial.print(line[1]);
    Serial.print("\t"); 
    Serial.print(line[2]);
    Serial.print("\t");
    Serial.print("Left wheel speed:");
    Serial.print(leftWheel);
    Serial.print("\t");
    Serial.print("Right wheel speed:");
    Serial.println(rightWheel);
    
    servoL.write(leftWheel);
    servoR.write(rightWheel);
    
    if (leftWheel == 45 | leftWheel == 130) {
      Serial.println("doing a delay");
      if (!(line[0]<600 && line[1]>600 && line[2]<600) | !passed) {
        if (line[1]<600) {
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
  

  
    if (line[2] - line[0]>=200) {
      Serial.println("Left of Line");
      leftWheel = leftL;
      rightWheel = leftR;
    }
    //right of line
    else if (line[0] - line[2]>=200) {
      Serial.println("Right of Line");
      leftWheel = rightL;
      rightWheel = rightR;
    }
    // junction
    else if ((abs(line[1] - line[2])<=200) && (abs(line[1] - line[0])<=200) && line[0] >400) {
      Serial.println("Junction");
      hitAJunction = true; 
   
    }
    else if (line[0]<400 && line[1]>400 && line[2]<400){
      Serial.println("Goin Straight yo");
      leftWheel = straightL;
      rightWheel = straightR;
      if (hitAJunction) {
        if ((count == 0) | (count > 4)) {
          leftWheel = 45;
          rightWheel = 21;
          if (count == 7){
            count = 0;
          }
        }
        if (count > 0 && count <5 ) {
          leftWheel = 130; 
          rightWheel = 115;
        }
      }
    }
    else {
      Serial.println("just keepin' on keepin' on");
    }
  }
}

