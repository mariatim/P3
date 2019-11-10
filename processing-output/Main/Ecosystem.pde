class Ecosystem {
  ArrayList<Mackerel> m;
  int mackerelFlockSize = 500;

  ArrayList<Plankton> p;
  int planktonFlockSize = 700;

  ArrayList<Tuna> t;
  int tunaFlockSize = 60;

  ArrayList<Whale> w;
  int whaleFlockSize = 9;
  
  private int MIN_DIE_VALUE = 1;
  private int MAX_DIE_VALUE = 6;
  
  private int fishingLevel;

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
  }
  
  void display(){
    showPlanktons();
    showMackerels();
    showTuna();
    showWhales();
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
      ma.update();
      ma.flock(m);
      ma.show();
    }
  }

  void showTuna() {
    for (Tuna tu : t) {
      tu.edges();
      tu.update();
      tu.flock(t);
      tu.show();
    }
  }

  void showWhales() {
    for (Whale wh : w) {
      wh.edges();
      wh.update();
      wh.flock(w);
      wh.show();
    }
  }
  
  public void changeFishingRate(int newFishingRate){
    if ((newFishingRate >= MIN_DIE_VALUE) && (newFishingRate <= MAX_DIE_VALUE) && (newFishingRate != fishingLevel)){
      fishingLevel = newFishingRate;
      fishTuna();
    }
  }
  
  private void fishTuna(){
    if (fishingLevel==1){
      // tuna you are free to live
    }else if(fishingLevel==2){
      fishTuna(t.size()/10);
    }else if(fishingLevel==3){
      fishTuna(t.size()/8);
    }else if(fishingLevel==4){
      fishTuna(t.size()/6);
    }else if(fishingLevel==5){
      fishTuna(t.size()/4);
    }else if(fishingLevel==6){
      fishTuna(t.size()/2);
    }
  }
  
  private void fishTuna(int numberOfTunaToFish){
    for (int i = 0; i < numberOfTunaToFish; i++){
      if (t.size() != 0){
        t.remove(0);
      }
    }
  }
  
}
