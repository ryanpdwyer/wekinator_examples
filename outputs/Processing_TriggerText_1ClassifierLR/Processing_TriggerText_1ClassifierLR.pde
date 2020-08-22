//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 12000 for message /wek/outputs (defaults)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;


//No need to edit:
PFont myFont, myBigFont;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 0;
int classifier = 0;
int currentTextHue = 255;
String currentMessage = "";
String[] messages = {"Right", "Left", "3", "4", "5", "6" };

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
  myFont = createFont("Arial", 14);
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
      float f = theOscMessage.get(0).floatValue();
      println("received1");
       showMessage((int)f);
      }
    }
 
}

void showMessage(int i) {
    classifier = i;
    currentMessage = messages[i-1];
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
    //text("Pirate Detector:", 30, 100);
    if (classifier == 1) {
      fill(139, 0, 0);
    }
    text(currentMessage, 30, 180);
}
