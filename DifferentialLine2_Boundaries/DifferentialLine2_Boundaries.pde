//// SYSTEM SETTINGS \\\\

// Bigger adds noise to small areas
float springFactor = 0.85;

// Bigger straigtens the lines and produces fewer branches.
float planarFactor = 0.1;

// not used by now
float bulgeFactor = 1.0; 

// Bigger makes faster growth
float repulsionStrength = 1.3;

// Bigger leads to wider paths
float radiusOfInfluence = 10.5;

// Needs to be less than half of RadiusOfInfluence
float restLength = 2.125;             

System system;

PVector start;
color bgColor = color(26, 30, 39);

void setup()
{
  size(540, 540, P3D);
  curveDetail(8);
  curveTightness(0);
  smooth(16);
  background(bgColor);
  //blendMode(ADD);
  reset();
}

void draw()
{
  background(bgColor);

  system.update();
  //system.draw();
  system.drawWithCurves();

  saveFrame("quad4/####.png");
}

void reset()
{
  start = new PVector(width/2.0, height/2.0);

  system = new System(springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength);

  Boundary boundary = new CircularBoundary(width/2.0, height/2.0, 220);
  //Boundary boundary = new RectangularBoundary(width/2.0 - 200, height/2.0 - 200, width/2.0 + 200, height/2.0 + 200);
  //Boundary boundary = new RomboidBoundary(width/2.0-250, height/2.0-250, width/2.0, height/2.0, width/2.0+250, height/2.0+250);
  //Boundary boundary = new TriangularBoundary(width/2.0, height/2.0 - 50, 250);
  //Boundary boundary = new RandomLinesBoundary();

  system.setBoundary(boundary);
}

void keyPressed()
{
  if (key == ' ')
    saveFrame("tests/####.png");
  else if (key == 'g')
    system.showGrid = !system.showGrid;
}
