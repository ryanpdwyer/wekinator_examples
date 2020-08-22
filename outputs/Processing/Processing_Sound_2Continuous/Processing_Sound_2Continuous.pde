import processing.sound.*;
SoundFile file;
HighPass highPass;

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

void setup() {
  size(640, 360);
  background(255);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
    
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "bensound-ukulele.mp3");
  highPass = new HighPass(this);   
  file.play();
  highPass.process(file, 1000);
}      

void draw() {
}



//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("ff")) { //Now looking for 2 parameters
        float p1 = theOscMessage.get(0).floatValue(); //get this parameter
        float p2 = theOscMessage.get(1).floatValue(); //get 2nd parameter
        
        file.amp(p1);
        
        highPass.freq(20+p2*5000);
        
        println("Received new params value from Wekinator");  
      } else {
        println("Error: unexpected params type tag received by Processing");
      }
 }
}
