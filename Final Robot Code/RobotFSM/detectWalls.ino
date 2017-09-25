/* Returns a 3 bit array encoding where walls are located
 * 1 if wall, 0 if no wall
 * Wall: [Left, Center, Right]
 * Index:[ 0  ,   1   ,   2  ]
 */
unsigned char[] detectWalls() {
  unsigned char[] wallArray;
  for (int i = 0; i < 4; i ++) {
    wallArray[i] = isWall(i);
  }
  
}

/* Returns 1 if wall, 0 if no wall
 * Argument wallDirection refers to direction of the wall
 * which will be mapped to analog inputs.
 */
char isWall(int wallDirection) {
  
}

