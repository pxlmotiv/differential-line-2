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

    Boundary boundary = buildBoundary(system);
    system.setBoundary(boundary);
    
    int startingNodes = canvas.suggestStartingNodes();
    int foodThreshold = canvas.suggestFoodThreshold();

    ArrangementSettings arrangeSettings = new ArrangementSettings(startingNodes, system.restLength * 3, 0, foodThreshold);
    system.setArrangementSettings(arrangeSettings);

    system.arrange();

    systems.add(system);
  }

  drawBackground(this.g);
}

void resetBigCircularBounds()
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
    
    int choosenBoundary = round(random(1));
    if (choosenBoundary == 0) {
      Boundary boundary = new CircularBoundary(system.start.x, system.start.y, min(system.canvas._width, system.canvas._height) * random(1, 1.5));
      system.setBoundary(boundary);
    } else if (choosenBoundary == 1) {
      float r = random(-0.25, 0.25);
      float margin = min(system.canvas._width*r, system.canvas._height*r);
      Boundary boundary = new RectangularBoundary(
        system.canvas.getMinX() + margin, 
        system.canvas.getMinY() + margin, 
        system.canvas.getMaxX() - margin, 
        system.canvas.getMaxY() - margin
        );
      system.setBoundary(boundary);
    }

    int startingNodes = canvas.suggestStartingNodes();
    int foodThreshold = canvas.suggestFoodThreshold();

    ArrangementSettings arrangeSettings = new ArrangementSettings(startingNodes, system.restLength * 5, 0, foodThreshold);
    system.setArrangementSettings(arrangeSettings);

    system.arrange();

    systems.add(system);
  }

  drawBackground(this.g);
}

void resetOneSystem()
{
  systems = new ArrayList<System>();

  paletteMgr = new ColorPaletteManager();

  color[] palette = paletteMgr.getRandomAdjustedColorPalette();

  ArrayList<Canvas> canvases = new ArrayList<Canvas>();
  canvases.add(new Canvas(0, 0, width, height));
  amountOfSystems = 1;

  background(20);

  for (int i = 0; i < 1; i++) {
    Canvas canvas = canvases.get(i);

    float springFactor = 0.2;//0.4
    float planarFactor = 0.12;//0.1
    float repulsionStrength = 0.125;//0.4//0.125
    float radiusOfInfluence = 40.0;//25.0  
    float restLength = 1.85;//3.0

    System system = new System(springFactor, planarFactor, 1, repulsionStrength, radiusOfInfluence, restLength);
    system.canvas = canvas;
    system.start = system.canvas.getMidpoint();
    system.shader.set("u_resolution", float(width), float(height));

    palette = paletteMgr.getRandomAdjustedColorPalette();

    system.setColors(palette[0], palette[1], palette[2]);

    int startingNodes = 32;
    int foodThreshold = 3;

    ArrangementSettings arrangeSettings = new ArrangementSettings(startingNodes, system.restLength * 30, 0, foodThreshold);
    system.setArrangementSettings(arrangeSettings);

    system.arrange();

    systems.add(system);
  }

  drawBackground(this.g);
}
