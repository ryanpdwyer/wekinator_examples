//This demo allows wekinator to control background color (hue)
//This is a continuous value between 0 and 1

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import controlP5.*;
ControlP5 cp5;
OscP5 oscP5;
NetAddress dest;

//Parameters of sketch
float myHue;
float mySat;
float value = 200;
PFont myFont;

void setup() {
  // Pulling the display's density dynamically
  pixelDensity(displayDensity());
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  cp5 = new ControlP5(this);

  cp5.addSlider("value")
        .setPosition(260, 350)
        .setRange(0, 255)
        .setColorCaptionLabel(0);
  
  colorMode(HSB);
  size(400, 400, P3D);
  smooth();
  background(255);

  //Initialize appearance
  myHue = 255;
  sendOscNames();
  myFont = createFont("Arial", 14);
}

void draw() {
  background(myHue, mySat, value);
  drawtext();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("ff")) { // looking for 1 control value
        float receivedHue = theOscMessage.get(0).floatValue();
        float receivedSat = theOscMessage.get(1).floatValue();
        myHue = map(receivedHue, 0, 1, 0, 255);
        mySat = map(receivedSat, 0, 1, 0, 255);
     } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
}

//Sends current parameter (hue) to Wekinator
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("hue"); //Now send all 5 names
  oscP5.send(msg, dest);
}

//Write instructions to screen.
void drawtext() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(0, 0, 255);
    text("Receiving 2 continuous parameters:\nhue, saturation in range 0-1", 10, 10);
    text("Listening for /wek/outputs on port 12000", 10, 60);
}
