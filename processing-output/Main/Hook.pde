class Hook {
  PVector startingPosition;
  PVector currentPosition;
  PVector velocity;
  PVector acceleration;
  PVector direction;

  float maxSpeed;
  float maxForce;

  int radius;
  boolean active;

  color c;
  int alpha;

  float angle;

  PVector goal;

  Hook() {
    this.reset();
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    radius = 35;
    active = false;
    c = color_plastic;
    maxSpeed = 5;
    maxForce = 0.1;
  }

  void reset() {
    startingPosition = new PVector(width/2, height-20);
    goal = new PVector(random(width/6, 5*width/6), random(height/5, 4*height/5));
    currentPosition = startingPosition.copy();
    alpha = 255;
  }

  void show() {
    float theta = velocity.heading() + PI/2;
    stroke(c);
    strokeWeight(2);
    noFill();
    pushMatrix();
    translate(this.currentPosition.x, this.currentPosition.y);
    rotate(theta);
    arc(-20, 30, 30, 140, PI, TWO_PI, OPEN);
    arc(-20, 30, 30, -10, PI, TWO_PI, OPEN);
    ellipse(-20, 10, 8, 8);
    ellipse(-20, -10, 4, 4);
    //ellipse(-20, 0, radius*2, radius*2);
    popMatrix();
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, this.currentPosition);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    currentPosition.add(velocity);
    acceleration.mult(0);
  }

  void catchFish() {
    if (this.active) {
      this.seek(goal);
    }
    if (!this.active) {
      this.seek(startingPosition);
    }
    if ((dist(this.goal.x, this.goal.y, currentPosition.x, currentPosition.y) <= 10)) {
      goal = new PVector(random(width/6, 5*width/6), random(height/5, 4*height/5));
    }
  }
}
