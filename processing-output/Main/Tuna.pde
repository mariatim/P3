class Tuna {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int maxForce;
  float maxSpeed, baseSpeed;
  ArrayList<PVector> history;
  int trailSize;

  float alignValue = .65;
  float cohesionValue = .4;
  float cohesionBase = .4;
  float seperationValue = .8;

  color c;

  boolean caught;
  boolean isAlive;
  float alpha;
  int frameCountWhenKilled;
  int FRAMES_NEEDED_TO_RESSURECT = 250;

  Tuna() {
    this.position = new PVector(random(width), random(height));
    this.velocity = PVector.random2D();
    this.velocity.setMag(random(2, 4));
    this.acceleration = new PVector();
    this.maxForce = 1;
    this.maxSpeed = 5;
    this.baseSpeed = 5;
    history = new ArrayList<PVector>();
    trailSize = 8;
    c = color_mackerel;
    caught = false;
    isAlive = true;
    alpha = 0;
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

  void avoidPollution(ArrayList<Pollution> pl) {
    int perceptionRadius = 30;
    PVector steering = new PVector();
    int total = 0;
    for (Pollution other : pl) {
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
    int perceptionRadius = 300;
    PVector steering = new PVector();
    int total = 0;
    PVector island1 = new PVector(3.5*width/8, height+50);
    PVector island2 = new PVector(2.85*width/4, height+150);
    float d1 = dist(this.position.x, this.position.y, island1.x, island1.y);
    float d2 = dist(this.position.x, this.position.y, island2.x, island2.y);
    if (d1 < perceptionRadius) {
      PVector diff = PVector.sub(this.position, island1);
      diff.div(d1 * d1);
      steering.add(diff);
      total++;
    }
    if (d2 < perceptionRadius) {
      PVector diff = PVector.sub(this.position, island2);
      diff.div(d2 * d2);
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

  void avoidWhales(ArrayList<Whale> wh) {
    int perceptionRadius = 80;
    PVector steering = new PVector();
    int total = 0;
    for (Whale other : wh) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (d < perceptionRadius) {
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
    this.applyForce(steering);
  }

  void avoidShark(ArrayList<Shark> s) {
    int perceptionRadius = 80;
    PVector steering = new PVector();
    int total = 0;
    for (Shark other : s) {
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

  PVector align(ArrayList<Tuna> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Tuna other : boids) {
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

  PVector separation(ArrayList<Tuna> boids) {
    int perceptionRadius = 50;
    PVector steering = new PVector();
    int total = 0;
    for (Tuna other : boids) {
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

  PVector cohesion(ArrayList<Tuna> boids) {
    int perceptionRadius = 100;
    PVector steering = new PVector();
    int total = 0;
    for (Tuna other : boids) {
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

  void flock(ArrayList<Tuna> boids) {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohesion(boids);
    PVector separation = this.separation(boids);

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
    if (isAlive) {
      if (this.alpha < 255) {
        alpha++;
      }
    }
    fill(c, alpha);
    ellipse(this.position.x, this.position.y, 8, 8);
    beginShape();
    for (int i = 0; i < this.history.size(); i++) {
      PVector pos = this.history.get(i);
      float r = map(i, 0, history.size(), 1, 7);
      ellipse(pos.x, pos.y, r, r);
    }
    endShape();
  }

  void getCaught(ArrayList<Boat> boats) {
    if (!this.caught) {
      for (Boat b : boats) {
        if (b.active == true && dist(this.position.x, this.position.y, b.currentPosition.x, b.currentPosition.y) <= b.radius) {
          this.kill();
          this.caught = true;
        }
      }
    }
  }

  boolean isAlive() {
    return isAlive;
  }

  void kill() {
    isAlive = false;
    frameCountWhenKilled = frameCount;
  }

  void ressurect() {
    isAlive = true;
    alpha = 0;
    this.position = new PVector(random(width), random(height));
  }

  void tryToRessurect() {
    if ((frameCount - frameCountWhenKilled) >= FRAMES_NEEDED_TO_RESSURECT) {
      this.caught = false;
      this.ressurect();
    }
  }
}
