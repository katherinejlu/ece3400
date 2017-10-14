/* Returns a 3 bit array encoding where walls are located
 * 1 if wall, 0 if no wall
 * Wall: [Left, Center, Right]
 * Index:[ 0  ,   1   ,   2  ]
 */
int detectWalls() {
  int wallArray[3] = {0, 0, 0};
  
  for (int i = 0; i < 3; i ++) {
    wallArray[i] = isWall(wallPinArray[i]);
  }
  
}

/* Returns 1 if wall, 0 if no wall
 * Argument wallPin refers to specified distance sensor pin 
 * that is mapped to analog inputs in wallPinArray
 */
int isWall(int wallPin) {
  int distanceValue = analogRead(wallPin);
  if (distanceValue > 100) {
    return 1;
  }
  else return 0;
}

