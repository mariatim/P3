ArrayList<Boid> flock;
QuadTree quadtree;

float alignValue = .8;
float cohesionValue = .9;
float seperationValue = .9;

int flockSize = 500;

void setup() {
  //size(1280, 720);
  fullScreen();
  colorMode(HSB, 360, 100, 100);

  flock = new ArrayList<Boid>();
  for (int i = 0; i < flockSize; i++) {
    flock.add(new Boid());
  }
}

void draw() {
  background(51, 0);

  stroke(0, 255, 0);
  rectMode(CENTER);

  Rectangle boundary = new Rectangle(width/2, height/2, width, height);
  quadtree = new QuadTree(boundary, 8);

  for (Boid b : flock) {
    quadtree.insert(b);
    b.edges();
    b.update();
    //b.flock(flock);
    b.show();
  }

  for (Boid boid : flock) {
    Rectangle range = new Rectangle(boid.position.x, boid.position.y, 50, 50);
    ArrayList<Boid> newBoids = new ArrayList<Boid>();
    newBoids = quadtree.query(range, newBoids);
    //println(newBoids.size());

    boid.flock(newBoids);
  }

  //quadtree.show();
  println(frameRate);
}

void keyPressed() {
  if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
    for (Boid boid : flock) {
      boid.changeColor();
    }
  }

  if (key == 'q' || key == 'w' || key == 'e' || key == 'r' || key == 't' || key == 'z') {
    
    if (key == 'q') {
      changeFlockSize(200);
    }
    if (key == 'w') {
      changeFlockSize(300);
    }
    if (key == 'e') {
      changeFlockSize(400);
    }
    if (key == 'r') {
      changeFlockSize(600);
    }
    if (key == 't') {
      changeFlockSize(800);
    }
    if (key == 'z') {
      changeFlockSize(1000);
    }
    for (Boid boid : flock) {
      boid.changeSpeed();
    }
  }


  //  if (key == '9') {
  //    int speed = 0;
  //    //println(num);
  //    if (flock.get(1).maxSpeed == 5) {
  //      speed = 12;
  //    }
  //    if (flock.get(1).maxSpeed == 12) {
  //      speed = 18;
  //    }
  //    if (flock.get(1).maxSpeed == 18) {
  //      speed = 8;
  //    }
  //    if (flock.get(1).maxSpeed == 8) {
  //      speed = 15;
  //    }
  //    if (flock.get(1).maxSpeed == 15) {
  //      speed = 10;
  //    }
  //    if (flock.get(1).maxSpeed == 10) {
  //      speed = 5;
  //    }
  //    println(speed);
  //    for (Boid boid : flock) {
  //      boid.changeSpeed();
  //    }
  //  }

  if (key == '7') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.remove(i);
      flock.get(i).maxSpeed -= 1;
    }
  }

  if (key == '8') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.add(new Boid());
      flock.get(i).maxSpeed += 1;
    }
  }

  if (key == '6') {
  }
}

void changeFlockSize(int x) {
  println(flock.size());
  int missingSize = x - flock.size();
  
  println(missingSize);
  if (missingSize > 0) {
    for (int i =0; i< missingSize; i++) {
      flock.add(new Boid());
    }
  }
  if (missingSize < 0) {
    println(abs(missingSize));
    for (int i =0; i< abs(missingSize); i++) {
      flock.remove(0);
    }
  }
}
