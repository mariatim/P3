import processing.net.*; 
Client myClient;
String input;
Ecosystem e;

void setup() {
  //size(1280, 640);
  fullScreen(P2D);

  myClient = new Client(this, "127.0.0.1", 5001);

  e = new Ecosystem();
}

void draw() {
  background(0, 0, 30);

  if (myClient.available() > 0) {
    input = myClient.readString();
    println(input);
  }

  e.display();
  println(frameRate);
}
