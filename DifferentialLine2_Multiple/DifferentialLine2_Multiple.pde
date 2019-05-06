int amountOfSystems = 0;
ArrayList<System> systems;
ColorPaletteManager paletteMgr;

void setup()
{
  size(900, 900, P3D);
  //fullScreen(P3D);
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
    Canvas canvas = canvases.get(i);
    
    float springFactor = canvas.suggestSpringFactor();
    float planarFactor = canvas.suggestPlanarFactor();
    float repulsionStrength = canvas.suggestRepulsionStrength();
    float radiusOfInfluence = canvas.suggestRadiusOfInfluece();    
    float restLength = canvas.suggestRestLength();
    
    System system = new System(springFactor, planarFactor, 1, repulsionStrength, radiusOfInfluence, restLength);
    system.canvas = canvas;
    system.start = system.canvas.getMidpoint();
        
    palette = paletteMgr.getAdjustedColorPalette(cpIndex);

    system.setColors(palette[0], palette[1], palette[2]);
    //Boundary boundary = new CircularBoundary(system.start.x, system.start.y, min(system.canvas._width, system.canvas._height)*0.5);
    
    Boundary boundary = new RectangularBoundary(
      system.canvas.getMinX() + system.canvas._width*0.1, 
      system.canvas.getMinY() + system.canvas._height*0.1, 
      system.canvas.getMaxX() - system.canvas._width*0.1, 
      system.canvas.getMaxY() - system.canvas._height*0.1
      );
    
    system.setBoundary(boundary);
    int startingNodes = canvas.suggestStartingNodes();
    int foodThreshold = canvas.suggestFoodThreshold();

    ArrangementSettings arrangeSettings = new ArrangementSettings(startingNodes, system.restLength * 4.5, 0, foodThreshold);
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

void mousePressed()
{
  reset();
}
