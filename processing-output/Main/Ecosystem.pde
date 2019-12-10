class Ecosystem {
  ArrayList<Mackerel> m;
  int mackerelFlockSize = 500;

  ArrayList<Plankton> p;
  int planktonFlockSize = 700;

  ArrayList<Tuna> t;
  int tunaFlockSize = 60;

  ArrayList<Whale> w;
  int whaleFlockSize = 9;

  private int MIN_TEMP_VALUE = 0;
  private int MAX_TEMP_VALUE = 6;

  private int temperatureLevel;

  private int MIN_DIE_VALUE = 0;
  private int MAX_DIE_VALUE = 6;

  private int fishingLevel;

  private int MIN_POL_VALUE = 0;
  private int MAX_POL_VALUE = 6;

  private int pollutionLevel;

  PlasticIsland plasticIsland;

  boolean islandAlive = false;

  int r = color_r;
  int g = color_g;
  int b = color_b;
  ArrayList<Hook> hooks;

  int numberOfHooks = 6;

  int bgR = r;
  int bgG = g;
  int bgB = b;

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

    fishingLevel = 0;

    temperatureLevel = 0;

    pollutionLevel = 0;

    plasticIsland = new PlasticIsland();

    hooks = new ArrayList<Hook>();
    for (int i = 0; i < numberOfHooks; i++) {
      hooks.add(new Hook());
    }
  }

  void display() {
    bg();
    showPlanktons();
    showMackerels();
    showTuna();
    showWhales();
    showIsland();
    showHooks();
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
      if (ma.isAlive()) {
        ma.edges();
        ma.avoidPollution(plasticIsland.pl);
        ma.avoidIsland();
        ma.avoidWhales(w);
        ma.avoidTuna(t);
        ma.getCaught(hooks);
        ma.update();
        ma.flock(m);
        ma.show();
      } else {
        ma.tryToRessurect();
      }
    }
  }

  void showTuna() {
    for (Tuna tu : t) {
      if (tu.isAlive()) {
        tu.edges();
        tu.avoidPollution(plasticIsland.pl);
        tu.avoidIsland();
        tu.avoidWhales(w);
        tu.getCaught(hooks);
        tu.update();
        tu.flock(t);
        tu.show();
      } else {
        tu.tryToRessurect();
      }
    }
  }

  void showWhales() {
    for (Whale wh : w) {
      wh.edges();
      wh.avoidPollution(plasticIsland.pl);
      wh.avoidIsland();
      wh.update();
      wh.flock(w);
      wh.show();
    }
  }

  void showHooks() {
    for (Hook h : hooks) {
      h.update();
      //h.seek(new PVector(mouseX, mouseY));
      h.catchFish();
      h.show();
    }
  }

  void showIsland() {
    plasticIsland.buildIsland();
    switch(pollutionLevel) {
    case 0:
      plasticIsland.addPlastic(0);
      plasticIsland.removePlastic(plasticIsland.maxSize);
      if (!islandAlive && plasticIsland.pl.get(0).alpha <= 0) {
        plasticIsland = new PlasticIsland();
        islandAlive = true;
      }
      break;
    case 1:
      plasticIsland.addPlastic(plasticIsland.maxSize*.1);
      plasticIsland.removePlastic(plasticIsland.maxSize*.9);
      break;
    case 2:
      plasticIsland.addPlastic(plasticIsland.maxSize*.22);
      plasticIsland.removePlastic(plasticIsland.maxSize*.78);
      break;
    case 3:
      plasticIsland.addPlastic(plasticIsland.maxSize*.44);
      plasticIsland.removePlastic(plasticIsland.maxSize*.56);
      break;
    case 4:
      plasticIsland.addPlastic(plasticIsland.maxSize*.56);
      plasticIsland.removePlastic(plasticIsland.maxSize*.44);
      break;
    case 5:
      plasticIsland.addPlastic(plasticIsland.maxSize*.78);
      plasticIsland.removePlastic(plasticIsland.maxSize*.22);
      break;
    case 6:
      plasticIsland.addPlastic(plasticIsland.maxSize);
      plasticIsland.removePlastic(0);
      break;
    }
  }

  void bg() {    
    if (bgR < r+(temperatureLevel*4)) {
      bgR++;
    } else if (bgR > r+(temperatureLevel*4)) {
      bgR--;
    }

    if (bgG < g+(temperatureLevel*(-2))) {
      bgG++;
    } else if (bgG > g+(temperatureLevel*(-2))) {
      bgG--;
    }

    if (bgB < b+(temperatureLevel*(-3))) {
      bgB++;
    } else if (bgB > b+(temperatureLevel*(-3))) {
      bgB--;
    }

    //println(bgR, bgG, bgB);
    background(bgR, bgG, bgB);
  }

  /**
   Method to change temperature:
   **/

  void changeTemperature(int newTemperature) {
    this.temperatureLevel = newTemperature;
    for (Mackerel ma : m) {
      ma.maxSpeed = ma.baseSpeed + newTemperature;
      switch(newTemperature) {
      case 0:
        ma.cohesionValue = .45;
        break;
      case 1:
        ma.cohesionValue = .5;
        break;
      case 2:
        ma.cohesionValue = .55;
        break;
      case 3:
        ma.cohesionValue = .6;
        break;
      case 4:
        ma.cohesionValue = .65;
        break;
      case 5:
        ma.cohesionValue = .7;
        break;
      case 6:
        ma.cohesionValue = .75;
        break;
      }
    }
    for (Tuna tu : t) {
      tu.maxSpeed = tu.baseSpeed + newTemperature;
      switch(newTemperature) {
      case 0:
        tu.cohesionValue = .2;
        break;
      case 1:
        tu.cohesionValue = .25;
        break;
      case 2:
        tu.cohesionValue = .3;
        break;
      case 3:
        tu.cohesionValue = .35;
        break;
      case 4:
        tu.cohesionValue = .4;
        break;
      case 5:
        tu.cohesionValue = .45;
        break;
      case 6:
        tu.cohesionValue = .5;
        break;
      }
    }
    for (Whale wh : w) {
      wh.maxSpeed = wh.baseSpeed + newTemperature;
    }
  }

  /**
   Method to change pollution:
   **/

  void changePollution(int newPollutionLevel) {
    if ((newPollutionLevel >= MIN_DIE_VALUE) && (newPollutionLevel <= MAX_DIE_VALUE) && (newPollutionLevel != pollutionLevel)) {
      this.pollutionLevel = newPollutionLevel;
      islandAlive = false;
    }
  }

  /**
   Methods for the fishing of tuna:
   **/

  public void changeFishingRate(int newFishingRate) {
    if ((newFishingRate >= MIN_DIE_VALUE) && (newFishingRate <= MAX_DIE_VALUE) && (newFishingRate != fishingLevel)) {
      fishingLevel = newFishingRate;
      fishTuna();
    }
  }

  private void fishTuna() {
    switch(fishingLevel) {
    case 0:
      for (Hook h : hooks) {
        h.active = false;
      }
      //if (hooks.get(0).alpha <= 0) {
      //  hooks.clear();
      //  println("cleared");
      //  for (int i = 0; i < numberOfHooks; i++) {
      //    hooks.add(new Hook());
      //  }
      //}
      break;
    case 1:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 0) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    case 2:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 1) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    case 3:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 2) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    case 4:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 3) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    case 5:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 4) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    case 6:
      for (Hook h : hooks) {
        if (hooks.indexOf(h) <= 5) {
          h.active = true;
        } else {
          h.active = false;
        }
      }
      break;
    }
  }
  /*
    if (fishingLevel==1) {
   // tuna you are free to live
   } else if (fishingLevel==2) {
   fishTuna(getNumberOfLiveTuna()/10);
   } else if (fishingLevel==3) {
   fishTuna(getNumberOfLiveTuna()/8);
   } else if (fishingLevel==4) {
   fishTuna(getNumberOfLiveTuna()/6);
   } else if (fishingLevel==5) {
   fishTuna(getNumberOfLiveTuna()/2);
   } else if (fishingLevel==6) {
   fishTuna(getNumberOfLiveTuna()-1);
   }
   */


  /*
  private void fishTuna(int numberOfTunaToFish) {
   
   if (numberOfTunaToFish >= getNumberOfLiveTuna()) {
   numberOfTunaToFish = getNumberOfLiveTuna();
   }
   
   while (numberOfTunaToFish > 0) {
   if (getIndexForFirstAliveTuna() == -1) {
   break;
   }
   t.get(getIndexForFirstAliveTuna()).kill();
   numberOfTunaToFish--;
   }
   }
   
   public int getNumberOfLiveTuna() {
   int sum = 0;
   for (int i = 0; i < t.size(); i++) {
   if (t.get(i).isAlive()) {
   sum++;
   }
   }
   return sum;
   }
   
   private int getIndexForFirstAliveTuna() {
   for (int i = 0; i < t.size(); i++) {
   if (t.get(i).isAlive()) {
   return i;
   }
   }
   return -1;
   }
   */
}
