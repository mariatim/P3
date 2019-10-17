Boid[] flock;
QuadTree quadtree;

float alignValue = .5;
float cohesionValue = .8;
float seperationValue = 1;

void setup() {
  //size(1280, 720);
  fullScreen();
  
  Rectangle boundary = new Rectangle(width/2, height/2, width/2, height/2);
  int numberOfBoids = 4;
  quadtree = new QuadTree(boundary, numberOfBoids);
  int n = 1000;
  flock = new Boid[n];
  for (int i = 0; i < n; i++) {
    flock[i] = new Boid();
  }
}

void draw() {
  background(51, 0);
  quadtree.empty();
  stroke(0, 255, 0);
  rectMode(CENTER);
  Rectangle range = new Rectangle(mouseX, mouseY, 25, 25);
  rect(range.x, range.y, range.w * 2, range.h * 2);
  ArrayList<Boid> particles = new ArrayList<Boid>();
  particles = quadtree.query(quadtree.boundary, particles);
  
  for (Boid boid: flock) {
    quadtree.insert(boid);
    boid.edges();
    boid.flock(flock);
    boid.update();
    boid.show();
  }
  quadtree.show();
  println(frameRate);
}
