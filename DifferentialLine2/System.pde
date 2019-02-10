class System {
  ArrayList<Cell> cells;
  QuadTree qtree;
  float springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength;
  boolean showGrid;

  System(float sF, float pF, float  bF, float rS, float roi, float rL) {
    springFactor = sF;
    planarFactor = pF;
    bulgeFactor = bF;
    repulsionStrength = rS;
    radiusOfInfluence = roi;
    restLength = rL;
    showGrid = false;

    arrange();
    //resetQuadTree();
  }

  void update() {
    distributeFood();
    computeCellSplits();
    updateCellForces();
    //resetQuadTree();
  }

  void distributeFood() {
    randomUniformDistribution();
    //byCurvature();
  }

  void computeCellSplits() {
    //splitRandomLink();
    splitByCurvature();
  }

  void updateCellForces() {
    int s = cells.size();

    for (int i = 0; i < s; i++) {
      Cell c = cells.get(i);
      c.updateTargets();
      c.updatePosition();
      //c.repulsionChecked = qtree.findAndCalculateRepulsion(c);
    }
  }  

  void draw() {
    //qtree.show();

    for (Cell c : cells) {
      //c.draw();
      c.drawWithCurves();
    }
  }

  void drawWithCurves() {
    boolean reachedEnd = false;

    stroke(0);
    strokeWeight(1);
    fill(50, 200, 255);
    curveDetail(8);
    curveTightness(0);

    Cell c0 = cells.get(0);
    Cell c = c0.links.get(0);
    Cell cEnd = c0.links.get(1);

    beginShape();
    curveVertex(c0.position.x, c0.position.y);
    curveVertex(c0.position.x, c0.position.y);
    
    while (!reachedEnd) {
      c.hasBeenDrawn = true;
      curveVertex(c.position.x, c.position.y);
      Cell l0 = c.links.get(0);
      Cell l1 = c.links.get(1);
      c = l1.hasBeenDrawn ? l0 : l1;
      reachedEnd = c == cEnd;
    }
    
    curveVertex(cEnd.position.x, cEnd.position.y);
    curveVertex(cEnd.position.x, cEnd.position.y);    
    endShape(CLOSE);
  }

  private void arrange() {
    cells = arrangeInCircle(this);
    //cells = arrangeInSpikes(this);
  }

  private void resetQuadTree() {
    qtree = new QuadTree(null, new Rectangle(0, 0, width, height), 500);

    for (Cell c : cells)
      qtree.insert(c);
  }
}
