class Plastic {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int r;
  float alpha;
  boolean isAlive;
  
  color c;

  Plastic(PVector pos) {
    position = pos;
    this.velocity = new PVector();
    this.acceleration = new PVector();
    r = int(random(12, 12));
    alpha = 0;
    isAlive = false;
    
    c = color_plastic;
  }



  void show() {
    if (isAlive) {
      if (frameCount%2 == 0 && this.alpha < 180) {
        this.alpha++;
      }
    } else if (!isAlive) {
      if (frameCount%1 == 0 && this.alpha > 0) {
        this.alpha--;
      }
    }
    fill(c, alpha);
    noStroke();
    ellipse(this.position.x, this.position.y, r, r);
  }
  /*
  void drift() {
   PVector dir = PVector.random2D();
   dir.normalize();
   dir.mult(.0001);
   this.acceleration = dir;
   this.velocity.add(this.acceleration);
   this.position.add(this.velocity);
   this.acceleration.mult(0);
   }
   */
  /*
  void stick(ArrayList<Plastic> pl) {
   for (Plastic other : pl) {
   float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
   if (other != this && d < (other.r1+other.r2)/2) {
   this.velocity = new PVector(0, 0);
   }
   }
   }
   */
  void applyForce(PVector force) {
    this.acceleration.add(force);
  }
}
