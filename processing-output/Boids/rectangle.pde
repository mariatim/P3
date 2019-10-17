class Rectangle {
  float x, y;
  float w, h;

  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  Rectangle(Rectangle other) {
    this.x = other.x;
    this.y = other.y;
    this.w = other.w;
    this.h = other.h;
  }
  
  //check if a point is within the boundary
  Boolean contains(Boid point) {
    return (
      point.position.x >= x - w &&
      point.position.x <= x + w &&
      point.position.y >= y - h &&
      point.position.y <= y + h);
  }
  //check if the rectangle intersects with the given rectangle
  Boolean intersects(Rectangle range) {
    return !(
      range.x - range.w > x + w ||
      range.x + range.w < x - w ||
      range.y - range.h > y + h ||
      range.y + range.h < y - h);
  }
}
