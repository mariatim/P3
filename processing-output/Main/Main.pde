import processing.net.*; 
Client myClient;
//String input;
byte[] input;
Ecosystem e;

void setup() {
  //size(1280, 640);
  fullScreen(P2D);

  myClient = new Client(this, "127.0.0.1", 5001);

  e = new Ecosystem();
}

void draw() {
  e.bg();
  if (myClient.available() > 0) {
    //input = myClient.readString();
    input = myClient.readBytes();
    println(input);
  }
  e.display();
  //println(frameRate);

  if (input.length > 0) {
    switch(input[0]) {
    case '1':
      e.changeTemperature(1);
      break;
    case '2':
      e.changeTemperature(2);
      break;
    case '3':
      e.changeTemperature(3);
      break;
    case '4':
      e.changeTemperature(4);
      break;
    case '5':
      e.changeTemperature(5);
      break;
    case '6':
      e.changeTemperature(6);
      break;
    }

    switch(input[1]) {
    case '1':
      e.changePollution(1);
      break;
    case '2':
      e.changePollution(2);
      break;
    case '3':
      e.changePollution(3);
      break;
    case '4':
      e.changePollution(4);
      break;
    case '5':
      e.changePollution(5);
      break;
    case '6':
      e.changePollution(6);
      break;
    }

    switch(input[2]) {
    case '1':
      e.changeFishingRate(1);
      break;
    case '2':
      e.changeFishingRate(2);
      break;
    case '3':
      e.changeFishingRate(3);
      break;
    case '4':
      e.changeFishingRate(4);
      break;
    case '5':
      e.changeFishingRate(5);
      break;
    case '6':
      e.changeFishingRate(6);
      break;
    }
  }
}

/*
void keyPressed() {
 switch(key){
 case '1':
 e.changeTemperature(1);
 break;
 case '2':
 e.changeTemperature(2);
 break;
 case '3':
 e.changeTemperature(3);
 break;
 case '4':
 e.changeTemperature(4);
 break;
 case '5':
 e.changeTemperature(5);
 break;
 case '6':
 e.changeTemperature(6);
 break;
 }
 }
 */
/*
void keyPressed() {
 switch(key){
 case '1':
 e.changePollution(1);
 break;
 case '2':
 e.changePollution(2);
 break;
 case '3':
 e.changePollution(3);
 break;
 case '4':
 e.changePollution(4);
 break;
 case '5':
 e.changePollution(5);
 break;
 case '6':
 e.changePollution(6);
 break;
 }
 }
 */
/*
void keyPressed() {
 switch(key){
 case '1':
 e.changeFishingRate(1);
 break;
 case '2':
 e.changeFishingRate(2);
 break;
 case '3':
 e.changeFishingRate(3);
 break;
 case '4':
 e.changeFishingRate(4);
 break;
 case '5':
 e.changeFishingRate(5);
 break;
 case '6':
 e.changeFishingRate(6);
 break;
 }
 }
 */
