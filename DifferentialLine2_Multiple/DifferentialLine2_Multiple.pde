int AMOUNT_OF_SYSTEMS = 4;
ArrayList<System> systems = new ArrayList<System>();

void setup()
{
  size(1060, 1060, P3D);
  curveDetail(8);
  curveTightness(0);
  smooth(16);

  reset();
}

void draw()
{
  for (int i = 0; i < AMOUNT_OF_SYSTEMS; i++) {
    System system = systems.get(i);
    system.distributeFood();
    system.computeCellSplits();
    system.updateCellForces();
    system.drawWithCurves();
  }
  //saveFrame("quad4/####.png");
}

void reset()
{
  float[] xCoords = {0, width/2, 0, width/2};
  float[] yCoords = {height/2, 0, 0, height/2};
  
  for (int i = 0; i < AMOUNT_OF_SYSTEMS; i++) {
    System system = new System(0.5, 0.1, 1, 1.3, 7 + i*2, 3+i);

    system.setCanvas(xCoords[i], yCoords[i], width/2, height/2);
    
    system.setColors(color(117, 119, 128), color(132, 194, 14), color(26, 30, 39));
    
    Boundary boundary = new CircularBoundary(system.start.x, system.start.y, 150);
    system.setBoundary(boundary);

    ArrangementSettings arrangeSettings = new ArrangementSettings(48, system.restLength * 6, 0, 5);
    system.setArrangementSettings(arrangeSettings);

    system.arrange();

    systems.add(system);
  }
}

void keyPressed()
{
  if (key == ' ')
    saveFrame("tests/####.png");
}
