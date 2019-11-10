class PlasticIsland {
  ArrayList<Plastic> pl;

  PlasticIsland() {
    pl = new ArrayList<Plastic>();
    pl.add(new Plastic(new PVector(random(width/6,width-width/6), random(height/6, height-height/6))));
  }

  void addPlastic(int maxSize) {
    if (frameCount % 5 == 0) {
      if (pl.size() > 0 && pl.size() < maxSize) {
        PVector p = (pl.get(pl.size() - 1).position.copy());
        p.x += random(-10, 10);
        p.y += random(-10, 10);
        pl.add(new Plastic(p));
      }
    }
  }

  void buildIsland() {
    for (Plastic p : pl) {
      p.show();
    }
  }
}
