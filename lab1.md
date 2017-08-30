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


