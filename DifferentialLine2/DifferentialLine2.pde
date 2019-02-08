System system;
PVector start;

void setup() {
  size(1024, 1024, P2D);
  //frameRate(2);
  reset();
}

void draw() {
  background(255);

  system.update();
  system.draw();
}

void reset() {
  float springFactor = 0.1;
  float planarFactor = 0.1;
  float bulgeFactor = 1.0;
  float repulsionStrength = 1.0;
  float radioOfInfluence = 30.0;
  float restLength = 5;

  start = new PVector(width/2.0, height/2.0);

  system = new System(springFactor, planarFactor, bulgeFactor, repulsionStrength, radioOfInfluence, restLength);
}

void keyPressed() {
  if(key == ' ')
    saveFrame("tests/####.png");
}
