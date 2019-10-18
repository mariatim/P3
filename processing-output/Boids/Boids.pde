ArrayList<Boid> flock;
QuadTree quadtree;

float alignValue = .8;
float cohesionValue = .9;
float seperationValue = .9;

int flockSize = 1000;

void setup() {
  //size(1280, 720);
  fullScreen();

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
  quadtree = new QuadTree(boundary, 4);

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
    boid.flock(newBoids);
  }

  //quadtree.show();
  //println(frameRate);
}

void keyPressed() {
  if (key == '1') {
    for (Boid boid : flock) {
      boid.changeColor();
    }
  }

  if (key == '2') {
    int speed = 0;
    int num = int(random(1, 3));
    println(num);
    if (flock.get(1).maxSpeed == 5) {
      speed = 10;
    }
    if (flock.get(1).maxSpeed == 10) {
      speed = 20;
    }
    if (flock.get(1).maxSpeed == 20) {
      speed = 5;
    }
    println(speed);
    for (Boid boid : flock) {
      boid.changeSpeed(speed);
    }
  }

  if (key == '3') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.remove(i);
    }
  }
  if (key == '4') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.add(new Boid());
    }
  }
}
