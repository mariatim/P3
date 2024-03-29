class Plastic {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int r1, r2;
  float alpha;
  boolean isAlive;

  Plastic(PVector pos) {
    position = pos;
    this.velocity = new PVector();
    this.acceleration = new PVector();
    r1 = int(random(10, 15));
    r2 = int(random(10, 15));
    alpha = 0;
    isAlive = true;
  }



  void show() {
    if (isAlive) {
      if (frameCount%2 == 0 && this.alpha < 160) {
        this.alpha++;
      }
    } else if (!isAlive) {
      if (frameCount%1 == 0 && this.alpha > 0) {
        this.alpha--;
      }
    }
    fill(255, 0, 100, alpha);
    noStroke();
    ellipse(this.position.x, this.position.y, r1, r2);
  }
  
  void drift() {
    PVector dir = PVector.random2D();
    dir.normalize();
    dir.mult(.0001);
    this.acceleration = dir;
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }
  /*
   void stick(ArrayList<Plastic> pl) {
   for (Plastic other : pl) {
   float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
   if (other != this && d < (other.r1+other.r2)/2) {
   this.velocity = new PVector(0, 0);
   }
   }
   }
   
   void applyForce(PVector force) {
   this.acceleration.add(force);
   }
   */
}
