class System {
  ArrayList<Cell> cells;

  float springFactor, planarFactor, bulgeFactor, repulsionStrength, radioOfInfluence, restLength;

  System(float sF, float pF, float  bF, float rS, float roi, float rL) {
    springFactor = sF;
    planarFactor = pF;
    bulgeFactor = bF;
    repulsionStrength = rS;
    radioOfInfluence = roi;
    restLength = rL;

    arrange();
  }

  void update() {
    distributeFood();
    computeCellSplits();
    updateCellForces();
  }

  void distributeFood() {
    randomUniformDistribution();
    //byCurvature();
  }

  void computeCellSplits() {
    splitRandomLink();
  }

  void updateCellForces() {
    int s = cells.size();

    for (int i = 0; i < s; i++) {
      Cell c = cells.get(i);
      c.updateTargets();
    }

    for (int i = 0; i < s; i++) {
      Cell c = cells.get(i);
      c.updatePosition();
    }
  }  

  void draw() {
    for (int i = 0; i < cells.size(); i++) {
      Cell c = cells.get(i);
      c.draw();
    }
  }

  private void arrange() {
    cells = arrangeInCircle(this);
    //cells = arrangeInSpikes(this);
  }
}
