class Colour {
  int r;
  int g;
  int b;
  
  Colour(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  Colour() {
    this((int)random(128, 256), (int)random(128, 256), (int)random(128, 256));
  }
  
  void setFill() {
    fill(r, g, b);
  }
  
  void setStroke() {
    stroke(r, g, b);
  }
}
