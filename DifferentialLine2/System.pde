class System { //<>//
  ArrayList<Cell> cells;
  QuadTree qtree;
  float springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength;
  boolean showGrid;
  int lastId;

  System(float sF, float pF, float  bF, float rS, float roi, float rL) {
    springFactor = sF;
    planarFactor = pF;
    bulgeFactor = bF;
    repulsionStrength = rS;
    radiusOfInfluence = roi;
    restLength = rL;
    showGrid = false;
    lastId = -1;

    arrange();
    //resetQuadTree(); //QUADTREE disabled for now because couldn't get it to work properly
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
    splitRandomLink();
    //splitByCurvature();
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
      c.draw();
    }
  }

  void drawWithCurves() {
    boolean reachedEnd = false;

    stroke(48, 66, 63);
    strokeWeight(2);
    fill(12, 26, 27);    

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

  private void resetQuadTree() {
    qtree = new QuadTree(null, new Rectangle(0, 0, width, height), 500);

    for (Cell c : cells)
      qtree.insert(c);
  }
}
