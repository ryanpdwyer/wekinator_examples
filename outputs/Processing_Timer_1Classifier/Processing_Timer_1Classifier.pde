//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 12000 for message /wek/outputs (defaults)

// Edit the title and messages below to say what your classifier is and name each class
String titleMessage = "Title:";
String[] messages = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

import java.lang.*;


//No need to edit:
PFont myFont, myBigFont;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 0;
int classifier = 0;
int currentTextHue = 255;
String currentMessage = "";

long[] classTimes = new long[messages.length];
long previousTime = 0;
long currentTime = 0;
long currentClassTime = 0;

void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(RGB);
  size(450,400, P3D);
  smooth();
  background(255);
  
  String typeTag = "f";
  //myFont = loadFont("SansSerif-14.vlw");
  myFont = createFont("Arial", 16);
  myBigFont = createFont("Arial", 45);
  
  
}

void draw() {
  frameRate(30);
  background(255);
  drawText();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
        if (previousTime == 0) {
          previousTime = System.currentTimeMillis();
        }
        currentTime = System.currentTimeMillis();
      float f = theOscMessage.get(0).floatValue();
      println("received1");
       showMessage((int)f);
       previousTime = currentTime;
    }
    }
    
 
}

void showMessage(int i) {
    classifier = i;
    currentMessage = messages[i-1];
    classTimes[i-1] += currentTime - previousTime;
    currentClassTime = classTimes[i-1];
}

String msToTime(long time) {
  double seconds = time/1000.0;
  int minutes = (int)Math.floor(seconds/60.0);
  int secondsLeft = (int)Math.floor(seconds-minutes*60);
  return String.format("%02d", minutes) + ":" + String.format("%02d", secondsLeft);
}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(0);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
    textFont(myBigFont);
    text(titleMessage + " " + currentMessage, 30, 80);
    
    textFont(myFont);
    text("Class", 40, 150);
    text("Time", 150, 150);
    int lineWidth=21;
    for (int i = 0; i < messages.length; i++) {
        // text(textToDisplay, x_coordinate, y_coordinate)
        text(messages[i], 40, 150+(i+1)*lineWidth);
        text(msToTime(classTimes[i]), 150, 150+(i+1)*lineWidth);
    }
    
   
}
