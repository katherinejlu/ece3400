# Lab 1

## Part 1: Modying the Blink Sketch

For this part of the lab, we made simple modifications to the preexisting code in order to work for an external LED. We declared a global variable `pin` in order to specify the external pin we wish to have blink. 

## Part 2: Outputing Analog Voltages

For the second phase of the lab, we took advantage of the `analogRead` method in order to use the analog voltage values that were being controlled by the potentiometer. Here's our code:

```
int sensorPin = A0;
int voltageValue = 0;
int delayTime = 500;

void setup() {
  Serial.begin(9600);
}

void loop() {
  voltageValue = analogRead(sensorPin);
  Serial.println(voltageValue);
  delay(delayTime);
}
```

Here's a photo of the circuit:
![](./resources/6d352b7943044248b06bf93e79163291.jpeg)

## Analog LED Output

The third phase of this lab is very similar to the previous part. We used the `analogWrite` function in order to write analog PWM voltages to the LED. We mapped the input voltage to the output voltage written to the LED using the following mapping scheme. The maximum value (unknown units) for the voltage we were getting was 1023; the minimum value was 6. The maximum allowed input for analogWrite is 255, so we essentially made the analog output vary linearly between 0 and 255 for all allowed analog inputs from the potentiometer. For reference, the code has been included below:

```
int sensorPin = A0;
int outputPin = 11;
float voltageValue = 0;


void setup() {
  pinMode(outputPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  voltageValue = analogRead(sensorPin);
  analogWrite(outputPin, 255 * (voltageValue-6)/1017);
  Serial.println(voltageValue);
  //Frequency of PWM is 490.2 Hz
}
```

Here's a photo of the circuit: 
![](./resources/a3c3be304c904540ab26eccacc50d2ea.jpeg)



