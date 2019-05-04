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

  //saveFrame("quad4/####.png");
}

void reset()
{
  system = new System(0.85, 0.1, 1, 1.3, 10.5, 2.125);

  Boundary boundary = new CircularBoundary(width/2.0, height/2.0, 220);
  system.setBoundary(boundary);
    
  ArrangementSettings arrangeSettings = new ArrangementSettings(48, system.restLength * 6, 0, 5);
  system.setArrangementSettings(arrangeSettings);
  
  system.arrange();
}

void keyPressed()
{
  if (key == ' ')
    saveFrame("tests/####.png");
  else if (key == 'g')
    system.showGrid = !system.showGrid;
}
