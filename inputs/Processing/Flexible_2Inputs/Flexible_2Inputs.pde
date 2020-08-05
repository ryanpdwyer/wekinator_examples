/**
* REALLY simple processing sketch that sends mouse x and y position of box to wekinator
* This sends 2 input values to port 6448 using message /wek/inputs
* Adapated from https://processing.org/examples/mousefunctions.html by Rebecca Fiebrink
**/

import oscP5.*;
import netP5.*;
import controlP5.*;

ControlP5 cp5;
DropdownList d1;


int patchSize = 110;
int dropDownInt = 1;


OscP5 oscP5;
NetAddress dest;
PFont f;
PImage img;

float bx;
float by;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0;




void setup() {
  f = createFont("Courier", 15);
  textFont(f);

  img = loadImage("512px-Emojione_263A.png");
  size(650, 550, P2D);
  noStroke();
  smooth();

  cp5 = new ControlP5(this);

  cp5.addSlider("patchSize")
        .setPosition(500, 460)
        .setRange(1, 150)
        .setColorCaptionLabel(0);
  d1 = cp5.addDropdownList("dropDownInt")
            .setPosition(500, 480)
            .addItem("Circle", 0)
            .addItem("Square", 1)
            .addItem("Triangle", 2);

  // customize(d1);
  
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1",6448);

  
}

void drawShape(float x, float y, int size) {
  fill(117, 47, 138);
  stroke(117, 47, 138);
  switch (dropDownInt) {
    case 0:
      circle(x, y, size);
      break;
    case 1:
      square(x, y, size/2);
      break;
    case 2: 
      triangle(x, y, x+size, y, x+size/2, y+size*sqrt(3)/2);
      break;
    default:
      break;
  }
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    dropDownInt = (int)theEvent.getGroup().getValue();
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    if (theEvent.getController().getName() == "dropDownInt") {
      dropDownInt = (int)theEvent.getController().getValue();
    } else {
      patchSize = (int)theEvent.getController().getValue();
    }
  }
}
// void customize(DropdownList ddl) {
//   // a convenience function to customize a DropdownList
//   ddl.setBackgroundColor(color(190));
//   ddl.setItemHeight(20);
//   ddl.setBarHeight(15);
//   ddl.valueLabel().style().marginTop = 3;
//   for (int i=0;i<40;i++) {
//     ddl.addItem("item "+i, i);
//   }
//   //ddl.scroll(0);
//   ddl.setColorBackground(color(60));
//   ddl.setColorActive(color(255, 128));
// }


void drawEyePatch(float x, float y, int size) {
  fill(117, 47, 138);
  stroke(117, 47, 138);
  ellipse(x, y, size, size);
}

void draw() {
  background(255);
  fill(0);
  image(img, 50, 30);

  text("Continuously sends box x and y position (2 inputs) to Wekinator\nUsing message /wek/inputs, to port 6448", 10, 30);
  text("x=" + bx + ", y=" + by, 10, 80);
  

  // Test if the cursor is over the box 
  if (mouseX > bx-patchSize && mouseX < bx+patchSize && 
      mouseY > by-patchSize && mouseY < by+patchSize) {
    overBox = true;  
  } else {
    overBox = false;
  }
  
  // Draw the box
  drawShape(bx, by, patchSize);
  
  //Send the OSC message with box current position
  sendOsc();
}

void mousePressed() {
  if(overBox) { 
    locked = true; 
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by; 

}

void mouseDragged() {
  if(locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 
  }
}

void mouseReleased() {
  locked = false;
}


void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)bx); 
  msg.add((float)by);
  oscP5.send(msg, dest);
}
