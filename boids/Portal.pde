class Portal {
  PVector position1;
  PVector position2;
  Colour colour1;
  Colour colour2;
  float r;
  boolean enabled;
  
  Portal() {
    position1 = new PVector(random(0 + 16, width - 16), random(0 + 16, height - 16));
    position2 = new PVector(random(0 + 16, width - 16), random(0 + 16, height - 16));
    colour1 = new Colour(240, 200, 60);
    colour2 = new Colour(120, 60, 240);
    r = 48.0;
    enabled = true;
  }
  
  void render() {
    if (!enabled) return;
    stroke(0);
    
    colour1.setFill();
    circle(position1.x, position1.y, r);
    
    colour2.setFill();
    circle(position2.x, position2.y, r);
  }
  
  void use(Boid boid) {
    if (!enabled) return;

    if (position1.dist(boid.position) <= r / 2) {
      boid.position = new PVector(position2.x, position2.y);
    }
  }
  
  void toggle() {
    if (enabled) {
      enabled = false;
    } else {
      position1 = new PVector(random(0 + 16, width - 16), random(0 + 16, height - 16));
      position2 = new PVector(random(0 + 16, width - 16), random(0 + 16, height - 16));
      enabled = true;
    }
  }
}
