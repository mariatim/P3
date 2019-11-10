class Ecosystem {
  ArrayList<Mackerel> m;
  int mackerelFlockSize = 500;

  ArrayList<Plankton> p;
  int planktonFlockSize = 700;

  ArrayList<Tuna> t;
  int tunaFlockSize = 60;

  ArrayList<Whale> w;
  int whaleFlockSize = 9;

  PlasticIsland plasticIsland;

  Ecosystem() {
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

    plasticIsland = new PlasticIsland();
  }

  void display() {
    showPlanktons();
    showMackerels();
    showTuna();
    showWhales();
    showIsland();
  }

  void showPlanktons() {
    for (Plankton pl : p) {
      pl.edges();
      pl.update();
      pl.show();
    }
  }

  void showMackerels() {
    for (Mackerel ma : m) {
      ma.edges();
      ma.avoidPollution(plasticIsland.pl);
      ma.avoidWhales(w);
      ma.avoidTuna(t);
      ma.update();
      ma.flock(m);
      ma.show();
    }
  }

  void showTuna() {
    for (Tuna tu : t) {
      tu.edges();
      tu.avoidPollution(plasticIsland.pl);
      tu.avoidWhales(w);
      tu.update();
      tu.flock(t);
      tu.show();
    }
  }

  void showWhales() {
    for (Whale wh : w) {
      wh.edges();
      wh.avoidPollution(plasticIsland.pl);
      wh.update();
      wh.flock(w);
      wh.show();
    }
  }

  void showIsland() {
    plasticIsland.addPlastic();
    plasticIsland.buildIsland();
  }
}
