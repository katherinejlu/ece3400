<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
# Milestone 1

The goal of this milestone was to implement line following and program our robot to drive in a figure eight.

## Hardware Modifications

We began by attaching the light sensors to the bottom of the robot. We used the line sensors provided, and began with three sensors. After seeing what other groups approached the problem with, we were uncertain of the viability of the three sensor design. However, having two sensors on either side of the line worked very well, because any time one went over the tape, we could immediately tell the robot was off course. In fact, we could likely remove the middle sensor and retain all functionality.

![](./resources/sensorposition.jpg)

We had some issues with getting consistent readings from the line sensors, so our first solution was to put the line sensors closer to the ground. We did this by switching out the wheels. This made our line readings significantly more consistent. The value of the middle sensor (reading the black tape) was typically over 900, while the outer sensors read between 100 and 300 on the white board.

We ran into significant hardware problems as we continued working on our project. When the robot was programmed to go straight, it would continuously veer to the left. This behavior suggests an improper servo calibration, but setting both servos to 90 resulted in no movement (so the servos must have been properly calibrated). We puzzled over this problem for several hours, switching out several servos and adjusting our code to unevenly power one servo more than the other. Probing the PWM signals at the Arduino output pins revealed that they were behaving as expected. Re-doing the wiring ended up fixing the problem. Likely, one signal connection was loose and sent an odd PWM signal to the servo.

![](./resources/veeringvideo.MOV)

## Software Implementation

