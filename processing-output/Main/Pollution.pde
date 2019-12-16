class Pollution {
  PVector position;
  int r;
  float alpha;
  boolean isAlive;

  color c;

  Pollution(PVector pos) {
    position = pos;
    r = int(random(12, 12));
    alpha = 0;
    isAlive = false;

    c = color_pollution;
  }

  void show() {
    if (isAlive) {
      if (frameCount%2 == 0 && this.alpha < 150) {
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
}
