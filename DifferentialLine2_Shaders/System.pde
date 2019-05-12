class System { //<>//
  PShader shader;
  ArrayList<Cell> cells;
  float springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength;
  boolean showGrid;
  int lastId, amountOfCells, maxCellsAllowed;
  Boundary boundary;
  color strokeColor, fillColor, bgColor;
  ArrangementSettings arrangementSettings;
  Canvas canvas;
  PVector start;

  System(float sF, float pF, float  bF, float rS, float roi, float rL) {
    springFactor = sF;
    planarFactor = pF;
    bulgeFactor = bF;
    repulsionStrength = rS;
    radiusOfInfluence = roi;
    restLength = rL;
    showGrid = false;
    lastId = -1;
    maxCellsAllowed = -1;
    shader = loadShader("colorfrag.glsl", "colorvert.glsl");
    
  }

  void setColors(color _strokeColor, color _fillColor, color _bgColor) {
    strokeColor = _strokeColor;
    fillColor = _fillColor;
    bgColor = _bgColor;

    float[] c1 = getColorAsArrayOfChannels(_strokeColor);
    float[] c2 = getColorAsArrayOfChannels(_fillColor);
    float[] c3 = getColorAsArrayOfChannels(_bgColor);
    float[] c4 = getColorAsArrayOfChannels(_strokeColor);
    
    shader.set("u_color1", c1[0], c1[1], c1[2]);
    shader.set("u_color2", c2[0], c2[1], c2[2]);
    shader.set("u_color3", c3[0], c3[1], c3[2]);
    shader.set("u_color4", c4[0], c4[1], c4[2]);
  }  

  void setCanvas(float x, float y, float w, float h) {
    canvas = new Canvas(x, y, w, h);
    start = canvas.getMidpoint();
  }

  void setBoundary(Boundary b) {
    boundary = b;
    maxCellsAllowed = b.getMaxCellsAllowed(restLength);
    shader.set("u_resolution", canvas._width, canvas._height);
  }

  void setArrangementSettings(ArrangementSettings s) {
    arrangementSettings = s;
  }

  void distributeFood() {
    if (maxCellsAllowed != -1 && amountOfCells >= maxCellsAllowed) return;
    randomUniformDistribution(this);
    //byCurvature(this);
  }

  void computeCellSplits() {
    if (maxCellsAllowed != -1 && amountOfCells >= maxCellsAllowed) return;
    splitRandomLink(this);
    //splitByCurvature(this);
  }

  void updateCellForces() {
    int s = amountOfCells;

    for (int i = 0; i < s; i++) {
      Cell c = cells.get(i);
      c.updateTargets();
      c.updatePosition(boundary);
    }
  }  

  void draw(PGraphics g) {
    for (Cell c : cells) {
      c.draw(g);
    }
  }

  void drawBackground(PGraphics g) {
    g.pushStyle();
    g.fill(bgColor);
    g.noStroke();
    canvas.drawAtLimits(g);    
    g.popStyle();
  }
  
  void drawShaderBackground(PGraphics g) {
    g.pushStyle();
    g.noStroke();
    g.shader(shader);
    canvas.drawAtLimits(g);
    g.resetShader();
    g.popStyle();
  }

  void drawGradientBackground(PGraphics g) {
    g.pushStyle();
    g.noStroke();
    color[] colors = new color[] { 
      lerpColor(bgColor, #000000, 0.4), 
      lerpColor(bgColor, #ffffff, 0.4), 
      bgColor, 
      bgColor
    };
    canvas.drawGradientAtLimits(g, colors);
    g.popStyle();
  }

  void drawWithCurves(PGraphics g) {
    shader.set("u_time", frameCount / 10.0);
    
    //drawBackground(g);
    drawShaderBackground(g);
    //drawGradientBackground(g);    
    
    g.pushStyle();
    float alpha = 255;
    g.strokeWeight(1);
    g.stroke(strokeColor, alpha);
    g.fill(fillColor, alpha);    
    //g.shader(shader);
    g.shape(buildShape());
    g.resetShader();
    g.popStyle();
  }

  PShape buildShape() {
    PShape shape = createShape();

    boolean reachedEnd = false;

    Cell c0 = cells.get(0);
    Cell c = c0.links.get(0);
    Cell cEnd = c0.links.get(1);

    shape.beginShape();
    //shape.fill(getCellTargetsAsChannels(c0));
    shape.curveVertex(c0.position.x, c0.position.y);
    shape.curveVertex(c0.position.x, c0.position.y);

    int lastIdChecked = c0.id;
    c0.hasBeenDrawn = true;

    while (!reachedEnd) {
      //shape.fill(getCellTargetsAsChannels(c));
      shape.curveVertex(c.position.x, c.position.y);
      c.hasBeenDrawn = true;

      Cell l0 = c.links.get(0);
      Cell l1 = c.links.get(1);

      if (l1.hasBeenDrawn) {
        c = l0;
      } else if (l0.hasBeenDrawn) {
        c = l1;
      }

      lastIdChecked = c.id;

      reachedEnd = lastIdChecked == cEnd.id;
    }
    //shape.fill(getCellTargetsAsChannels(cEnd));
    shape.curveVertex(cEnd.position.x, cEnd.position.y);
    shape.curveVertex(cEnd.position.x, cEnd.position.y);    
    shape.endShape(CLOSE);

    return shape;
  }
  
  color getCellTargetsAsChannels(Cell c){
    float f = 255.0;
    return color(c.springTarget.mag()*f, c.planarTarget.mag()*f, c.collisionOffset.mag()*f);
  }

  private void arrange() {
    cells = arrangeInCircle(this);
    //cells = arrangeInEllipse(this);
    //cells = arrangeInSpikes(this);
  }
}
