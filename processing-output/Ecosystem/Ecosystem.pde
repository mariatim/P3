ArrayList<Mackerel> m;
int mackerelFlockSize = 400;

ArrayList<Plankton> p;
int planktonFlockSize = 600;

ArrayList<Tuna> t;
int tunaFlockSize = 50;

ArrayList<Whale> w;
int whaleFlockSize = 9;

void setup() {
  //size(1280, 640);
  fullScreen();

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

  for (Whale wh : w) {
    wh.edges();
    wh.update();
    wh.flock(w);
    wh.show();
  }
  println(frameRate);
}
