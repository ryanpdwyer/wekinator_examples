// This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
// Listens on port 12000 for message /wek/outputs (defaults)

// Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

// Import the Processing Sound library
import processing.sound.*;

// No need to edit:
PFont myFont, myBigFont;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 0;
int classifier = 0;
int currentTextHue = 255;
String currentMessage = "";
String[] messages = {"Danger! Pirate!", "Whew, not a pirate", "3", "4", "5", "6" };

// Declare a sine oscillator
SinOsc sineOsc;

// Variables to track the time
boolean playTone = false;
int toneStartTime = 0;
int toneDuration = 500; // 0.5 seconds in milliseconds

void setup() {
  // Initialize OSC communication
  oscP5 = new OscP5(this, 12000); // listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); // send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(RGB);
  size(450, 400, P3D);
  smooth();
  background(255);
  
  String typeTag = "f";
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 45);
  
  // Initialize the sine oscillator
  sineOsc = new SinOsc(this);
  sineOsc.freq(440); // Initial frequency (A4)
  sineOsc.amp(0);    // Initial amplitude (off)
}

void draw() {
  frameRate(30);
  background(255);
  drawText();
  
  // Check if it's time to stop playing the tone
  if (playTone && millis() - toneStartTime >= toneDuration) {
    sineOsc.amp(0); // Turn off the sine oscillator
    playTone = false;
  }
}

// This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
      showMessage((int)f);
    }
  }
}

void showMessage(int i) {
  if (i == 1 && classifier != 1) {
    playTone = true;
    toneStartTime = millis();
  }
  
  classifier = i;
  currentMessage = messages[i - 1];
}

// Write instructions to the screen
void drawText() {
  stroke(0);
  textFont(myFont);
  textAlign(LEFT, TOP); 
  fill(0);

  text("Receives 1 classifier output message from wekinator", 10, 10);
  text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
  
  textFont(myBigFont);
  text("Pirate Detector:", 30, 100);
  if (classifier == 1) {
    fill(139, 0, 0);
  }
  text(currentMessage, 30, 180);
}
