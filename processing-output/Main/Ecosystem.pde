class Ecosystem {
  ArrayList<Tuna> t;
  int mackerelFlockSize = 500;

  ArrayList<Plankton> p;
  int planktonFlockSize = 700;

  ArrayList<Shark> s;
  int sharkFlockSize = 60;

  ArrayList<Whale> w;
  int whaleFlockSize = 9;

  int MIN_DIE_VALUE = 0;
  int MAX_DIE_VALUE = 6;

  int temperatureLevel;

  int fishingLevel;

  int pollutionLevel;

  PollutionIsland pollutionIsland;

  boolean islandAlive = false;

  int r = color_r;
  int g = color_g;
  int b = color_b;

  int bgR = r;
  int bgG = g;
  int bgB = b;

  ArrayList<Boat> boats;

  int numberOfBoats = 6;


  Ecosystem() {
    t = new ArrayList<Tuna>();
    for (int i = 0; i < mackerelFlockSize; i++) {
      t.add(new Tuna());
    }

    p = new ArrayList<Plankton>();
    for (int i = 0; i < planktonFlockSize; i++) {
      p.add(new Plankton());
    }

    s = new ArrayList<Shark>();
    for (int i = 0; i < sharkFlockSize; i++) {
      s.add(new Shark());
    }

    w = new ArrayList<Whale>();
    for (int i = 0; i < whaleFlockSize; i++) {
      w.add(new Whale());
    }

    fishingLevel = 0;

    temperatureLevel = 0;

    pollutionLevel = 0;

    pollutionIsland = new PollutionIsland();

    boats = new ArrayList<Boat>();
    for (int i = 0; i < numberOfBoats; i++) {
      boats.add(new Boat());
    }
  }

  void display() {
    bg();
    showPlanktons();
    showMackerels();
    showShark();
    showWhales();
    showIsland();
    showBoats();
  }

  void showPlanktons() {
    for (Plankton pl : p) {
      pl.edges();
      pl.update();
      pl.show();
    }
  }

  void showMackerels() {
    for (Tuna tu : t) {
      if (tu.isAlive()) {
        tu.edges();
        tu.avoidPollution(pollutionIsland.pl);
        tu.avoidIsland();
        tu.avoidWhales(w);
        tu.avoidShark(s);
        tu.getCaught(boats);
        tu.update();
        tu.flock(t);
        tu.show();
      } else {
        tu.tryToRessurect();
      }
    }
  }

  void showShark() {
    for (Shark sh : s) {
      if (sh.isAlive()) {
        sh.edges();
        sh.avoidPollution(pollutionIsland.pl);
        sh.avoidIsland();
        sh.avoidWhales(w);
        sh.getCaught(boats);
        sh.update();
        sh.flock(s);
        sh.show();
      } else {
        sh.tryToRessurect();
      }
    }
  }

  void showWhales() {
    for (Whale wh : w) {
      wh.edges();
      wh.avoidPollution(pollutionIsland.pl);
      wh.avoidIsland();
      wh.update();
      wh.flock(w);
      wh.show();
    }
  }

  void showBoats() {
    for (Boat b : boats) {
      b.update();
      b.catchFish();
      b.show();
    }
  }

  void showIsland() {
    pollutionIsland.buildIsland();
    switch(pollutionLevel) {
    case 0:
      pollutionIsland.addPollution(0);
      pollutionIsland.removePollution(pollutionIsland.maxSize);
      if (!islandAlive && pollutionIsland.pl.get(0).alpha <= 0) {
        pollutionIsland = new PollutionIsland();
        islandAlive = true;
      }
      break;
    case 1:
      pollutionIsland.addPollution(pollutionIsland.maxSize*.1);
      pollutionIsland.removePollution(pollutionIsland.maxSize*.9);
      break;
    case 2:
      pollutionIsland.addPollution(pollutionIsland.maxSize*.22);
      pollutionIsland.removePollution(pollutionIsland.maxSize*.78);
      break;
    case 3:
      pollutionIsland.addPollution(pollutionIsland.maxSize*.44);
      pollutionIsland.removePollution(pollutionIsland.maxSize*.56);
      break;
    case 4:
      pollutionIsland.addPollution(pollutionIsland.maxSize*.56);
      pollutionIsland.removePollution(pollutionIsland.maxSize*.44);
      break;
    case 5:
      pollutionIsland.addPollution(pollutionIsland.maxSize*.78);
      pollutionIsland.removePollution(pollutionIsland.maxSize*.22);
      break;
    case 6:
      pollutionIsland.addPollution(pollutionIsland.maxSize);
      pollutionIsland.removePollution(0);
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
    background(bgR, bgG, bgB);
  }

  /**
   Method to change temperature:
   **/

  void changeTemperature(int newTemperature) {
    this.temperatureLevel = newTemperature;
    for (Tuna tu : t) {
      tu.maxSpeed = tu.baseSpeed + newTemperature;
      switch(newTemperature) {
      case 0:
        tu.cohesionValue = .45;
        break;
      case 1:
        tu.cohesionValue = .5;
        break;
      case 2:
        tu.cohesionValue = .55;
        break;
      case 3:
        tu.cohesionValue = .6;
        break;
      case 4:
        tu.cohesionValue = .65;
        break;
      case 5:
        tu.cohesionValue = .7;
        break;
      case 6:
        tu.cohesionValue = .75;
        break;
      }
    }
    for (Shark sh : s) {
      sh.maxSpeed = sh.baseSpeed + newTemperature;
      switch(newTemperature) {
      case 0:
        sh.cohesionValue = .2;
        break;
      case 1:
        sh.cohesionValue = .25;
        break;
      case 2:
        sh.cohesionValue = .3;
        break;
      case 3:
        sh.cohesionValue = .35;
        break;
      case 4:
        sh.cohesionValue = .4;
        break;
      case 5:
        sh.cohesionValue = .45;
        break;
      case 6:
        sh.cohesionValue = .5;
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
   Methods for the fishing of shark:
   **/

  void changeFishingRate(int newFishingRate) {
    if ((newFishingRate >= MIN_DIE_VALUE) && (newFishingRate <= MAX_DIE_VALUE) && (newFishingRate != fishingLevel)) {
      fishingLevel = newFishingRate;
      fish();
    }
  }

  void fish() {
    switch(fishingLevel) {
    case 0:
      for (Boat b : boats) {
        b.active = false;
      }
      break;
    case 1:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 0) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    case 2:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 1) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    case 3:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 2) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    case 4:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 3) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    case 5:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 4) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    case 6:
      for (Boat b : boats) {
        if (boats.indexOf(b) <= 5) {
          b.active = true;
        } else {
          b.active = false;
        }
      }
      break;
    }
  }
}
