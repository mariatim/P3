class Plankton {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float nx, ny;
  float r;
  color c;
  
  Plankton() {
    this.position = new PVector(random(width), random(height));
    this.velocity = new PVector();
    this.acceleration = new PVector();
    nx = 0;
    ny = 10000;
    r = random(1, 5);
    float dist = dist(this.position.x, this.position.y, width/2, height/2);
    int s = int(map(dist, 0, width/2, 0, 4));
    //int s = int(random(4));
    switch (s) {
    case 0:
      c = color_plankton1;
      break;
    case 1:
      c = color_plankton2;
      break;
    case 2:
      c = color_plankton3;
      break;
    case 3:
      c = color_plankton4;
      break;
    }
  }

  void edges() {
    if (this.position.x > width) {
      this.position.x = 0;
    } else if (this.position.x < 0) {
      this.position.x = width;
    }
    if (this.position.y > height) {
      this.position.y = 0;
    } else if (this.position.y < 0) {
      this.position.y = height;
    }
  }

  void update() {
    PVector dir = PVector.random2D();
    dir.normalize();
    dir.mult(.01);
    this.acceleration = dir;
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  void show() {
    noStroke();
    fill(c);
    ellipse(this.position.x, this.position.y, r, r);
  }
}
