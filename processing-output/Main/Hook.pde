class Hook {
  PVector startingPosition;
  PVector currentEndPosition;
  PVector direction;
  int hookRadius;
  boolean active;

  boolean dir;

  color c;
  int alpha;

  Hook() {
    this.reset();
    hookRadius = 15;
    active = false;
    dir = true;
    c = color_plastic;
  }

  void reset() {
    startingPosition = new PVector(width/2, height-20);
    direction = new PVector(random(-4, 4), random(-2, -4));
    currentEndPosition = startingPosition.copy();
    alpha = 0;
  }

  void show() {
    if (this.active == true) {
      currentEndPosition.add(this.updateDirection().mult(2));
    }
    if (this.active == true && this.alpha < 200) {
      this.alpha = this.alpha + 40;
    } else if (this.active == false && this.alpha >= 0) {
      this.alpha = this.alpha - 40;
      if (this.alpha <= 0) {
        this.reset();
      }
    }
    stroke(c, alpha);
    strokeWeight(2);
    noFill();
    //point(this.currentEndPosition.x, this.currentEndPosition.y);
    //ellipse(this.currentEndPosition.x, this.currentEndPosition.y, 5, 5);
    //ellipse(this.currentEndPosition.x, this.currentEndPosition.y, 15, 15);
    ellipse(this.currentEndPosition.x, this.currentEndPosition.y, 25, 25);
  }

  void catchFish(ArrayList<Tuna> tu) {
    if (this.active || this.alpha > 0) {
      for (Tuna t : tu) {
        if (dist(this.currentEndPosition.x, this.currentEndPosition.y, t.position.x, t.position.y) <= 10 || dist(this.currentEndPosition.x, this.currentEndPosition.y, this.startingPosition.x, this.startingPosition.y) >= width/2) {
          this.dir = false;
        } else if (dist(this.currentEndPosition.x, this.currentEndPosition.y, this.startingPosition.x, this.startingPosition.y) <= 10) {
          this.dir = true;
          direction = new PVector(random(-4, 4), random(-2, -4));
        }
      }
    }
  }

  PVector updateDirection() {
    PVector d = new PVector();
    if (dir == true) {
      d = this.direction.copy();
    } else if (dir == false) {
      d = this.direction.copy().mult(-1);
    }
    return d;
  }
}
