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
      if (tu.isAlive()){
        tu.edges();
        tu.update();
        tu.flock(t);
        tu.show();
      }
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
  
  /**
  Methods for the fishing of tuna:
  **/
  
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
      fishTuna(getNumberOfLiveTuna()/10);
    }else if(fishingLevel==3){
      fishTuna(getNumberOfLiveTuna()/8);
    }else if(fishingLevel==4){
      fishTuna(getNumberOfLiveTuna()/6);
    }else if(fishingLevel==5){
      fishTuna(getNumberOfLiveTuna()/2);
    }else if(fishingLevel==6){
      fishTuna(getNumberOfLiveTuna()-1);
    }
  }
  
  private void fishTuna(int numberOfTunaToFish){
    
    if (numberOfTunaToFish >= getNumberOfLiveTuna()){
        numberOfTunaToFish = getNumberOfLiveTuna();
    }
    
    while(numberOfTunaToFish > 0){
      if(getIndexForFirstAliveTuna() == -1){
        break;
      }
      t.get(getIndexForFirstAliveTuna()).kill();
      numberOfTunaToFish--;
    }
    
  }
  
  public int getNumberOfLiveTuna(){
  int sum = 0;
  for (int i = 0; i < t.size(); i++){
    if (t.get(i).isAlive()){
      sum++;
    }
  }
  return sum;
  }
  
  private int getIndexForFirstAliveTuna(){
      for(int i = 0; i < t.size(); i++){
        if (t.get(i).isAlive()){
          return i;
        } 
      }
      return -1;
  }
  
}
