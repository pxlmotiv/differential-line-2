System system;

PVector start;

void setup() {
  size(720, 720, P3D);
  curveDetail(8);
  curveTightness(0);
  smooth(16);
  
  reset();
}

void draw() {
  background(20);

  system.update();
  //system.draw();
  system.drawWithCurves();

  //saveFrame("gif/####.png");
}

void reset() {
  float springFactor = 0.1;
  float planarFactor = 0.15;       // Bigger straigtens the lines and produces fewer branches.
  float bulgeFactor = 1.0;        // not used by now
  float repulsionStrength = 0.5;  // Bigger makes faster growth
  float radiusOfInfluence = 20.0;  // Bigger leads to wider paths
  float restLength = 2.00;         // Needs to be less than half of RadiusOfInfluence

  start = new PVector(width/2.0, height/2.0);

  system = new System(springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength);
}

void keyPressed() {
  if (key == ' ')
    saveFrame("tests/####.png");
  else if (key == 'g')
    system.showGrid = !system.showGrid;
}

float distSq(PVector p1, PVector p2) {
  return (p2.y - p1.y)*(p2.y - p1.y)+(p2.x - p1.x)*(p2.x - p1.x);
}
