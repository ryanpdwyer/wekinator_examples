import processing.sound.*;

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
import java.util.List;
import java.util.stream.*;
// Put the filenames of the songs to play here
List<String> fileNames = List.of("01-sit-down.mp3", "02-stand-by-me.mp3", "03-sit-down.mp3");
List<SoundFile> files;
int playing;


void setup() {
  size(640, 360);
  background(255);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  files = fileNames.stream().map( e -> new SoundFile(this, e))
          .collect(Collectors.toList());;
  playing = 0;
}      

void draw() {
  
}



//This is called automatically when OSC message is received
// use interface OscEventListener

  
void oscEvent(OscMessage theOscMessage) {
  println("Message received");
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
   //println("Correct Addr pattern");
     if(theOscMessage.checkTypetag("f")) { //Now looking for 1 parameter
       //println("Correct typetag");
       int p1 = -1;
        try {
          p1 = (int)theOscMessage.get(0).floatValue(); //get this parameter
        } catch (Exception e) {
          println("Raised exception");
          p1 = -2;
        }
        //println("Message received:");
        println(p1);
        println(playing);
        println(p1 != playing);
        if (p1 != playing && p1 > 0) {
          if (playing > 0) {
            println("Pausing the playing file");
            files.get(playing-1).pause();
          }
          println("Playing the requested file:");
          println(fileNames.get(p1-1));
          try {
            files.get(p1-1).play();
          println("Played!");
          playing = p1;
          } catch (Exception e) {
            println("Error occured");
          }
        }
     
      } else {
        println("Error: unexpected params type tag received by Processing");
      }
 }
}
