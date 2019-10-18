class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int maxForce;
  int maxSpeed;
  float r;
  float g;
  float b;
  ArrayList<PVector> history;
  int trailSize;
  int lifespan;

  Boid() {
    this.position = new PVector(random(width), random(height));
    this.velocity = PVector.random2D();
    this.velocity.setMag(random(2, 4));
    this.acceleration = new PVector();
    this.maxForce = 1;
    this.maxSpeed = 5;
    r = random(0, 50);
    g = random(120, 160);
    b = random(150, 220);
    trailSize = 5;
    history = new ArrayList<PVector>();
  }

  void edges() {
    if (this.position.x > width) {
      this.position.x = 0;
      history.clear();
    } else if (this.position.x < 0) {
      this.position.x = width;
      history.clear();
    }
    if (this.position.y > height) {
      this.position.y = 0;
      history.clear();
    } else if (this.position.y < 0) {
      this.position.y = height;
      history.clear();
    }
  }

  PVector align(ArrayList<Boid> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        steering.add(other.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    return steering;
  }

  PVector separation(ArrayList<Boid> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        PVector diff = PVector.sub(this.position, other.position);
        diff.div(d * d);
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    return steering;
  }

  PVector cohesion(ArrayList<Boid> boids) {
    int perceptionRadius = 100;
    PVector steering = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        steering.add(other.position);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(this.position);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    return steering;
  }

  void flock(ArrayList<Boid> boids) {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohesion(boids);
    PVector separation = this.separation(boids);

    alignment.mult(alignValue);
    cohesion.mult(cohesionValue);
    separation.mult(seperationValue);

    this.acceleration.add(alignment);
    this.acceleration.add(cohesion);
    this.acceleration.add(separation);
  }

  void update() {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxSpeed);
    this.acceleration.mult(0);
    this.history.add(new PVector(this.position.x, this.position.y));
    if (this.history.size() > trailSize) {
      this.history.remove(0);
    }
  }

  void show() {
    //float avgVel = (this.velocity.x+this.velocity.y)/2;
    //avgVel = constrain(avgVel,-10,10);
    strokeWeight(8);
    stroke(r, g, b, 220);
    //println(alpha);
    point(this.position.x, this.position.y);
    
    noFill();
    beginShape();
    for (int i = 0; i < this.history.size(); i++) {
      PVector pos = this.history.get(i);
      strokeWeight(2);
      //point(pos.x,pos.y);
      vertex(pos.x,pos.y);
    }
    endShape();
  }
  
  void changeColor(){
    this.r = random(0,255);
    this.g = random(0,255);
    this.b = random(0,255);
  }
  
  void changeSpeed(int speed){
    this.maxSpeed = speed;
  }
}
