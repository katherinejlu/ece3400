# Lab 2

##Optical Team -- IR Circuit

Materials used:
..*breadboard
..*wires
..*phototransistor
..*1.78 kΩ resistor
..*Arduino Uno
..*USB serial cable
..*oscilloscope

For this component of the lab, we constructed a circuit that is able to detect electromagnetic radiation of infrared (IR) frequncy. A photo transistor was used to modulate the circuit in response to a 7 kHz pulsating IR light. The phototransistor works via an embedded bipolar junction transistor, which is able to pass current in response to incident electromagnetic radiation. The changing current causes voltage to drop across the serial resistor. We measured the voltage at the terminal of the resistor with an oscilloscope. The amplitude of the voltage recorded was around 100 mV. This voltage was directly connected to an analog pin of the Arduino uno with a wire.

We then used the standard `fft` and `adc` library to process the voltage signal. Since the input voltage was pulsating at a relatively high frequency, we utilized the `adc` library to accurately read and store the time-dependent data. The Arduino has built-in hardware capable of processing the signal using the ADC (analog-to-digital) converter, which performs better than the regular 'analogRead' function for high frequency data.

The data was then transformed into the frequency-domain using the `fft` library. FFT--or Fast Fourier Transform--is a method used by computers to efficiently convert time-domain data into the frequency domain. We utilized the 'fft_adc_serial' script to output a serial stream of frequency data. The 'fft' takes advantage of the analog-to-digital converter. Each serial line output corresponds to the amplitude of the input signal at a frequency related to the relative index of the line output. Each index corresponds to an integer multiple of the sampling frequency, so integer *n* corresponds to frequency *f<sub>s</sub>n*, where *f<sub>s</sub>* is the sampling frequency. 