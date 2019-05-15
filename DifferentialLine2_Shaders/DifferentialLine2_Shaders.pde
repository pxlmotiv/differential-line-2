import processing.pdf.*;
import processing.svg.*;

int amountOfSystems = 0;
ArrayList<System> systems;
ColorPaletteManager paletteMgr;

void setup()
{
  size(1400, 1050, P3D);
  //fullScreen(P3D);
  curveDetail(8);
  curveTightness(0);
  smooth(16);
  //blendMode(ADD);
  
  reset();
  //resetOneSystem();
  //resetBigCircularBounds();
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
  
  //saveFrame("newvideoGen/####.png");
}

void drawBackground(PGraphics g) {
  for (int i = 0; i < amountOfSystems; i++) {
    System system = systems.get(i);
    system.drawBackground(g);
    //system.drawGradientBackground(g);
  }
}

void keyPressed()
{
  if (key == ' ')
    saveFrame("../tests/####.png");
  else if (key == 'h')
    saveHiRes(2);
}

void mousePressed()
{
  reset();
  //resetOneSystem();
  //resetBigCircularBounds();
}

void saveHiRes(int scaleFactor) {
  String name = str(year()) + str(month()) + str(day()) + str(hour()) + str(minute()) + str(second());
  //PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, PDF, "../vectorized results/" + name + ".pdf");
  PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, SVG, "../vectorized results/" + name + ".svg");
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
