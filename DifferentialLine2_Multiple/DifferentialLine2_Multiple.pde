int amountOfSystems = 0;
ArrayList<System> systems;
ColorPaletteManager paletteMgr;

void setup()
{
  size(720, 720, P3D);
  curveDetail(8);
  curveTightness(0);
  smooth(16);

  reset();
}

void draw()
{
  for (int i = 0; i < amountOfSystems; i++) {
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
  systems = new ArrayList<System>();
  
  paletteMgr = new ColorPaletteManager();
  
  int cpIndex = floor(random(paletteMgr.palettes.length));  
  
  color[] palette = paletteMgr.getAdjustedColorPalette(cpIndex);
  
  ArrayList<Canvas> canvases = CreateCanvases(0, 0, width, height, null);
  
  amountOfSystems = canvases.size();
  
  background(palette[2]);
  
  for (int i = 0; i < amountOfSystems; i++) {
    System system = new System(0.3, 0.1, 1, random(0.85, 1.1), 8, 2);
    system.canvas = canvases.get(i);
    system.start = system.canvas.getMidpoint();
    
    palette = paletteMgr.getAdjustedColorPalette(cpIndex);

    system.setColors(palette[0], palette[1], palette[2]);

    //Boundary boundary = new CircularBoundary(system.start.x, system.start.y, 150);
    Boundary boundary = new RectangularBoundary(
      system.canvas.getMinX() + system.canvas._width*0.1, 
      system.canvas.getMinY() + system.canvas._height*0.1, 
      system.canvas.getMaxX() - system.canvas._width*0.1, 
      system.canvas.getMaxY() - system.canvas._height*0.1
      );

    system.setBoundary(boundary);

    ArrangementSettings arrangeSettings = new ArrangementSettings(floor(random(48, 64)), system.restLength * 6, 0, 5);
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

void mousePressed() {
  reset();
}
