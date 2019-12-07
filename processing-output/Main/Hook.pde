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
    //startingPosition = new PVector(3*width/4, height-10);
    //direction = new PVector(random(-4, 2), random(-2, -4));
    
    startingPosition = new PVector(width/2, height-20);
    direction = new PVector(random(-4, 4), random(-2, -4));
    currentEndPosition = startingPosition.copy();
    hookRadius = 20;
    alpha = 255;
    active = false;
    dir = true;
  }

  void show() {
    if (this.active) {
      currentEndPosition.add(this.updateDirection().mult(2));
      stroke(210, alpha);
      strokeWeight(2);
      noFill();
      ellipse(this.currentEndPosition.x, this.currentEndPosition.y, 30, 30);
      //line(this.startingPosition.x, this.startingPosition.y, this.currentEndPosition.x, this.currentEndPosition.y);
    }
  }

  void catchFish(ArrayList<Tuna> tu) {
    for (Tuna t : tu) {
      if (this.active) {
        if (dist(this.currentEndPosition.x, this.currentEndPosition.y, t.position.x, t.position.y) <= 10 || dist(this.currentEndPosition.x, this.currentEndPosition.y, this.startingPosition.x, this.startingPosition.y) >= width/2) {
          this.dir = false;
        } else if (dist(this.currentEndPosition.x, this.currentEndPosition.y, this.startingPosition.x, this.startingPosition.y) <= 10) {
          this.dir = true;
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
