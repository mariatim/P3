import processing.net.*; 
Client myClient;
String input;
Ecosystem e;

void setup() {
  size(1280, 640);
  //fullScreen();

  myClient = new Client(this, "127.0.0.1", 5001);

  e = new Ecosystem();
}

void draw() {
  e.bg();

  if (myClient.available() > 0) {
    input = myClient.readString();
    println(input);
    //e.changeTemperature(input[somewhere]);
  }
  
  e.display();
}

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
