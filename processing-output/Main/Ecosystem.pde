class Ecosystem {
  ArrayList<Mackerel> m;
  int mackerelFlockSize = 500;

  ArrayList<Plankton> p;
  int planktonFlockSize = 700;

  ArrayList<Tuna> t;
  int tunaFlockSize = 60;

  ArrayList<Whale> w;
  int whaleFlockSize = 9;

  private int MIN_TEMP_VALUE = 1;
  private int MAX_TEMP_VALUE = 6;

  private int temperatureLevel;

  private int MIN_DIE_VALUE = 1;
  private int MAX_DIE_VALUE = 6;

  private int fishingLevel;

  private int MIN_POL_VALUE = 1;
  private int MAX_POL_VALUE = 6;

  private int pollutionLevel;

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

    fishingLevel = 1;

    temperatureLevel = 1;

    pollutionLevel = 1;

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
      if (tu.isAlive()) {
        tu.edges();
        tu.avoidPollution(plasticIsland.pl);
        tu.avoidWhales(w);
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
      wh.update();
      wh.flock(w);
      wh.show();
    }
  }

  void showIsland() {
    plasticIsland.buildIsland();
    switch(pollutionLevel) {
    case 1:
      plasticIsland.addPlastic(0);
      plasticIsland.removePlastic(plasticIsland.maxSize);
      break;
    case 2:
      plasticIsland.addPlastic(plasticIsland.maxSize*.2);
      plasticIsland.removePlastic(plasticIsland.maxSize*.8);
      break;
    case 3:
      plasticIsland.addPlastic(plasticIsland.maxSize*.4);
      plasticIsland.removePlastic(plasticIsland.maxSize*.6);
      break;
    case 4:
      plasticIsland.addPlastic(plasticIsland.maxSize*.6);
      plasticIsland.removePlastic(plasticIsland.maxSize*.4);
      break;
    case 5:
      plasticIsland.addPlastic(plasticIsland.maxSize*.8);
      plasticIsland.removePlastic(plasticIsland.maxSize*.2);
      break;
    case 6:
      plasticIsland.addPlastic(plasticIsland.maxSize);
      plasticIsland.removePlastic(0);
      break;
    }
  }

  void bg() {
    background(7 + 6*(temperatureLevel-1), 20 - 2*(temperatureLevel-1), 35 - 6*(temperatureLevel-1));
  }
  
  /**
   Method to change temperature:
   **/

  void changeTemperature(int newTemperature) {
    this.temperatureLevel = newTemperature;
    for (Mackerel ma : m) {
      ma.maxSpeed = ma.baseSpeed + newTemperature - 1;
      ma.cohesionValue = newTemperature == 1 ? ma.cohesionBase : ma.cohesionBase/newTemperature*0.2;
    }
    for (Tuna tu : t) {
      tu.maxSpeed = tu.baseSpeed + newTemperature - 1;
      tu.cohesionValue = tu.cohesionBase/newTemperature*0.2;
    }
    for (Whale wh : w) {
      wh.maxSpeed = wh.baseSpeed + newTemperature - 1;
      wh.cohesionValue = wh.cohesionBase/newTemperature*0.2;
    }
  }
  
  /**
   Method to change pollution:
   **/

  void changePollution(int newPollutionLevel) {
    if ((newPollutionLevel >= MIN_DIE_VALUE) && (newPollutionLevel <= MAX_DIE_VALUE) && (newPollutionLevel != pollutionLevel)) {
      this.pollutionLevel = newPollutionLevel;
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
  }

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
}
