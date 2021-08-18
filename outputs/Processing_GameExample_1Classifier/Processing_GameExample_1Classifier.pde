/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/17115*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Modified by Rebecca Fiebrink to work with Wekinator */
/* Modified by Ryan Dwyer */
// Set up so that class 1 = goLeft(), class 2 = goRight(), class 3 = jump()
// If you have things set up differently, change 

// Change to false if you want to allow multiple moves without changing classes.
boolean oneMoveMax = true;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

final int WIDTH = 30;
final int HEIGHT = 23;
int[][] level = new int[HEIGHT][WIDTH];

int rightCount = 0;
int leftCount = 0;

int previousClass = 0;


Player p1;

//booleans for key presses to get a simple yes or no press and 
//to not have to worry about the a,aaaaaaaaaaaaa thing
boolean right = false, left = false, up = false;

void setup() {
  // Pulling the display's density dynamically
  pixelDensity(displayDensity());
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  size(480,368);
  p1 = new Player(WIDTH*8,HEIGHT*8); //put the player in the middle of the window
}
void draw() {
  p1.update();
  
  background(200);
  drawLevel();
  p1.show();
  
  if (rightCount > 0) {
     rightCount--;
    if (rightCount == 0)  {
       right = false;
    }
  }
  
  if (leftCount > 0) {
     leftCount--;
    if (leftCount == 0)  {
       left = false;
    }
  }
  up = false;
  
  drawText();
}

void drawLevel() {
  fill(0);
  noStroke();
  for ( int ix = 0; ix < WIDTH; ix++ ) {
    for ( int iy = 0; iy < HEIGHT; iy++ ) {
      switch(level[iy][ix]) {
        case 1: rect(ix*16,iy*16,16,16);
      }
    }
  }
}

boolean place_free(int xx,int yy) {
//checks if a given point (xx,yy) is free (no block at that point) or not
  yy = int(floor(yy/16.0));
  xx = int(floor(xx/16.0));
  if ( xx > -1 && xx < level[0].length && yy > -1 && yy < level.length ) {
    if ( level[yy][xx] == 0 ) {
      return true;
    }
  }
  return false;
}

void keyPressed() {
  switch(keyCode) {
    case RIGHT: right = true; break;
    case LEFT: left = true; break;
    case UP: up = true; break;
  }
}
void keyReleased() {
  switch(keyCode) {
    case RIGHT: right = false; break;
    case LEFT: left = false; break;
    case UP: up = false; break;
  }
}

void mousePressed() {
//Left click creates/destroys a block
  if ( mouseButton == LEFT ) {
    level[int(floor(mouseY/16.0))][int(floor(mouseX/16.0))] ^= 1;
  }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      int f = (int)theOscMessage.get(0).floatValue();
        if (f != previousClass) {
          switch (f) {
            case 1:
              goLeft();
              break;
            case 2:
              goRight();
              break;
            case 3:
              jump();
              break;
          }
        }
        if (oneMoveMax) {
          previousClass = f;
        }
   }
  }
}

void drawText() {
  text( "Receives 1 classifier output from Wekinator", 5, 15 );
  text( "Receives on port 12000", 5, 30 ); 
}

private void goLeft() {
   left = true;
   leftCount = 10;
}

private void goRight() {
   right = true;
   rightCount = 10;
}

private void jump() {
  up = true;
}
