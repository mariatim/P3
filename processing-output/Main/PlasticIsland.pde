class PlasticIsland {
  ArrayList<Plastic> pl;
  float maxSize;

  PlasticIsland() {
    pl = new ArrayList<Plastic>();
    maxSize = 4000;
    pl.add(new Plastic(new PVector(random(width/6, width-width/6), random(height/6, height-height/6))));
    for (int i = 0; i <= maxSize-2; i++) {
      PVector p = (pl.get(pl.size() - 1).position.copy());
      p.x += random(-10, 10);
      p.y += random(-10, 10);
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
    if (frameCount % 5 == 0) {
      for (int i = pl.size()-1; i >= pl.size()-newSize; i--) {
        pl.get(i).isAlive = false;
      }
    }
  }


  void buildIsland() {
    for (Plastic p : pl) {
      p.drift();
      p.show();
    }
  }
}
