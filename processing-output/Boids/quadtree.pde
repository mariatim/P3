class QuadTree {
  Rectangle boundary;
  ArrayList<Boid> boids;
  int capacity;
  Boolean isDivided;

  QuadTree northEast, northWest, southEast, southWest;

  QuadTree(Rectangle boundary, int n) {
    this.boundary = new Rectangle(boundary);
    this.capacity = n;
    this.boids = new ArrayList<Boid>();
    this.isDivided = false;
  }

  void subdivide() {
    float x = this.boundary.x;
    float y = this.boundary.y;
    float w = this.boundary.w * 0.5;
    float h = this.boundary.h * 0.5;

    Rectangle ne = new Rectangle(x + w, y - h, w, h);
    northEast = new QuadTree(ne, this.capacity);
    Rectangle nw = new Rectangle(x - w, y - h, w, h);
    northWest = new QuadTree(nw, this.capacity);
    Rectangle se = new Rectangle(x + w, y + h, w, h);
    southEast = new QuadTree(se, this.capacity);
    Rectangle sw = new Rectangle(x - w, y + h, w, h);
    southWest = new QuadTree(sw, this.capacity);
    isDivided = true;
  }

  Boolean insert(Boid point) {
    if (!this.boundary.contains(point)) {
      return false;
    }

    if (boids.size() < this.capacity) {
      boids.add(point);
      return true;
    } else {
      if (!isDivided) {
        subdivide();
      }
      if (northEast.insert(point)) {
        return true;
      } else if (this.northWest.insert(point)) {
        return true;
      } else if (this.southEast.insert(point)) {
        return true;
      } else if (this.southWest.insert(point)) {
        return true;
      }
    }
    return false;
  }
  
  
  ArrayList<Boid> query(Rectangle range, ArrayList<Boid> found) {
    if (found == null) {
      found = new ArrayList<Boid>();
    }
    if (this.boundary.intersects(range)) {
      for (Boid p : boids) {
        if (range.contains(p)) {
          found.add(p);
        }
      }
      if (isDivided) {
        northWest.query(range, found);
        northEast.query(range, found);
        southWest.query(range, found);
        southEast.query(range, found);
      }
    }
    return found;
  }
  
  //display the boundaries of rectangels and its children rectangles
  void show() {
    stroke(255);
    strokeWeight(0.5);
    noFill();
    rectMode(CENTER);
    rect(boundary.x, boundary.y, boundary.w * 2, boundary.h * 2);
    if (isDivided) {
      this.northEast.show();
      this.northWest.show();
      this.southEast.show();
      this.southWest.show();
    }
  }
}
