import processing.pdf.*;
import processing.svg.*;

int amountOfSystems = 0;
ArrayList<System> systems;
ColorPaletteManager paletteMgr;

void setup()
{
  size(1600, 900, P3D);
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
    system.drawWithCurves(this.g);
  }
  //saveFrame("header/####.png");
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

    Boundary boundary = buildBoundary(system);
    system.setBoundary(boundary);

    int startingNodes = canvas.suggestStartingNodes();
    int foodThreshold = canvas.suggestFoodThreshold();

    ArrangementSettings arrangeSettings = new ArrangementSettings(startingNodes, system.restLength * 4.5, 0, foodThreshold);
    system.setArrangementSettings(arrangeSettings);

    system.arrange();

    systems.add(system);
  }
  
  drawBackground(this.g);
}

void drawBackground(PGraphics g) {
  for (int i = 0; i < amountOfSystems; i++) {
    System system = systems.get(i);
    system.drawBackground(g);
  }
}

Boundary buildBoundary(System system) {
  int choosenBoundary = round(random(-0.49, 3.49));
  Boundary boundary;
  if (choosenBoundary == 0) {
    boundary = new CircularBoundary(system.start.x, system.start.y, min(system.canvas._width, system.canvas._height) * random(0.33, 0.5));
  } else if (choosenBoundary == 1) {
    float margin = min(system.canvas._width*0.1, system.canvas._height*0.1);
    boundary = new RectangularBoundary(
      system.canvas.getMinX() + margin, 
      system.canvas.getMinY() + margin, 
      system.canvas.getMaxX() - margin, 
      system.canvas.getMaxY() - margin
      );
  } else if (choosenBoundary == 2) {
    float offset = round(random(6)) * (PI/6.0);
    float s = min(system.canvas._width, system.canvas._height) * 0.5;
    boundary = new TriangularBoundary(system.start.x, system.start.y, s, offset);
  } else if (choosenBoundary == 3) {
    boundary = new RomboidBoundary(
      system.canvas.getMinX(), 
      system.canvas.getMinY(), 
      system.canvas.getMinX() + system.canvas._width*0.5, 
      system.canvas.getMinY() + system.canvas._height*0.5, 
      system.canvas.getMaxX(), 
      system.canvas.getMaxY());
  } else {
    boundary = new RandomLinesBoundary();
  }
  return boundary;
}

void keyPressed()
{
  if (key == ' ')
    saveFrame("tests/####.png");
  else if (key == 'h')
    saveHiRes(2);
}

void mousePressed()
{
  reset();
}

void saveHiRes(int scaleFactor) {
  String name = str(year()) + str(month()) + str(day()) + str(hour()) + str(minute()) + str(second());
  //PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, PDF, name + ".pdf");
  PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, SVG, name + ".svg");
  hires.beginDraw();
  hires.scale(scaleFactor);
  hires.curveDetail(8);
  hires.curveTightness(0);
  hires.smooth(16);
  hires.background(this.systems.get(0).bgColor);
  drawBackground(hires);
  for (int i = 0; i < amountOfSystems; i++) {
    System system = systems.get(i);
    system.distributeFood();
    system.computeCellSplits();
    system.updateCellForces();
    system.drawWithCurves(hires);
  }
  hires.dispose();
  hires.endDraw();
}
