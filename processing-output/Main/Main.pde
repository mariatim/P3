import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;

import processing.net.*;
Client myClient;

String input, oldInput;
int[] inputInt = new int[3];
String[] inputSplit;
Ecosystem e;

void setup() {
  size(1360, 768);
  //fullScreen(P2D, 2);
  frameRate(24);
  applyColorScheme7();

  myClient = new Client(this, "127.0.0.1", 1234);

  minim = new Minim(this);
  player = minim.loadFile("ambience.mp3");
  player.loop();

  e = new Ecosystem();
}

void draw() {
  if (myClient.available() > 0) {
    oldInput = input;
    //input = myClient.readString();
    inputInt = int(split(input, ", "));
  }
  if (oldInput != input) {
    println(input);
  }
  e.display();
  //println(frameRate);
  
  if (inputInt.length > 0) {
   e.changeTemperature(inputInt[0]);   
   e.changePollution(inputInt[1]);   
   e.changeFishingRate(inputInt[2]);
  }
}


// keyboard interface for debuging

void keyPressed() {
  switch(key) {
  case '0':
    e.changeTemperature(0);
    e.changePollution(0);
    e.changeFishingRate(0);
    break;
  case '1':
    e.changeTemperature(1);
    e.changePollution(1);
    e.changeFishingRate(1);
    break;
  case '2':
    e.changeTemperature(2);
    e.changePollution(2);
    e.changeFishingRate(2);
    break;
  case '3':
    e.changeTemperature(3);
    e.changePollution(3);
    e.changeFishingRate(3);
    break;
  case '4':
    e.changeTemperature(4);
    e.changePollution(4);
    e.changeFishingRate(4);
    break;
  case '5':
    e.changeTemperature(5);
    e.changePollution(5);
    e.changeFishingRate(5);
    break;
  case '6':
    e.changeTemperature(6);
    e.changePollution(6);
    e.changeFishingRate(6);
    break;
  default:
    println(key);
  }
}
