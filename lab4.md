[Home](./homepage.md) 

# Lab 4

## Radio Team

### Overview of how wireless communication works/introduction/materials used
Radhika

### Sending full maze coordinates and maze updates with wireless communication
Katherine

### Sending information from base station to FPGA 
Evan


For the final part of the lab, we had to create a system for sending maze information from the Arduino base station to the FPGA. Since the robot was not yet operational, and we had already demonstrated that we can communicate wirelessly between the Arduinos, we generated test robot coordinate data to simulate the robot traversing the maze. Since we were able to demonstrate communication between the Arduinos, and from the Arduino to the base station, it will be relatively straightforward to link all of these devices together. Note that we did not demonstrate the communication of treasure and wall data from the Arduino to the FPGA. We have established a preliminary protocol for transmitting this data, but have not yet demonstrated this in practice. 

Here is the Arduino code we wrote for this component of the lab (each part will be explained)

```
int delayTime = 500; //ms;
int setupTime = 50; //ms;
String inputSignals[32] = {
                        "00000", "01000", "10000", "11000",
                        "00001", "01001","10001", "11001",
                        "00010",  "01010", "10010", "11010",
                        "00011", "01011", "10011", "11011",
                        "00100", "01100", "10100", "11100",
                        "00101", "01101","10101", "11101", 
                        "00110", "01110", "10110", "11110",
                        "00111", "01111", "10111", "11111",
                        };

                        
void generateClock(){
  
}

                        
void setup() {
  Serial.begin(9600);
  pinMode(7,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(4,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(2,OUTPUT);

}

void loop() {
  
  for (int i = 0; i<32; i++){
    String signalWord = inputSignals[i];
    sendWord(signalWord);
    delay(delayTime);   
  }
}


void sendWord(String signalWord){
  digitalWrite(2, LOW);
  delay(setupTime);
  writeWord(signalWord);
  delay(setupTime);
  digitalWrite(2, HIGH);
}

void writeWord(String signalWord){
  for (int i = 0; i<5; i++){
    if (signalWord.charAt(i) == '0'){
      digitalWrite(7-i, LOW);
    }
    else{
      digitalWrite(7-i, HIGH);
    }
  }
}
```

As discussed, the maze coordinate are encoded in a 5 bit word. In the Arduino code, we hard coded all 32  maze coordinates that the robot could possibly reach. This can be seen when we instantiate the `inputSignals` array. 

Since the FPGA reads this word on the rising edge of a clock, we had to create a psuedo-clock 1-bit signal in Arduino that is sychronized to change when we are ready to read the data. This is done in the `sendWord` method. Pin 2 corresponds to our "clock". We write a `LOW` value to the clock pin, and then wait `setupTime` amount of milliseconds before proceeding to actually write the coordinates to pins 7-3. We wait `setupTime` milliseconds before flipping the clock to a `HIGH` signal. Our thinking was that there is some propagation delay in the circuit. 50 milliseconds is plenty of time for the signal to set up, and for the FPGA to sample the correct value. If we didn't clock our signal, then we would run into issues sampling the signal when it is transitioning between values. 

The `writeWord` method is relatively straightforwards. It simply iterates through the word string, and then writes the values to the appropriate pin. 

The output pins corresponding to the coordinate data and clock were connected to voltage divider in order to be sent to the FPGA (to be discussed in next section).



## FPGA Team

### Overview/introduction of FPGA and how its being used for this lab

### How the FPGA code was primarily changed for this lab

### Explaination of the FPGA working with the Arduino, the challenges we faced, the resistor array, pins, etc.

