// This demo changes the pitch of the sound played and the screen color to match the class received
// Works with 1 classifier output, any number of classes
// Rebecca Fiebrink, 2016

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.Minim;
import ddf.minim.AudioPlayer;

Minim minim;
AudioPlayer[] notes = new AudioPlayer[12];
OscP5 oscP5;
NetAddress dest;

//No need to edit:
PFont myFont, myBigFont;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "Waiting...";

int previousClass = 0;

void setup() {
  // Pulling the display's density dynamically
  pixelDensity(displayDensity());
  size(400,400, P3D);
  colorMode(HSB);
  smooth();
  
  //Set up sound:
  minim = new Minim(this);
  for (int i = 0; i < notes.length; i++) {
    notes[i] = minim.loadFile("Data/" + i + ".wav");
  }
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  //Set up fonts
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 60);
}

void draw() {
  frameRate(30);
  background(currentHue, 255, 255);
  drawText();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      int f = (int)theOscMessage.get(0).floatValue();
      println("received " + f);
      showMessage(f);
      if (f != previousClass) {
        notes[f].rewind();
        notes[f].play();
        previousClass = f;
      }
  }
  
}

void showMessage(int i) {
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    currentMessage = Integer.toString(i);

}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
    textFont(myBigFont);
    text(currentMessage, 190, 180);
}


float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}
