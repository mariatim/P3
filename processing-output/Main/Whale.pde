class Whale {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int maxForce;
  float maxSpeed, baseSpeed;

  ArrayList<PVector> history;
  int trailSize;

  float alignValue = .8;
  float cohesionValue = .1;
  float cohesionBase = .1;
  float seperationValue = .45;

  color c;

  Whale() {
    this.position = new PVector(random(width), random(height));
    this.velocity = PVector.random2D();
    this.velocity.setMag(random(1, 2));
    this.acceleration = new PVector();
    this.maxForce = 2;
    this.maxSpeed = 4;
    this.baseSpeed = 4;
    history = new ArrayList<PVector>();
    trailSize = 18;
    c = color(246, 134, 104);
  }

  void edges() {
    int perceptionRadius = 35;
    PVector steering = new PVector();

    if (this.position.x < perceptionRadius) {
      PVector desired = new PVector(maxSpeed, this.velocity.y);
      steering = PVector.sub(desired, this.velocity);
      steering.limit(maxForce);
      this.applyForce(steering);
    } else if (this.position.x > width - perceptionRadius) {
      PVector desired = new PVector(-maxSpeed, this.velocity.y);
      steering = PVector.sub(desired, this.velocity);
      steering.limit(maxForce);
      this.applyForce(steering);
    }
    if (this.position.y < perceptionRadius) {
      PVector desired = new PVector(maxSpeed, this.velocity.x);
      steering = PVector.sub(desired, this.velocity);
      steering.limit(maxForce);
      this.applyForce(steering);
    } else if (this.position.y > height - perceptionRadius) {
      PVector desired = new PVector(-maxSpeed, this.velocity.x);
      steering = PVector.sub(desired, this.velocity);
      steering.limit(maxForce);
      this.applyForce(steering);
    }
  }

  void avoidPollution(ArrayList<Plastic> pl) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Plastic other : pl) {
      if (other.isAlive) {
        float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
        if (d < perceptionRadius) {
          PVector diff = PVector.sub(this.position, other.position);
          diff.div(d * d);
          steering.add(diff);
          total++;
        }
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    this.applyForce(steering);
  }

  void avoidIsland() {
    int perceptionRadius = 350;
    PVector steering = new PVector();
    int total = 0;
    PVector island = new PVector(width/2, height+50);
    float d = dist(this.position.x, this.position.y, island.x, island.y);
    if (d < perceptionRadius) {
      PVector diff = PVector.sub(this.position, island);
      diff.div(d * d);
      steering.add(diff);
      total++;
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    this.applyForce(steering);
  }

  PVector align(ArrayList<Whale> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Whale other : boids) {
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

  PVector separation(ArrayList<Whale> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Whale other : boids) {
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

  PVector cohesion(ArrayList<Whale> boids) {
    int perceptionRadius = 100;
    PVector steering = new PVector();
    int total = 0;
    for (Whale other : boids) {
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

  void flock(ArrayList<Whale> boids) {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohesion(boids);
    PVector separation = this.separation(boids);
    //PVector avoidEdge = this.edges();

    alignment.mult(alignValue);
    cohesion.mult(cohesionValue);
    separation.mult(seperationValue);

    this.applyForce(alignment);
    this.applyForce(cohesion);
    this.applyForce(separation);
  }

  void applyForce(PVector force) {
    this.acceleration.add(force);
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
    noStroke();
    fill(29);
    ellipse(this.position.x, this.position.y, 35, 35);
    beginShape();
    //noFill();
    for (int i = 0; i < this.history.size(); i++) {
      PVector pos = this.history.get(i);
      float r = map(i, 0, history.size(), 10, 30);
      ellipse(pos.x, pos.y, r, r);
      //vertex(pos.x, pos.y);
    }
    endShape();
    fill(222);
    ellipse(this.position.x, this.position.y, 15, 15);
  }
}
