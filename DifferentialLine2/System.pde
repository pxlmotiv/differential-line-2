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
    showGrid = true;

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

    for (Cell c : cells)
      c.draw();
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
