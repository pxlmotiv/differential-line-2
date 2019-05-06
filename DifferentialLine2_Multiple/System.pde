class System { //<>//
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
  }

  void setColors(color _strokeColor, color _fillColor, color _bgColor) {
    strokeColor = _strokeColor;
    fillColor = _fillColor;
    bgColor = _bgColor;
  }  

  void setCanvas(float x, float y, float w, float h) {
    canvas = new Canvas(x, y, w, h);
    start = canvas.getMidpoint();
  }

  void setBoundary(Boundary b) {
    boundary = b;
    maxCellsAllowed = b.getMaxCellsAllowed(restLength);
  }

  void setArrangementSettings(ArrangementSettings s) {
    arrangementSettings = s;
  }

  void distributeFood() {
    if (amountOfCells >= maxCellsAllowed) return;
    randomUniformDistribution(this);
    //byCurvature(this);
  }

  void computeCellSplits() {
    if (amountOfCells >= maxCellsAllowed) return;
    splitRandomLink(this);
    //splitByCurvature(this);
  }

  void updateCellForces() {
    int s = amountOfCells;

    for (int i = 0; i < s; i++) {
      Cell c = cells.get(i);
      c.updateTargets();
      c.updatePosition(boundary);
      //c.repulsionChecked = qtree.findAndCalculateRepulsion(c);
    }
  }  

  void draw() {
    for (Cell c : cells) {
      c.draw();
    }
  }

  void drawWithCurves() {
    pushStyle();
    fill(bgColor);
    noStroke();
    canvas.drawAtLimits();    
    popStyle();

    boolean reachedEnd = false;

    float alpha = 255;

    strokeWeight(1);
    stroke(strokeColor, alpha*3);    
    fill(fillColor, alpha);
    //noFill();

    Cell c0 = cells.get(0);
    Cell c = c0.links.get(0);
    Cell cEnd = c0.links.get(1);

    beginShape();
    curveVertex(c0.position.x, c0.position.y);
    curveVertex(c0.position.x, c0.position.y);

    int lastIdChecked = c0.id;
    c0.hasBeenDrawn = true;

    while (!reachedEnd) {
      curveVertex(c.position.x, c.position.y);
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

    curveVertex(cEnd.position.x, cEnd.position.y);
    curveVertex(cEnd.position.x, cEnd.position.y);    
    endShape(CLOSE);
  }

  private void arrange() {
    cells = arrangeInCircle(this);
    //cells = arrangeInSpikes(this);
  }
}
