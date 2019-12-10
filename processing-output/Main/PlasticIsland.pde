class PlasticIsland {
  ArrayList<Plastic> pl;
  float maxSize;

  PlasticIsland() {
    pl = new ArrayList<Plastic>();
    maxSize = 4000;
    //pl.add(new Plastic(new PVector(random(9*width/20, 11*width/20), random(6*height/8, 7*height/8))));
    pl.add(new Plastic(new PVector(2.9*width/4+5, height-30)));
    for (int i = 0; i <= maxSize-2; i++) {
      PVector p = (pl.get(pl.size() - 1).position.copy());
      p.x += random(-10, 9.8);
      p.y += random(-6, 5.65);
      pl.add(new Plastic(p));
    }
  }

  void addPlastic(float newSize) {
    if (frameCount % 5 == 0) {
      for (int i = 0; i <= newSize-1; i++) {
        pl.get(i).isAlive = true;
      }
    }
  }

  void removePlastic(float newSize) {
    if (frameCount % 2 == 0) {
      for (int i = pl.size()-1; i >= pl.size()-newSize; i--) {
        pl.get(i).isAlive = false;
      }
    }
  }

  void buildIsland() {
    for (Plastic p : pl) {
      //p.drift();
      //p.stick(pl);
      p.show();
    }
  }
}
