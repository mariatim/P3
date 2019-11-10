import processing.net.*; 
Client myClient;

String input;

PImage iceBG, transp;

ArrayList<Mackerel> m;
int mackerelFlockSize = 500;

ArrayList<Plankton> p;
int planktonFlockSize = 700;

ArrayList<Tuna> t;
int tunaFlockSize = 60;

ArrayList<Whale> w;
int whaleFlockSize = 9;

void setup() {
  size(1280, 640);
  //fullScreen();

  iceBG = loadImage("ice.jpg");
  iceBG.resize(width, height);
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.tint(255, 50);
  pg.image(iceBG, 0, 0);
  pg.endDraw();
  transp = pg.get();
  
  myClient = new Client(this, "127.0.0.1", 5001);

  m = new ArrayList<Mackerel>();
  for (int i = 0; i < mackerelFlockSize; i++) {
    m.add(new Mackerel());
  }

  p = new ArrayList<Plankton>();
  for (int i = 0; i < planktonFlockSize; i++) {
    p.add(new Plankton());
  }

  t = new ArrayList<Tuna>();
  for (int i = 0; i < tunaFlockSize; i++) {
    t.add(new Tuna());
  }

  w = new ArrayList<Whale>();
  for (int i = 0; i < whaleFlockSize; i++) {
    w.add(new Whale());
  }
}

void draw() {
  background(0, 0, 30);
  image(transp, 0, 0, width, height);
  
  if (myClient.available() > 0) {
    input = myClient.readString();
    println(input);
  }

  for (Plankton pl : p) {
    pl.edges();
    pl.update();
    pl.show();
  }

  for (Mackerel ma : m) {
    ma.edges();
    ma.update();
    ma.flock(m);
    ma.show();
  }

  for (Tuna tu : t) {
    tu.edges();
    tu.update();
    tu.flock(t);
    tu.show();
  }

  //for (Whale wh : w) {
  //  wh.edges();
  //  wh.update();
  //  wh.flock(w);
  //  wh.show();
  //}
  //println(frameRate);
}
