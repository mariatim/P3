import processing.net.*; 
Client myClient;

String input;

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
    if (tu.visible == true)
      tu.show();
    
    for (Whale wh : w){
      if (tu.position.dist(wh.position) <= 20 && wh.hunger > 80){
        tu.visible = false;
        wh.hunger = 0;
      }
    }
  }

  for (Whale wh : w) {
    wh.edges();
    
    if (wh.dying == true) {
      wh.die();
    } else {
      wh.update();
    }
      
    //wh.flock(w);
    if (wh.visible == true)
      wh.show();
  }
}
